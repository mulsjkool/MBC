//
//  CampaignEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class CampaignEntity: FeedEntity {
    var placementMode: String!
    var segmentSize: Int!
    var campaignType: String!
    var campaignMode: String!
    var contentResult: Int!
    
    var items: [FeedEntity]!
}
