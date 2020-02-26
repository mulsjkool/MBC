//
//  Article.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import UIKit

class Article: Feed {
    var photo: Media!
    var description: String!
    var paragraphs: [Paragraph]!
    var paragraphViewOption = ParagraphViewOptionEnum.standard
    
    override init(entity: FeedEntity) {
        super.init(entity: entity)
        
        if let photo = entity.photo {
            self.photo = Media(entity: photo)
        } else {
            if let thumbnail = entity.thumbnail {
                self.photo = Media(withImageUrl: thumbnail)
            }
        }
        
        if let desc = entity.description {
            description = desc
        }
        
        if let paras = entity.paragraphs {
            paragraphs = paras.map { Paragraph(entity: $0) }
            // MBCM-2672 filter out unsupported types
            // TODO: TO BE REMOVED
            paragraphs =
                paragraphs.filter { $0.type == .text || $0.type == .image || $0.type == .embed || $0.type == .video }
        }
        
        if let paragraphViewOption = entity.paragraphViewOption {
            self.paragraphViewOption = ParagraphViewOptionEnum(rawValue: paragraphViewOption)
                ?? ParagraphViewOptionEnum.standard
        }
        
        if let pageEntity = entity.page {
            self.author = Author(pageEntity: pageEntity)
        }
        
        if let relatedContent = entity.relatedContent {
            self.description = relatedContent.description
            if let photoEntity = relatedContent.photo {
                self.photo = Media(entity: photoEntity)
            }
            self.label = relatedContent.label
            if let pageEntity = relatedContent.page {
                self.author = Author(pageEntity: pageEntity)
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case photo
        case description
        case paragraphs
        case paragraphViewOption
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String?.self, forKey: .description)
        self.photo = try container.decode(Media?.self, forKey: .photo)
        self.paragraphs = try container.decode([Paragraph]?.self, forKey: .paragraphs)
        self.paragraphViewOption = try ParagraphViewOptionEnum(rawValue:
            container.decode(Int.self, forKey: .paragraphViewOption))!
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(photo, forKey: .photo)
        try container.encode(paragraphs, forKey: .paragraphs)
        try container.encode(paragraphViewOption.rawValue, forKey: .paragraphViewOption)
    }
}
