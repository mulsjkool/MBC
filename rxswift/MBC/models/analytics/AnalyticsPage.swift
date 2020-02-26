//
//  AnalyticsPage.swift
//  MBC
//
//  Created by Tram Nguyen on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsPage: BaseAnalyticsTracking {

    private let trackingObject: IAnalyticsTrackingObject

    init(pageDetail: PageDetail, pageAddress: String) {
        let pageType = PageType(rawValue: pageDetail.type) ?? PageType.other

        if pageType == .show || pageType == .profile || pageType == .channel {
            self.trackingObject = AnalyticsShowPage(pageDetail: pageDetail, pageAddress: pageAddress)
        } else {
            self.trackingObject = AnalyticsGeneralPage(pageDetail: pageDetail, pageAddress: pageAddress)
        }
    }

}

extension AnalyticsPage: IAnalyticsTrackingObject {

    var contendID: String? {
        return trackingObject.contendID
    }

    var eventName: String {
        return trackingObject.eventName
    }

    var eventCategory: String {
        return trackingObject.eventCategory
    }

    var parameters: [String: Any] {
        return trackingObject.parameters
    }

    var customTargeting: [String: String] {
        return trackingObject.customTargeting
    }

}
