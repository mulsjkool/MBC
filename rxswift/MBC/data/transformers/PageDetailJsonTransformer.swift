//
//  PageDetailJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import SwiftyJSON
import UIKit

class PageDetailJsonTransformer: JsonTransformer {

    let pageInforJsonTransformer: PageInforJsonTransformer
    let pageSettingJsonTransformer: PageSettingJsonTransformer
    let pageMetadataJsonTransformer: PageMetadataJsonTransformer
    let feedJsonTransformer: FeedJsonTransformer

    init(pageInforJsonTransformer: PageInforJsonTransformer,
         pageSettingJsonTransformer: PageSettingJsonTransformer,
         pageMetadataJsonTransformer: PageMetadataJsonTransformer,
         feedJsonTransformer: FeedJsonTransformer) {
        self.pageInforJsonTransformer = pageInforJsonTransformer
        self.pageSettingJsonTransformer = pageSettingJsonTransformer
        self.pageMetadataJsonTransformer = pageMetadataJsonTransformer
        self.feedJsonTransformer = feedJsonTransformer
    }

    private static let fields = (
        entityId: "entityId",
        id: "id",
        status: "status",
        publishedDate: "publishedDate",
        type: "type",
        createdDate: "createdDate",
        data: "data",
        universalUrl: "universalUrl",
        info: "info",
        meta: "meta",
        settings: "settings",
        bundles: "bundles"
    )

    func transform(json: JSON) -> PageDetailEntity {
        let fields = PageDetailJsonTransformer.fields

        let entityId = json[fields.entityId].stringValue
        let id = json[fields.id].stringValue
        let status = json[fields.status].stringValue
        let publishedDate = Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let type = json[fields.type].stringValue
        let createdDate = Date(timeIntervalSince1970: json[fields.createdDate].doubleValue / 1000)
        let universalUrl = json[fields.universalUrl].stringValue
        var pageInfoJson = json[fields.data][fields.info]
        if pageInfoJson == JSON.null {
            pageInfoJson = json[fields.info]
        }
        let pageInfo = pageInforJsonTransformer.transform(json: pageInfoJson)
        var pageSettingJson = json[fields.data][fields.settings]
        if pageSettingJson == JSON.null {
            pageSettingJson = json[fields.settings]
        }
        let pageSetting = pageSettingJsonTransformer.transform(json: pageSettingJson)
        var pageMetadataJson = json[fields.data][fields.meta]
        if pageMetadataJson == JSON.null {
            pageMetadataJson = json[fields.meta]
        }
        let pageMetadata = pageMetadataJsonTransformer.transform(json: pageMetadataJson)
        let bundles = json[fields.bundles] == JSON.null ? nil :
            json[fields.bundles].arrayValue.map { feedJsonTransformer.transform(json: $0) }

        return PageDetailEntity(id: id, entityId: entityId, status: status, publishedDate: publishedDate,
                                type: type, createdDate: createdDate, universalUrl: universalUrl,
                                pageInfo: pageInfo, pageSetting: pageSetting, pageMetadata: pageMetadata,
                                bundles: bundles)
    }
}
