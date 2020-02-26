//
//  Feed.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Feed: Likable {
    var uuid: String?
    var publishedDate: Date?
    var type: String
    var subType: String?
    var numOfLikes: Int?
    var numOfComments: Int?
    var interests: [Interest]?
    var title: String?
    var label: String?
    var universalUrl: String?
    var author: Author?
    var isTextExpanded = false
    var isInterestExpanded = false
    var hasTag2Page: Bool = false
    var tags: [MenuPage]?
    var numberOfImages: Int?
    var isTitleExpanded = false
    var thumbnail: String?
    var featureOnStream: Bool
    var activityCard: ActivityCard?
    var isTaggedPageExpanded = false
    
    init(entity: FeedEntity) {
        self.uuid = entity.uuid ?? ""
        self.publishedDate = entity.publishedDate
        self.type = entity.type
        self.subType = entity.subType
        self.numOfLikes = entity.numOfLikes
        self.numOfComments = entity.numOfComments
        self.title = entity.title
        self.label = entity.label
        self.universalUrl = entity.universalUrl
        self.interests = entity.interests?.map { Interest(entity: $0) }
        self.author = entity.author == nil ? nil : Author(entity: entity.author!)
        self.hasTag2Page = entity.hasTag2Page
        self.numberOfImages = entity.numberOfImages
        if let taggedPages = entity.tags { self.tags = taggedPages.map { MenuPage(entity: $0) } }
        if self.author == nil, let pageEntity = entity.page {
            self.author = Author(pageEntity: pageEntity)
        }
        self.thumbnail = entity.thumbnail
        self.featureOnStream = entity.featureOnStream
        if let activityCardEntity = entity.activityCard {
            self.activityCard = ActivityCard(entity: activityCardEntity)
        }
        super.init(liked: entity.liked, contentId: self.uuid, contentType: self.type)
    }
    
    private enum CodingKeys: String, CodingKey {
        case uuid
        case publishedDate
        case type
        case subType
        case numOfLikes
        case numOfComments
        case interests
        case title
        case label
        case universalUrl
        case author
        case liked
        case hasTag2Page
        case tags
        case numberOfImages
        case thumbnail
        case featureOnStream
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(publishedDate, forKey: .publishedDate)
        try container.encode(type, forKey: .type)
        try container.encode(subType, forKey: .subType)
        try container.encode(numOfLikes, forKey: .numOfLikes)
        try container.encode(numOfComments, forKey: .numOfComments)
        try container.encode(interests, forKey: .interests)
        try container.encode(title, forKey: .title)
        try container.encode(label, forKey: .label)
        try container.encode(universalUrl, forKey: .universalUrl)
        try container.encode(author, forKey: .author)
        try container.encode(liked, forKey: .liked)
        try container.encode(hasTag2Page, forKey: .hasTag2Page)
        try container.encode(tags, forKey: .tags)
        try container.encode(numberOfImages, forKey: .numberOfImages)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(featureOnStream, forKey: .featureOnStream)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String?.self, forKey: .uuid)
        publishedDate = try container.decode(Date?.self, forKey: .publishedDate)
        type = try container.decode(String.self, forKey: .type)
        subType = try container.decode(String?.self, forKey: .subType)
        numOfLikes = try container.decode(Int?.self, forKey: .numOfLikes)
        numOfComments = try container.decode(Int?.self, forKey: .numOfComments)
        interests = try container.decode([Interest]?.self, forKey: .interests)
        title = try container.decode(String?.self, forKey: .title)
        label = try container.decode(String?.self, forKey: .label)
        universalUrl = try container.decode(String?.self, forKey: .universalUrl)
        author = try container.decode(Author?.self, forKey: .author)
        hasTag2Page = try container.decode(Bool.self, forKey: .hasTag2Page)
        tags = try container.decode([MenuPage]?.self, forKey: .tags)
        numberOfImages = try container.decode(Int?.self, forKey: .numberOfImages)
        thumbnail = try container.decode(String?.self, forKey: .thumbnail)
        featureOnStream = try container.decode(Bool.self, forKey: .featureOnStream)
        super.init(liked: try container.decode(Bool.self, forKey: .liked), contentId: uuid, contentType: self.type)
    }
}
