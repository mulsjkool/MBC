//
//  IAnalyticsTrackingCell.swift
//  MBC
//
//  Created by Tram Nguyen on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol IAnalyticsTrackingCell {
    func getTrackingObjects() -> [IAnalyticsTrackingObject]
}
