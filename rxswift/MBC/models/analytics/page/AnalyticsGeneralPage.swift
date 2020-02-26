//
//  AnalyticsPage.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsGeneralPage: BaseAnalyticsTracking {

    private let pageAddress: String
    private let pageTitle: String
    private let pageType: String
    private let pageLanguage: String
    private let pageContentID: String

    init(pageDetail: PageDetail, pageAddress: String) {
        self.pageAddress = pageAddress
        self.pageTitle = pageDetail.title
        self.pageType = pageDetail.type
        self.pageLanguage = pageDetail.language ?? ""
        self.pageContentID = pageDetail.entityId
    }

    init(page: Page) {
        self.pageAddress = page.universalUrl ?? ""
        self.pageTitle = page.name ?? page.title ?? ""
        self.pageType = page.pageType ?? ""
        self.pageLanguage = ""
        self.pageContentID = page.uuid ?? page.contentId ?? ""
    }
    
}

extension AnalyticsGeneralPage: IAnalyticsTrackingObject {

    var contendID: String? {
        return pageContentID
    }

    var eventName: String {
        return AnalyticsEventName.pageView.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.pageMetadata.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsOtherVariable.pageAddress.rawValue: pageAddress,
                       AnalyticsPageVariable.pageTitle.rawValue: pageTitle,
                       AnalyticsPageVariable.pageType.rawValue: pageType,
                       AnalyticsPageVariable.pageLanguage.rawValue: pageLanguage,
                       AnalyticsPageVariable.pageContentID.rawValue: pageContentID
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [AnalyticsOtherVariable.screenPath.rawValue: pageAddress,
                AnalyticsOtherVariable.screenAddress.rawValue: pageAddress,
                "pge_pageName": pageTitle,
                "pge_pageType": pageType
        ]
    }

}
