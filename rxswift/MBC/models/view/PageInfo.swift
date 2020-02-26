//
//  PageInfo.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class PageInfo: Codable {
    var type: String
    var language: String
    var customURL: String
    var posterThumbnail: String
    var website: String
    var coverThumbnail: String
    var internalUniquePageName: String
    var title: String
    var logoThumbnail: String
    var geoTargeting: String
    var geoSuggestions: [String]
    
    init(entity: PageInforEntity) {
        self.type = entity.type
        self.language = entity.language
        self.customURL = entity.customURL
        self.posterThumbnail = entity.posterThumbnail
        self.website = entity.website
        self.coverThumbnail = entity.coverThumbnail
        self.internalUniquePageName = entity.internalUniquePageName
        self.title = entity.title
        self.logoThumbnail = entity.logoThumbnail
        self.geoTargeting = entity.geoTargeting
        self.geoSuggestions = entity.geoSuggestions
    }
}
