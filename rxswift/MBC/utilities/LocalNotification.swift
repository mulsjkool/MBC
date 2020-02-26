//
//  LocalNotification.swift
//  MBC
//
//  Created by admin on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    class func registerForLocalNotification(application: UIApplication) {
        if UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            let notificationCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = Constants.DefaultValue.notificationCategory
            
            //registerting for the notification.
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge],
                                                                                    categories: nil))
        }
    }
    
    class func registerLongTimeNotVisitApp(userInfo: [AnyHashable: Any]? = nil) {
        
        UIApplication.shared.cancelAllLocalNotifications()
        let userObject = Components.sessionRepository.currentSession?.user
        
        var titleNoti = ""
        var bodyNoti = ""
        if userObject?.gender == .male {
            if let name = userObject?.username {
                titleNoti = R.string.localizable.notificationMaleTitle(name).localized()
                bodyNoti = R.string.localizable.notificationMaleBody(Constants.DefaultValue.SiteName).localized()
            } else {
                titleNoti = R.string.localizable.notificationMaleTitle("").localized()
                bodyNoti = R.string.localizable.notificationMaleBody(Constants.DefaultValue.SiteName).localized()
            }
            
        } else {
            if let name = userObject?.username {
                titleNoti = R.string.localizable.notificationFemaleTitle(name).localized()
                bodyNoti = R.string.localizable.notificationFemaleBody(Constants.DefaultValue.SiteName).localized()
            } else {
                titleNoti = R.string.localizable.notificationFemaleTitle("").localized()
                bodyNoti = R.string.localizable.notificationFemaleBody(Constants.DefaultValue.SiteName).localized()
            }
        }
        let atDate = Date.addMinuteFrom(currrentDate: Date(),
                                        minutes: Components.instance.configurations.scheduleLocalNotificationTime)!
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = titleNoti
            content.body = bodyNoti
            content.categoryIdentifier = Constants.DefaultValue.notificationCategory
            
            if let info = userInfo {
                content.userInfo = info
            }
            
            content.sound = UNNotificationSound.default()
            
            let comp = Calendar.current.dateComponents([.hour, .minute], from: atDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
        } else {
            
            let notification = UILocalNotification()
            notification.fireDate = atDate
            notification.alertTitle = titleNoti
            notification.alertBody = bodyNoti
            
            if let info = userInfo {
                notification.userInfo = info
            }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
            
        }
        
        print("WILL DISPATCH LOCAL NOTIFICATION AT ", atDate)
        
    }
}
