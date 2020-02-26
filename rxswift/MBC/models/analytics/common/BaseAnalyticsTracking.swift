//
//  AnalyticsTrackingObject.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class BaseAnalyticsTracking {

    let maximumSupportedLength = 100
    
    private var environment: String {
        return Components.config.environment
    }
  
    func getBaseParameters(trackingObject: IAnalyticsTrackingObject) -> [String: Any] {
        return [AnalyticsOtherVariable.environment.rawValue: environment,
                AnalyticsOtherVariable.eventCategory.rawValue: trackingObject.eventCategory]
    }

}
