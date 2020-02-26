//
//  ListAppJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListAppJsonTransformer: JsonTransformer {
    let feedJsonTransformer: FeedJsonTransformer
    
    init(feedJsonTransformer: FeedJsonTransformer) {
        self.feedJsonTransformer = feedJsonTransformer
    }
    
    private static let fields = (
        mapCampaign : "mapCampaign",
        publishedDate : "publishedDate",
        type : "type",
        placementMode : "placementMode",
        segmentSize: "segmentSize",
        campaignType : "campaignType",
        campaignMode: "campaignMode",
        contentResult: "contentResult",
        title: "title",
        uuid: "uuid",
        results: "results"
    )
    
    func transform(json: JSON) -> [FeedEntity] {
        let fields = ListAppJsonTransformer.fields
        let mapCampaigns = json[fields.mapCampaign].dictionaryValue.mapValues { jsonList -> [CampaignEntity] in

            return jsonList.arrayValue.map { json -> CampaignEntity in
                let publishedDate = json[fields.publishedDate] == JSON.null ? nil :
                    Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)

                let entity = CampaignEntity(type: json[fields.type].stringValue)
                entity.placementMode = json[fields.placementMode].stringValue
                entity.segmentSize = json[fields.segmentSize].intValue
                entity.campaignType = json[fields.campaignType].stringValue
                entity.campaignMode = json[fields.campaignMode].stringValue
                entity.contentResult = json[fields.contentResult].intValue
                entity.title = json[fields.title].stringValue
                entity.uuid = json[fields.uuid].stringValue
                entity.publishedDate = publishedDate

                return entity
            }
        }
        return (json[fields.results] != JSON.null) ? json[fields.results].arrayValue.map({ json -> FeedEntity in
            let entity = feedJsonTransformer.transform(json: json)
            entity.mapCampaign = mapCampaigns[entity.id]
            return entity
        }) : []
    }
}
