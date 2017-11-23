//
//  AppDelegate.swift
//  Events Map
//
//  Created by Alan Luo on 10/26/17.
//  Copyright © 2017 The University of Iowa. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isNotify: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCg6tNKz8buHSdIOITIvC6sLRqWjPUYXXQ")
        GMSPlacesClient.provideAPIKey("AIzaSyCg6tNKz8buHSdIOITIvC6sLRqWjPUYXXQ")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        var mainViewController = UIViewController()
        let userDefault = UserDefaults.standard
        if userDefault.bool(forKey: "GetStarted") {
            mainViewController = MasterViewController()
        } else {
            mainViewController = StartViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        window?.rootViewController = navigationController
        
        registerForPushNotifications()
        
        //window?.rootViewController = UIViewController(nibName: "viewController", bundle: nil)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let host = url.host {
            print(host)
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if (granted) {
                self.isNotify = true
            }
        }
        
        
        // Add notification actions
        let dismissAction = UNNotificationAction(identifier: "dismiss", title: "Dismiss", options: [])
        let openAction = UNNotificationAction(identifier: "openEvent", title: "Details", options: [])
        
        // Add actions to the Event category
        let category = UNNotificationCategory(identifier: "eventCategory", actions: [openAction, dismissAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func getNotificationSettings() -> Bool {
        var auth = false
        
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
            }
            
            if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
            }
            
            if settings.authorizationStatus == .authorized {
                
            }
        })
        return auth
    }
    
    func scheduleNotification(_ event: Event) {
        if (self.isNotify == true) {
            // Calendar Trigger
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .minute, value: -15, to: event.date as Date)
            let dateComp = calendar.dateComponents([ .year, .month, .day, .hour, .minute], from: date!)
            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            
            // Location Trigger
            let latitude = Double(event.geo["latitude"] as String!)
            let longitude = Double(event.geo["longitude"] as String!)
            let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
            region.notifyOnEntry = true
            region.notifyOnExit = false
            let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
            
            // Content
            let content = UNMutableNotificationContent()
            content.title = "Events Map"
            content.body = "test"
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "eventCategory"
            
            // Attachment
            guard let path = Bundle.main.path(forResource: "Elder", ofType: "jpg") else {return}
            let url = URL(fileURLWithPath: path)
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
                
            } catch {
                print("Attachment load failed")
            }
            
            let calendarRequest = UNNotificationRequest(identifier: "eventNotification", content: content, trigger: calendarTrigger)
            
            let locationRequest = UNNotificationRequest(identifier: "eventNotification", content: content, trigger: locationTrigger)
            UNUserNotificationCenter.current().add(calendarRequest) { (error) in
                if (error != nil) {
                    print("Error: \(error?.localizedDescription)")
                }
            }
            UNUserNotificationCenter.current().add(locationRequest) { (error) in
                if (error != nil) {
                    print("Error: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    func disableNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        isNotify = false
    }
}

