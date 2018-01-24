//
//  notification.swift
//  Events Map
//
//  Created by Yizhen Chen on 1/23/18.
//  Copyright © 2018 The University of Iowa. All rights reserved.
//

import UIKit
import UserNotifications

extension UIViewController {
    func scheduleNotification(_ event: Event) {
        
        let center = UNUserNotificationCenter.current()
        
        // Get the date from event
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -15, to: event.date as Date)
        let dateComp = calendar.dateComponents([ .year, .month, .day, .hour, .minute], from: date!)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: dateComp.year, month: dateComp.month, day: dateComp.day, hour: dateComp.hour, minute: dateComp.minute)
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        // Attachment
//        let url = Bundle.main.url(forResource: "WechatIMG4", withExtension: "jpeg")
//        let attachment = try! UNNotificationAttachment(identifier: "image", url: url!, options: [:])
        
        // Content
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.subtitle = event.location
        var badgeCount = 0
        center.getPendingNotificationRequests { (requests) in
            badgeCount = requests.count
        }
        content.badge =  badgeCount + 1 as NSNumber
        content.body = "Event starts in 15 minutes"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "eventCategory"
        
        
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
