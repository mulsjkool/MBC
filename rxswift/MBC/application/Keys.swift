//
//  Keys.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

struct Keys {
    struct Notification {
        static let openStarPageListingVC = NSNotification.Name(rawValue: "key.notification.openStarPageListingVC")
        static let openPreviousTab = NSNotification.Name(rawValue: "key.notification.open_previous_tab")
        static let openTabAppsAndGames = NSNotification.Name(rawValue: "key.notification.open_tab_appsAndGames")
        static let openTabVideos = NSNotification.Name(rawValue: "key.notification.open_tab_videos")
        static let openTabStream = NSNotification.Name(rawValue: "key.notification.open_tab_stream")
        static let openTabScheduler = NSNotification.Name(rawValue: "key.notification.open_tab_scheduler")
        static let navigateUniversalLink = NSNotification.Name(rawValue: "key.notification.navigateUniversalLink")
        static let videoWillTerminate = NSNotification.Name(rawValue: "key.notification.videoWillTerminate")
		static let audioWillTerminate = NSNotification.Name(rawValue: "key.notification.audioWillTerminate")
    }
}
