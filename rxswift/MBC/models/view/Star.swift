//
//  Star.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class Star: Codable {
    var id: String
    var title: String
    var publishedDate: Date
    var photo: Media?
    var occupations: [String]?
    var metadata: String?
    var numberOfFollow: Int = 0
    var universalUrl: String
    
    init(entity: PageDetailEntity) {
        self.id = entity.id
        self.universalUrl = entity.universalUrl
        self.publishedDate = entity.publishedDate
        self.title = entity.pageInfo.title
        self.occupations = entity.pageMetadata.occupations
        if let photo = entity.pageInfo.poster { self.photo = Media(entity: photo) }
    }
	
	init(entity: Page) {
		self.id = entity.uuid ?? ""
		self.publishedDate = entity.publishedDate!
		self.title = entity.name ?? ""
		self.universalUrl = entity.universalUrl ?? ""
		if let photo = entity.poster?.originalLink { self.photo = Media(withImageUrl: photo) }
    }
        
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedDate
        case photo
        case numberOfFollow
        case universalUrl
        case occupations
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(publishedDate, forKey: .publishedDate)
        try container.encode(photo, forKey: .photo)
        try container.encode(numberOfFollow, forKey: .numberOfFollow)
        try container.encode(universalUrl, forKey: .universalUrl)
        try container.encode(occupations, forKey: .occupations)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        publishedDate = try container.decode(Date.self, forKey: .publishedDate)
        photo = try container.decode(Media?.self, forKey: .photo)
        numberOfFollow = try container.decode(Int.self, forKey: .numberOfFollow)
        universalUrl = try container.decode(String.self, forKey: .universalUrl)
        occupations = try container.decode([String]?.self, forKey: .occupations)
    }
}
