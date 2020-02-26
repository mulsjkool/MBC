//
//  HomeStreamEntity.swift
//  MBC
//
//  Created by azuniMac on 12/16/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class HomeStreamEntity {
    var items: [CampaignEntity]
    var total: Int
    
    init(items: [CampaignEntity], total: Int) {
        self.items = items
        self.total = total
    }
}
