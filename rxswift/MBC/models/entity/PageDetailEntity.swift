//
//  PageDetailEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageDetailEntity {
    var id: String
    var entityId: String
    var status: String
    var publishedDate: Date
    var type: String
    var createdDate: Date
    var universalUrl: String
    var pageInfo: PageInforEntity
    var pageSetting: PageSettingEntity
    var pageMetadata: PageMetadataEntity
    var bundles: [FeedEntity]?
    
    init(id: String, entityId: String, status: String, publishedDate: Date, type: String, createdDate: Date,
         universalUrl: String, pageInfo: PageInforEntity, pageSetting: PageSettingEntity,
         pageMetadata: PageMetadataEntity, bundles: [FeedEntity]?) {
        self.status = status
        self.publishedDate = publishedDate
        self.createdDate = createdDate
        self.entityId = entityId
        self.type = type
        self.pageInfo = pageInfo
        self.universalUrl = universalUrl
        self.pageSetting = pageSetting
        self.pageMetadata = pageMetadata
        self.id = id
        self.bundles = bundles
    }
}
