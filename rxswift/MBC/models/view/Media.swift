//
//  Media.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/12/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum MediaType: String {
    case image, video
}

class Media: Likable {
    var id: String
    var uuid: String
    var description: String?
    var sourceLink: String?
    var sourceLabel: String?
    var universalUrl: String
    var label: String?
    var interests: [Interest]?
    var hasTag2Page: Bool
    var publishedDate: Date
    var tags: String?
    var link: String
    var originalLink: String
    var numberOfLikes: Int
    var numberOfComments: Int
    var taggedPages: [MenuPage]?
    var isTaggedPageExpanded = false
    
	var isTextExpanded = false
    var isInterestExpanded = false
    var isGettingTaggedPages = false
    
    var albumTitle: String?
    var resoureVersion: String?
	var adsUrl: String?
    
    var isAGif: Bool {
        return originalLink.isGifFileName
    }
    
    init(entity: MediaEntity, albumTitle: String? = "") {
        self.id = entity.id
        self.uuid = entity.uuid
        self.description = entity.description
        self.sourceLink = entity.sourceLink
        self.sourceLabel = entity.sourceLabel
        self.universalUrl = entity.universalUrl ?? ""
        self.label = entity.label
        self.interests = entity.interests?.map { Interest(entity: $0) }
        self.hasTag2Page = entity.hasTag2Page
        self.publishedDate = entity.publishedDate.toDate()
        self.tags = entity.tags
        self.link = entity.link
        self.originalLink = entity.originalLink
        
        self.albumTitle = albumTitle
        self.numberOfLikes = entity.numberOfLikes
        self.numberOfComments = entity.numberOfComments
        super.init(liked: entity.liked, contentId: self.uuid, contentType: MediaType.image.rawValue)
    }
    
    init(entity: VideoEntity) {
        self.id = entity.id
        self.uuid = entity.uuid
        self.hasTag2Page = entity.hasTag2Page
        self.universalUrl = entity.universalUrl ?? ""
        self.originalLink = entity.originalLink.isEmpty ? ((entity.url != nil) ? entity.url! : "") : ""
		self.adsUrl = entity.adsUrl
        
        self.description = entity.description
        self.sourceLink = entity.sourceLink
        self.sourceLabel = entity.sourceLabel
        self.label = entity.label
        self.interests = entity.interests?.map { Interest(entity: $0) }
        self.publishedDate = entity.publishedDate.toDate()
        self.tags = entity.tags
        self.link = entity.link
        self.numberOfLikes = entity.numberOfLikes
        self.numberOfComments = entity.numberOfComments
        super.init(liked: entity.liked, contentId: entity.contentId ?? "",
                   contentType: FeedType.post.rawValue)
    }
    
    init(entity: ImageEntity, albumTitle: String? = "") {
        self.id = entity.id.isEmpty ? entity.tryToGetMediaIdFromUrl() : entity.id
        self.uuid = entity.uuid
        self.hasTag2Page = entity.hasTag2Page
        self.universalUrl = entity.universalUrl
        self.originalLink = entity.url.isEmpty ? entity.originalLink : entity.url
        
        self.description = entity.description
        self.sourceLink = entity.sourceLink
        self.sourceLabel = entity.sourceLabel
        self.label = entity.label
        self.interests = entity.interests?.map { Interest(entity: $0) }
        self.publishedDate = entity.publishedDate
        self.tags = entity.tags
        self.link = entity.link
        self.numberOfLikes = 0
        self.numberOfComments = 0
        self.resoureVersion = entity.getResourceVersion()
        
        super.init(liked: false, contentId: self.uuid.isEmpty ? self.id : self.uuid,
                   contentType: MediaType.image.rawValue)
    }
    
    var imageUrlWithId: String? {
        guard let version = self.resoureVersion else { return nil }
        
        return String("\(version)/\(self.id)")
    }
    
    convenience init(withImageUrl: String) {
        let imageE = ImageEntity(id: "", uuid: "", url: withImageUrl, universalUrl: "", hasTag2Page: false,
                                 description: "", sourceLink: "", sourceLabel: "", label: "", interests: nil,
                                 publishedDate: Date(), tags: nil, link: "", originalLink: withImageUrl)
        self.init(entity: imageE)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case hasTag2Page
        case universalUrl
        case originalLink
        case description
        case sourceLink
        case sourceLabel
        case label
        case interests
        case publishedDate
        case tags
        case link
        case numberOfLikes
        case numberOfComments
        case taggedPages
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        uuid = try container.decode(String.self, forKey: .uuid)
        hasTag2Page = try container.decode(Bool.self, forKey: .hasTag2Page)
        universalUrl = try container.decode(String.self, forKey: .universalUrl)
        originalLink = try container.decode(String.self, forKey: .originalLink)
        description = try container.decode(String?.self, forKey: .description)
        sourceLink = try container.decode(String?.self, forKey: .sourceLink)
        sourceLabel = try container.decode(String?.self, forKey: .sourceLabel)
        label = try container.decode(String?.self, forKey: .label)
        interests = try container.decode([Interest]?.self, forKey: .interests)
        publishedDate = try container.decode(Date.self, forKey: .publishedDate)
        tags = try container.decode(String?.self, forKey: .tags)
        link = try container.decode(String.self, forKey: .link)
        numberOfLikes = try container.decode(Int.self, forKey: .numberOfLikes)
        numberOfComments = try container.decode(Int.self, forKey: .numberOfComments)
        taggedPages = try container.decode([MenuPage]?.self, forKey: .taggedPages)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(hasTag2Page, forKey: .hasTag2Page)
        try container.encode(universalUrl, forKey: .universalUrl)
        try container.encode(originalLink, forKey: .originalLink)
        try container.encode(description, forKey: .description)
        try container.encode(sourceLink, forKey: .sourceLink)
        try container.encode(sourceLabel, forKey: .sourceLabel)
        try container.encode(label, forKey: .label)
        try container.encode(interests, forKey: .interests)
        try container.encode(publishedDate, forKey: .publishedDate)
        try container.encode(tags, forKey: .tags)
        try container.encode(link, forKey: .link)
        try container.encode(numberOfLikes, forKey: .numberOfLikes)
        try container.encode(numberOfComments, forKey: .numberOfComments)
        try container.encode(taggedPages, forKey: .taggedPages)
    }
}
