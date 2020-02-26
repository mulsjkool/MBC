//
//  AnalyticsCategory.swift
//  MBC
//
//  Created by Tram Nguyen on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum AnalyticsEventCategory: String {
    case content = "Content"
    case pageMetadata = "Page Metadata"
    case showMetadata = "Show Metadata"
    case appMetadata = "Apps Metadata"
    case campaignMetadata = "Campaign Metadata"
    case userActivity = "User Activity"
    case errorException = "GA Error Exception"
    case video
    case audio
    case other = "Other"
}
