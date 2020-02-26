//
//  AnlyticsApp.swift
//  MBC
//
//  Created by Tram Nguyen on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsApp: BaseAnalyticsTracking {

    private let appName: String
    private let appId: String
    private let appType: String
    private let appSubType: String
    private let publicationDate: Double
    private let pageAddress: String

    init(app: App) {
        self.appName = app.title ?? ""
        self.appId = app.uuid ?? app.contentId ?? app.whitePageUrl ?? ""
        self.appType = app.type
        self.appSubType = app.subType ?? ""
        self.publicationDate = app.publishedDate?.milliseconds ?? 0
        self.pageAddress = app.universalUrl ?? ""
    }

}

extension AnalyticsApp: IAnalyticsTrackingObject {

    var contendID: String? {
        return appId
    }

    var eventName: String {
        return AnalyticsEventName.pageView.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.appMetadata.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsAppVariable.appId.rawValue: appId,
                       AnalyticsAppVariable.publishDate.rawValue: publicationDate,
                       AnalyticsAppVariable.appSubType.rawValue: appSubType,
                       AnalyticsAppVariable.appTitle.rawValue: appName,
                       AnalyticsAppVariable.appType.rawValue: appType
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [AnalyticsOtherVariable.screenPath.rawValue: pageAddress,
                AnalyticsOtherVariable.screenAddress.rawValue: pageAddress,
                "pge_pageName": appName,
                "pge_pageType": appType
        ]
    }

}
