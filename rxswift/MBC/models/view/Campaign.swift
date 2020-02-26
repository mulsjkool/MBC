//
//  Campaign.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Campaign: Codable {
    var uuid: String?
    var publishedDate: Date?
    var numOfLike: Int?
    var numOfComment: Int?
    var title: String?
    var type: CampaignType
    var items = [Feed]()
    
    var placementMode: String
    var segmentSize: Int
    var campaignType: String
    var campaignMode: String
    var contentResult: Int
    var featureOnStream: Bool
    
    init(campaignEntity: CampaignEntity) {
        self.uuid = campaignEntity.uuid
        self.publishedDate = campaignEntity.publishedDate
        self.numOfLike = campaignEntity.numOfLikes
        self.numOfComment = campaignEntity.numOfComments
        self.title = campaignEntity.title

        self.placementMode = campaignEntity.placementMode
        self.segmentSize = campaignEntity.segmentSize
        self.campaignType = campaignEntity.campaignType
        self.campaignMode = campaignEntity.campaignMode
        self.contentResult = campaignEntity.contentResult
        self.featureOnStream = campaignEntity.featureOnStream
        self.type = .streamCard // temporary value
    }
    
    convenience init(entity: CampaignEntity) {
        self.init(campaignEntity: entity)
        
		if entity.type == CampaignType.ads.rawValue { self.type = .ads; return }
		if entity.type == Constants.DefaultValue.campaignType,
			let campaginType = CampaignType(rawValue: entity.placementMode) {
			self.type = campaginType
		}
		
		switch self.type {
		case .carousel, .singleItem:
			guard let items = entity.items else { return }
			for item in items { if let feed = Common.fetchFeed(entity: item) { self.items.append(feed) } }
		case .streamCard:
			if let item = Common.fetchFeed(entity: entity) { items.append(item) }
		case .ads: break
		}
    }
	
	// For search result
    convenience init(searchEntity entity: CampaignEntity) {
        self.init(campaignEntity: entity)
		if let feedType = FeedType(rawValue: entity.type), (feedType == .playlist || feedType == .bundle) {
			self.type = .singleItem
		}
        if let item = Common.fetchFeed(entity: entity) { items.append(item) }
    }
    
	init(fromEntities entities: [CampaignEntity], title: String) {
		self.type = .carousel
		self.placementMode = self.type.rawValue
		self.title = title
		self.segmentSize = 0
		self.campaignType = CampainResultType.content.rawValue
		self.campaignMode = CampainModeType.manual.rawValue
		self.contentResult = 0
		self.featureOnStream = true
		
		entities.forEach { if let feed = Common.fetchFeed(entity: $0) { self.items.append(feed) } }
	}
    
    private enum CodingKeys: String, CodingKey {
        case uuid
        case publishedDate
        case numOfLike
        case numOfComment
        case title
        case type
        case items
        case placementMode
        case segmentSize
        case campaignType
        case campaignMode
        case contentResult
        case featureOnStream
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(publishedDate, forKey: .publishedDate)
        try container.encode(numOfLike, forKey: .numOfLike)
        try container.encode(numOfComment, forKey: .numOfComment)
        try container.encode(title, forKey: .title)
        try container.encode(items, forKey: .items)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(placementMode, forKey: .placementMode)
        try container.encode(segmentSize, forKey: .segmentSize)
        try container.encode(campaignType, forKey: .campaignType)
        try container.encode(campaignMode, forKey: .campaignMode)
        try container.encode(contentResult, forKey: .contentResult)
        try container.encode(featureOnStream, forKey: .featureOnStream)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(String?.self, forKey: .uuid)
        publishedDate = try container.decode(Date?.self, forKey: .publishedDate)
        type = try CampaignType(rawValue: container.decode(String.self, forKey: .type))!
        numOfLike = try container.decode(Int?.self, forKey: .numOfLike)
        numOfComment = try container.decode(Int?.self, forKey: .numOfComment)
        title = try container.decode(String?.self, forKey: .title)
        
        do {
            let feedItems = try container.decode([FeedItemStruct].self, forKey: .items)
            items = feedItems.map { $0.item }
        } catch {
            print("Deocde error caught: \(error)")
        }
        
        placementMode = try container.decode(String?.self, forKey: .placementMode) ?? ""
        segmentSize = try container.decode(Int?.self, forKey: .segmentSize) ?? 0
        campaignType = try container.decode(String?.self, forKey: .campaignType) ?? ""
        campaignMode = try container.decode(String?.self, forKey: .campaignMode) ?? ""
        contentResult = try container.decode(Int?.self, forKey: .contentResult) ?? 0
        featureOnStream = try container.decode(Bool.self, forKey: .featureOnStream)
    }
}

struct FeedItemStruct: Decodable {
    var item: Feed
    
    enum FeedsKey: String, CodingKey {
        case items
        case type
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: FeedsKey.self)
            
            let feedType = try container.decode(FeedType.self, forKey: FeedsKey.type)
            switch feedType {
            case .post:
                item = try Post(from: decoder)
            case .article:
                item = try Article(from: decoder)
            case .page:
                item = try Page(from: decoder)
            case .app:
                item = try App(from: decoder)
            case .bundle:
                item = try BundleContent(from: decoder)
            case .playlist:
                item = try Playlist(from: decoder)
            default:
                item = try Feed(from: decoder)
            }
        } catch {
            print("caught FeedItemStruct \(error)")
            item = try Feed(from: decoder)
        }
    }
}
