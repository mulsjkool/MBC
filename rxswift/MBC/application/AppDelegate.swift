//
//  AppDelegate.swift
//  MBC
//
//  Created by Dao Le Quang on 11/23/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import Fabric
import Crashlytics
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var universalLink: String?
    
    private let appUpgradeVersionService: AppUpgradeService = Components.upgradeVersionService
    private var sessionService: SessionService! = Components.sessionService
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        Components.languageRepository.setLanguage(language: .arabic)
        
        self.setupGigyaSDK(application: application, launchingOptions: launchOptions)

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        AppDelegate.hideGTMLogs()

        //Initialize the Moat SDK
        let options = DMSMoatOptions()
        options.locationServicesEnabled = false
        options.idfaCollectionEnabled = false
        options.debugLoggingEnabled = true

        DMSMoatAnalytics.sharedInstance().start(with: options)
        _ = DMSMoatAnalytics.sharedInstance().prepareTracking(Constants.MOATPartnerCode.bannerAds)

        Fabric.with([Crashlytics.self])
        
        //Data will be cleared after the caching storage is full. ( FIFO rules applied).
        //Currently, the storage data is set to 1GB.
        UIImageView.setMaxDiskCacheSize(1024 * 1024 * 1024)
     
        if let userProfile = Components.sessionService.currentUser.value, Components.sessionService.isSessionValid() {
			let analyticsUser = AnalyticsUser(user: userProfile, userActivity: .login)
			Components.analyticsService.logEvent(trackingObject: analyticsUser)
		} else {
			self.openLoginScreen()
		}
        LocalNotification.registerForLocalNotification(application: UIApplication.shared)
        RemoteNotifications.registerForRemoteNotification(application: UIApplication.shared)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        // swiftlint:disable force_cast
        let handled = FBSDKApplicationDelegate.sharedInstance()
            .application(app, open: url,
                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                         annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        NSLog("RECEIVE UNIVERSAL LINKS")
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        // 2
        NSLog("PATH = %@", components.path)
        if Components.sessionService.isSessionValid() {
            defaultNotification.post(name: Keys.Notification.navigateUniversalLink, object: components.path)
        } else {
            universalLink = components.path
        }
        
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        LocalNotification.registerLongTimeNotVisitApp()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if !Components.sessionService.isSessionValid() { self.openLoginScreen() } else {
            appUpgradeVersionService.startGetAppVersion()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Gigya.handleDidBecomeActive()
        FBSDKAppEvents.activateApp()
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        defaultNotification.post(name: Keys.Notification.videoWillTerminate, object: nil)
		defaultNotification.post(name: Keys.Notification.audioWillTerminate, object: nil)
        
        LocalNotification.registerLongTimeNotVisitApp()
    }
	
	func application(_ application: UIApplication,
					 supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		if let rootViewController = Common.topViewControllerWithRootViewController(rootViewController:
			window?.rootViewController) {
			if rootViewController is FullScreenImagePostViewController {
				// Unlock landscape view orientations for this view controller
				return .allButUpsideDown
			}
		}
        
        if Constants.Singleton.isiPad { return .landscape }
        
        if Constants.Singleton.isAInlineVideoPlaying { return .allButUpsideDown }
		
		// Only allow portrait (standard behaviour)
		return .portrait
	}
	
    // MARK: - Open screen
    
    func openLoginScreen() {
        let vc = LoginViewController(nibName: R.nib.loginViewController.name, bundle: nil)
        self.window?.rootViewController = vc
    }
    
    func openHomeScreen() {
        let navigationController = R.storyboard.main.instantiateInitialViewController()
        self.window?.rootViewController = navigationController
    }
    
    // MARK: - Private methods
    
    private func setupGigyaSDK(application: UIApplication, launchingOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Gigya.initWithAPIKey(Components.instance.configurations.gigyaApiKey, application: application,
                             launchOptions: launchingOptions)
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
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        sessionService.deviceToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

extension AppDelegate { //// GTM hide log
    //// Referred from https://stackoverflow.com/a/45411324/3509183
    static func hideGTMLogs() {
        let tagClass: AnyClass? = NSClassFromString("TAGLogger")
        
        let originalSelector = NSSelectorFromString("info:")
        let detourSelector = #selector(AppDelegate.detour_info(message:)) //@selector(detour_info:);
        
        guard let originalMethod = class_getClassMethod(tagClass, originalSelector),
            let detourMethod = class_getClassMethod(AppDelegate.self, detourSelector) else { return }
        
        class_addMethod(tagClass, detourSelector,
                        method_getImplementation(detourMethod), method_getTypeEncoding(detourMethod))
        method_exchangeImplementations(originalMethod, detourMethod)
    }
    
    @objc
    static func detour_info(message: String) {
//        print("ktest-GTM message-\(message)")
        return
    }
}
