//
//  RemoteNotification.swift
//  MBC
//
//  Created by admin on 3/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import UserNotifications

class RemoteNotifications: NSObject, UNUserNotificationCenterDelegate {
    
    private var sessionService: SessionService! = Components.sessionService

    class func registerForRemoteNotification(application: UIApplication) {
        
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = Constants.Singleton.appDelegate
            center.requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted {
                    //Do stuff here..
                    
                    //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    //Handle user denying permissions..
                }
            }
            application.registerForRemoteNotifications()
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        //Handle the notification
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print(deviceTokenString)
        sessionService.deviceToken = deviceTokenString
        _ = Components.authenticationService.registerRemoteNotification()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
}
