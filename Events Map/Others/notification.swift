//
//  notification.swift
//  Events Map
//
//  Created by Yizhen Chen on 1/23/18.
//  Copyright © 2018 The University of Iowa. All rights reserved.
//

import UIKit
import UserNotifications

// Schedule notification with event
extension UIViewController {
    func scheduleNotification(_ event: Event) {
        
        let center = UNUserNotificationCenter.current()
        
        // Get the date from event
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -15, to: event.date as Date)
        let dateComp = calendar.dateComponents([ .year, .month, .day, .hour, .minute], from: date!)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: dateComp.year, month: dateComp.month, day: dateComp.day, hour: dateComp.hour, minute: dateComp.minute)
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        // Content
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.subtitle = event.location
//        var badgeCount = 0
//        center.getPendingNotificationRequests { (requests) in
//            badgeCount = requests.count
//        }
//        content.badge =  badgeCount + 1 as NSNumber
        content.body = "Event starts in 15 minutes"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "eventCategory"
        
        // Attachment
        var image: UIImage?
        DispatchQueue.main.async {
            let imageData = NSData(contentsOf: URL(string: event.photos[0])!)
            image = UIImage(data: imageData! as Data)
            
        }
        
        if image != nil {
            if let attachment = UNNotificationAttachment.createLocalURL(identifier: event.id, image: image!, options: nil) {
                content.attachments = [attachment]
            }
        }
        
        // Schedule a request
        let calendarRequest = UNNotificationRequest(identifier: event.id, content: content, trigger: calendarTrigger)
        
        center.add(calendarRequest) { (error) in
            if error != nil {
                // Something went error
            }
        }
    }
    
    func removeAllNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func removeNotification(_ event: Event) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [event.id])
    }
}

// Get the remote image as attachment
extension UNNotificationAttachment {
    
    static func createLocalURL(identifier: String, image: UIImage, options: [NSObject:AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".png"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            guard let imageData = UIImagePNGRepresentation(image) else {
                return nil
            }
            try imageData.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}
