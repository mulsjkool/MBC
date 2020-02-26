//
//  PageInforEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageInforEntity {
    var type: String
    var language: String
    var customURL: String
    var posterThumbnail: String
    var website: String
    var coverThumbnail: String
    var internalUniquePageName: String
    var title: String
    var logoThumbnail: String
    var poster: ImageEntity?
    var promoVideo: VideoEntity?
    var geoTargeting: String
    var geoSuggestions: [String]
    
    init(type: String, language: String, customURL: String, posterThumbnail: String, website: String,
        coverThumbnail: String, internalUniquePageName: String, title: String, logoThumbnail: String,
        poster: ImageEntity?, promoVideo: VideoEntity?, geoTargeting: String, geoSuggestions: [String]) {
        self.type = type
        self.language = language
        self.customURL = customURL
        self.posterThumbnail = posterThumbnail
        self.website = website
        self.coverThumbnail = coverThumbnail
        self.internalUniquePageName = internalUniquePageName
        self.title = title
        self.logoThumbnail = logoThumbnail
        self.poster = poster
        self.promoVideo = promoVideo
        self.geoTargeting = geoTargeting
        self.geoSuggestions = geoSuggestions
    }
}
