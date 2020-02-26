//
//  AnalyticsBundle.swift
//  MBC
//
//  Created by Tram Nguyen on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsBundle: BaseAnalyticsTracking {
    
    private let bundleId: String?
    private let bundleName: String
    private let pageAddress: String

    init?(bundleContent: BundleContent) {
        self.bundleId = bundleContent.uuid ?? bundleContent.contentId
        
        guard let title = bundleContent.title else {
            return nil
        }
        self.bundleName = title
        self.pageAddress = bundleContent.universalUrl ?? ""
    }

}

extension AnalyticsBundle: IAnalyticsTrackingObject {

    var contendID: String? {
        return bundleId
    }
    
    var eventName: String {
        return AnalyticsEventName.pageView.rawValue
    }
    
    var eventCategory: String {
        return AnalyticsEventCategory.content.rawValue
    }
    
    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)
        
        parameters += [AnalyticsOtherVariable.pageAddress.rawValue: pageAddress,
                       AnalyticsContentVariable.bundleName.rawValue: bundleName
        ]
        
        return parameters
    }

    var customTargeting: [String: String] {
        return [AnalyticsOtherVariable.screenPath.rawValue: pageAddress,
                AnalyticsOtherVariable.screenAddress.rawValue: pageAddress,
                "cnt_bundleName": bundleName
        ]
    }
    
}
