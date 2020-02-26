//
//  AnalyticsService.swift
//  MBC
//
//  Created by Tram Nguyen on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol AnalyticsService {
    var customTargeting: [String: String] { get }
    
    func isNotLogged(id: String?) -> Bool
    func logEvent(trackingObject: IAnalyticsTrackingObject)
    func logCells(visibleCells: [UITableViewCell])
}
