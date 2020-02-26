//
//  IAnalyticsTrackingObject.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol IAnalyticsTrackingObject {

    var contendID: String? { get }
    var eventName: String { get }
    var eventCategory: String { get }
    var parameters: [String: Any] { get }
    var customTargeting: [String: String] { get }
    
}
