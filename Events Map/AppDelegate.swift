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
import GoogleSignIn
import FirebaseCore
import GGLCore
import MaterialComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    var window: UIWindow?
    var isNotify: Bool = false
    
    var userTableViewController: UserTableViewController?
    var loadingView: UIView?
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if let vc = userTableViewController {
            loadingView = vc.activityIndicator("Loading......")
        }
        
        let imageURL = user.profile.imageURL(withDimension: 320)!
        
        UserService.instance.addUser(pid: user.userID, name: user.profile.name, picURL: imageURL.absoluteString, platform:.google) { code, msg, user in
            if let vc = self.userTableViewController {
                self.loadingView?.removeFromSuperview()
                
                if code != "200" {
                    let alert: MDCAlertController = MDCAlertController(title: "Error", message: msg)
                    alert.addAction(MDCAlertAction(title: "OK", handler: nil))
                    
                    vc.present(alert, animated: true)
                    return
                }
                
                let user = user!
                
                let image = UIImage.gif(url: user.picURL)!
                
                vc.UserImage.image = image.resizeImage(targetSize: (vc.UserImage.frame.size))
                vc.UserName.text = user.name
                vc.tableView.reloadData()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        print("Sign out Google" )
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCg6tNKz8buHSdIOITIvC6sLRqWjPUYXXQ")
        GMSPlacesClient.provideAPIKey("AIzaSyCg6tNKz8buHSdIOITIvC6sLRqWjPUYXXQ")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().delegate = self

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
        print(url)
        if url.scheme == "fb444439642616561" {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        if url.scheme == "com.googleusercontent.apps.417113963893-78u5q5ht06mffvbb5s0acj2io2i9vhk9" {
            return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return false
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
        let auth = false
        
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
            print("Notification Scheduled!")
            // Calendar Trigger
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .minute, value: -15, to: event.date as Date)
            let dateComp = calendar.dateComponents([ .year, .month, .day, .hour, .minute], from: date!)
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: dateComp.year, month: dateComp.month, day: dateComp.day, hour: dateComp.hour, minute: dateComp.minute)
            let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            
            // Content
            let content = UNMutableNotificationContent()
            content.title = event.title
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
            
            let calendarRequest = UNNotificationRequest(identifier: "calendarNotification", content: content, trigger: calendarTrigger)
            

            UNUserNotificationCenter.current().add(calendarRequest) { (error) in
                if (error != nil) {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
            
            // Location Trigger (Optional)
            if event.geo["latitude"] != "" {
                let latitude = Double(event.geo["latitude"] as String!)
                let longitude = Double(event.geo["longitude"] as String!)
                let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let region = CLCircularRegion(center: center, radius: 150.0, identifier: "Headquarters")
                region.notifyOnEntry = true
                region.notifyOnExit = false
                let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
                let locationRequest = UNNotificationRequest(identifier: "locationNotification", content: content, trigger: locationTrigger)
                UNUserNotificationCenter.current().add(locationRequest) { (error) in
                    if (error != nil) {
                        print("Error: \(String(describing: error?.localizedDescription))")
                    }
                }
            }
            
        }
    }
    
    func disableNotification() {
        print("Notification Reset")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        isNotify = false
    }
    
    // Returns the most recently presented UIViewController (visible)
    class func getCurrentViewController() -> UIViewController? {
        
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    // Returns the navigation controller if it exists
    class func getNavigationController() -> UINavigationController? {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            
            return navigationController as? UINavigationController
        }
        return nil
    }
}

