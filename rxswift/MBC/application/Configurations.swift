//
//  Configurations.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/12/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import UIKit

class Configurations {

    let websiteBaseURL: String
    let apiBaseUrl: String
    let defaultPageSize: Int
    let apiImageUrl: String
    let apiImageVersion: String
    let cacheExpiredTime: Int
    let langugeConfigCacheExpiredTime: Int
	let nextAlbumLoadingTime: Double
	let damId: String
    let gigyaApiKey: String
    let likeDelay: Int
    let environment: String
    let hideVideoControls: Double
    let defaultChannelListPageSize: Int
    let timeSlotInterval: Double
    let scheduleLocalNotificationTime: Int
	let adsTimeOffset: Double
	let minRemainTimeShowAds: Double
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    init(dictionary: NSDictionary) {
        websiteBaseURL = (dictionary["websiteBaseURL"] as? String)!
        apiBaseUrl = (dictionary["apiBaseUrl"] as? String)!
        defaultPageSize = (dictionary["defaultPageSize"] as? Int)!
        cacheExpiredTime = (dictionary["cacheExpiredTime"] as? Int)!
        apiImageUrl = (dictionary["apiImageUrl"] as? String)!
        apiImageVersion = (dictionary["apiImageVersion"] as? String)!
		nextAlbumLoadingTime = (dictionary["naxtAlbumLoadingTime"] as? Double)!
		damId = (dictionary["damId"] as? String)!
        gigyaApiKey = (dictionary["gigyaApiKey"] as? String)!
        likeDelay = (dictionary["likeDelay"] as? Int)!
        environment = (dictionary["environment"] as? String)!
        hideVideoControls = (dictionary["hideVideoControls"] as? Double)!
        defaultChannelListPageSize = (dictionary["defaultChannelListPageSize"] as? Int)!
        timeSlotInterval = (dictionary["intervalTimeSlot"] as? Double)!
        scheduleLocalNotificationTime = (dictionary["scheduleLocalNotificationTime"] as? Int)!
        langugeConfigCacheExpiredTime = (dictionary["langugeConfigCacheExpiredTime"] as? Int)!
		adsTimeOffset = (dictionary["adsTimeOffset"] as? Double)!
		minRemainTimeShowAds = (dictionary["minRemainTimeShowAds"] as? Double)!
    }

}
