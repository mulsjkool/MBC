//
//  AnalyticsError.swift
//  MBC
//
//  Created by Tram Nguyen on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsError: BaseAnalyticsTracking {

    private let errorCode: Int
    private let errorDescription: String

    init(errorCode: Int, errorDescription: String) {
        self.errorCode = errorCode
        self.errorDescription = errorDescription
    }

}

extension AnalyticsError: IAnalyticsTrackingObject {

    var contendID: String? {
        return nil
    }

    var eventName: String {
        return AnalyticsEventName.errorTracking.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.errorException.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        let errDescription = errorDescription.prefix(maximumSupportedLength)
        parameters += [AnalyticsErrorVariable.errorCode.rawValue: errorCode,
                       AnalyticsErrorVariable.errorDescription.rawValue: errDescription
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [:]
    }

}
