//
//  MediaEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class MediaEntity: Codable {
    var id: String
    var uuid: String
    var description: String?
    var sourceLink: String?
    var sourceLabel: String?
    var universalUrl: String?
    var label: String?
    var interests: [InterestEntity]?
    var hasTag2Page: Bool
    var publishedDate: Double
    var tags: String?
    var link: String
    var originalLink: String
    var numberOfLikes: Int
    var numberOfComments: Int
    var liked: Bool
    
    init(id: String, uuid: String, description: String?,
         sourceLink: String?, sourceLabel: String?, universalUrl: String?,
         label: String?, interests: [InterestEntity]?, hasTag2Page: Bool,
         publishedDate: Double, tags: String?, link: String, originalLink: String,
         numberOfLikes: Int, numberOfComments: Int, liked: Bool) {
        self.id = id
        self.uuid = uuid
        self.description = description
        self.sourceLink = sourceLink
        self.sourceLabel = sourceLabel
        self.universalUrl = universalUrl
        self.label = label
        self.interests = interests
        self.hasTag2Page = hasTag2Page
        self.publishedDate = publishedDate
        self.tags = tags
        self.link = link
        self.originalLink = originalLink
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments
        self.liked = liked
    }
}
