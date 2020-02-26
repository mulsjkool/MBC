//
//  AnalyticsCampaign.swift
//  MBC
//
//  Created by Tram Nguyen on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsCampaign: BaseAnalyticsTracking {

    private let campaignId: String
    private let campaignName: String
    private let campaignSegment: Int
    private let campaignType: String
    private let campaignMode: String
    private let campaignPlacement: String
    private let campaignResult: Int
    private let publicationDate: Double
    
    init(campaign: Campaign) {
        self.campaignId = campaign.uuid ?? ""
        self.campaignName = campaign.title ?? ""
        self.campaignSegment = campaign.segmentSize
        self.campaignType = campaign.campaignType
        self.campaignMode = campaign.campaignMode
        self.campaignPlacement = campaign.placementMode
        self.campaignResult = campaign.contentResult
        self.publicationDate = campaign.publishedDate?.milliseconds ?? 0
    }

}

extension AnalyticsCampaign: IAnalyticsTrackingObject {

    var contendID: String? {
        return campaignId
    }

    var eventName: String {
        return AnalyticsEventName.pageView.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.campaignMetadata.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsCampaignVariable.campId.rawValue: campaignId,
                       AnalyticsCampaignVariable.campContentResult.rawValue: publicationDate,
                       AnalyticsCampaignVariable.campMode.rawValue: campaignMode,
                       AnalyticsCampaignVariable.campPlacement.rawValue: campaignPlacement,
                       AnalyticsCampaignVariable.campPublishDate.rawValue: publicationDate,
                       AnalyticsCampaignVariable.campSegment.rawValue: campaignSegment,
                       AnalyticsCampaignVariable.campTitle.rawValue: campaignName,
                       AnalyticsCampaignVariable.campType.rawValue: campaignType
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [:]
    }

}
