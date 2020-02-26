//
//  ContentPageJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class ContentPageJsonTransformer: JsonTransformer {
    let feedJsonTransformer: FeedJsonTransformer
    let pageDetailJsonTransformer: ContentPagePageDetailJsonTransformer
    let videoTransformer: VideoJsonTransformer
    
    init(feedJsonTransformer: FeedJsonTransformer, pageDetailJsonTransformer: ContentPagePageDetailJsonTransformer,
         videoTransformer: VideoJsonTransformer) {
        self.feedJsonTransformer = feedJsonTransformer
        self.pageDetailJsonTransformer = pageDetailJsonTransformer
        self.videoTransformer = videoTransformer
    }
    
    private static let fields = (
        redirectUrl: "redirectUrl",
        type: "type",
        page: "page",
        content: "content",
        video: "video"
    )
    
    func transform(json: JSON) -> ContentPageEntity {
        let fields = ContentPageJsonTransformer.fields
        
        let redirectUrl = json[fields.redirectUrl].string
        let type = json[fields.type].string ?? ""
        let pageDetail = json[fields.page] == JSON.null ? nil :
            pageDetailJsonTransformer.transform(json: json[fields.page])
        let content = json[fields.content] == JSON.null ? nil :
            feedJsonTransformer.transform(json: json[fields.content])
        content?.video = json[fields.content][fields.video] == JSON.null ? nil :
            videoTransformer.transform(json: json[fields.content][fields.video])
        return ContentPageEntity(redirectUrl: redirectUrl, type: type, pageDetail: pageDetail, content: content)
    }
}

class ContentPagePageDetailJsonTransformer: JsonTransformer {
    
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
        universalUrl: "universalUrl",
        info: "info",
        meta: "meta",
        settings: "settings",
        bundles: "bundles"
    )
    
    func transform(json: JSON) -> PageDetailEntity {
        let fields = ContentPagePageDetailJsonTransformer.fields
        
        let entityId = json[fields.entityId].stringValue
        let id = json[fields.id].stringValue
        let status = json[fields.status].stringValue
        let publishedDate = Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let type = json[fields.type].stringValue
        let createdDate = Date(timeIntervalSince1970: json[fields.createdDate].doubleValue / 1000)
        let universalUrl = json[fields.universalUrl].stringValue
        let pageInfo = pageInforJsonTransformer.transform(json: json[fields.info])
        let pageSetting = pageSettingJsonTransformer.transform(json: json[fields.settings])
        let pageMetadata = pageMetadataJsonTransformer.transform(json: json[fields.meta])
        let bundles = json[fields.bundles] == JSON.null ? nil :
            json[fields.bundles].arrayValue.map { feedJsonTransformer.transform(json: $0) }

        return PageDetailEntity(id: id, entityId: entityId, status: status, publishedDate: publishedDate,
                                type: type, createdDate: createdDate, universalUrl: universalUrl,
                                pageInfo: pageInfo, pageSetting: pageSetting, pageMetadata: pageMetadata,
                                bundles: bundles)
    }
}
