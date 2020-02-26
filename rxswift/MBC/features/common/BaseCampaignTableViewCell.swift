//
//  BaseCompaignTableViewCell.swift
//  MBC
//
//  Created by Tram Nguyen on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class BaseCampaignTableViewCell: BaseTableViewCell {
    
    var analyticsCampaigns: [IAnalyticsTrackingObject] = []
    
    func bindMapCampaign(mapCampaign: [Campaign]) {
        analyticsCampaigns = mapCampaign.map { AnalyticsCampaign(campaign: $0) }
    }
    
}
