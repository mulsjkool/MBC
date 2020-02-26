//
//  App.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/8/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class App: Feed {
	var whitePageUrl: String?
	var photo: Media?
	var description: String?
	// add properties key json content
	var link: String!
	var code: String!
	// end add properties key json content
    var mapCampaign: [Campaign]?
	
	override init(entity: FeedEntity) {
		super.init(entity: entity)
		self.whitePageUrl = entity.whitePageUrl
		if let description = entity.description { self.description = description }
		if let photo = entity.photo { self.photo = Media(entity: photo) }
        if let mapCampaign = entity.mapCampaign {
            self.mapCampaign = mapCampaign.map { Campaign(entity: $0) }
        }
        if self.photo == nil, let appPhotoUrl = entity.appPhoto {
            self.photo = Media(withImageUrl: appPhotoUrl)
        }
        self.link = entity.link
        self.code = entity.code
        self.whitePageUrl = entity.whitePageUrl
        
        if let relatedContent = entity.relatedContent {
            self.description = relatedContent.description
            self.label = relatedContent.label
            if let pageEntity = relatedContent.page {
                self.author = Author(pageEntity: pageEntity)
            }
            self.whitePageUrl = relatedContent.whitePageUrl
            if let appPhotoUrl = relatedContent.appPhotoUrl {
                self.photo = Media(withImageUrl: appPhotoUrl)
            }
        }
	}
	
	private enum CodingKeys: String, CodingKey {
        case whitePageUrl
        case photo
        case description
        case link
        case code
	}

	override func encode(to encoder: Encoder) throws {
		try super.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(whitePageUrl, forKey: .whitePageUrl)
        try container.encode(photo, forKey: .photo)
		try container.encode(description, forKey: .description)
        try container.encode(link, forKey: .link)
        try container.encode(code, forKey: .code)
	}
	
	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
		let container = try decoder.container(keyedBy: CodingKeys.self)
		whitePageUrl = try container.decode(String?.self, forKey: .whitePageUrl)
        photo = try container.decode(Media?.self, forKey: .photo)
		description = try container.decode(String?.self, forKey: .description)
        link = try container.decode(String?.self, forKey: .link)
        code = try container.decode(String?.self, forKey: .code)
	}
}
