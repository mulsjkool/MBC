//
//  Page.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import UIKit

class Page: Feed {
    var name: String?
    var avatarUrl: String?
    var poster: Media?
    var cover: Media?
    var headerColor: UIColor?
    
    var liveRecord: String?
    var genreId: String?
    var genreNames: String?
    var pageType: String?
    var pageSubType: String?
    
    var gender: Gender?
    var infoComponentValue: String?
    var metadata: [String: Any?]?
    private var metadataJsonString: String?

    override init(entity: FeedEntity) {
        super.init(entity: entity)
        
        self.name = entity.name
        self.avatarUrl = entity.avatarUrl
        self.poster = entity.poster == nil ? nil : Media(entity: entity.poster!)
        self.cover = entity.cover == nil ? nil : Media(entity: entity.cover!)
        
        if let headerClr = entity.headerColor {
            self.headerColor = UIColor(rgba: headerClr)
        }
        if let header = entity.header {
            self.liveRecord = header.liveRecord
            self.genreId = header.genre.id
            self.genreNames = header.genre.names
        }
        self.pageType = entity.pageType
        self.pageSubType = entity.pageSubType
        self.metadata = entity.metadata
        if let metadata = self.metadata,
            let metadataJsonData = try? JSONSerialization.data(withJSONObject: metadata, options: []) {
            metadataJsonString = String(data: metadataJsonData, encoding: .utf8)
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(poster, forKey: .poster)
        try container.encode(cover, forKey: .cover)
        try container.encode(pageType, forKey: .pageType)
        try container.encode(pageSubType, forKey: .pageSubType)
        try container.encode(liveRecord, forKey: .liveRecord)
        try container.encode(genreNames, forKey: .genreNames)
        try container.encode(genreId, forKey: .genreId)
        try container.encode(headerColor?.toHex(), forKey: .headerColor)
        try container.encode(metadataJsonString, forKey: .metadataJsonString)
        
        try super.encode(to: encoder)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String?.self, forKey: .name)
        avatarUrl = try container.decode(String?.self, forKey: .avatarUrl)
        poster = try container.decode(Media?.self, forKey: .poster)
        cover = try container.decode(Media?.self, forKey: .cover)
        pageType = try container.decode(String?.self, forKey: .pageType)
        pageSubType = try container.decode(String?.self, forKey: .pageSubType)
        liveRecord = try container.decode(String?.self, forKey: .liveRecord)
        genreId = try container.decode(String?.self, forKey: .genreId)
        genreNames = try container.decode(String?.self, forKey: .genreNames)
        if let color = try container.decode(String?.self, forKey: .headerColor) {
            self.headerColor = UIColor(rgba: color)
        }
        metadataJsonString = try container.decode(String?.self, forKey: .metadataJsonString)
        if let jsonData = metadataJsonString?.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) {
            metadata = json as? [String: Any?]
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case avatarUrl
        case poster
        case cover
        case pageType
        case pageSubType
        case headerColor
        case liveRecord
        case genreId
        case genreNames
        case metadataJsonString
    }
}
