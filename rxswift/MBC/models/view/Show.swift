//
//  Show.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class Show: Codable {
    var id: String
    var title: String?
    var universalUrl: String?
    var posterUrl: String?
    var genres: [String]?
    var seasonNumber: String?
    var sequelNumber: String?
    var subType: String?
    
    init(entity: PageDetailEntity) {
        self.id = entity.id
        self.universalUrl = entity.universalUrl
        self.title = entity.pageInfo.title
        self.posterUrl = entity.pageInfo.posterThumbnail
        self.genres = entity.pageMetadata.genres
        self.seasonNumber = entity.pageMetadata.seasonNumber
        self.sequelNumber = entity.pageMetadata.sequelNumber
        self.subType = entity.pageMetadata.pageSubType
    }
}
