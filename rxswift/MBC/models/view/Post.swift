//
//  Post.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import UIKit

class Post: Feed {
    var description: String?
    var codeSnippet: String?
	var medias: [Media]?
    var defaultImageId: String?
    var paragraphTitle: String?
    var appStore: String?
    var episodeTitle: String?
    var episodeThumbnail: String?
    
    // custom fields
    var embeddedViewHeight: CGFloat = 0

    var postSubType: FeedSubType? {
        guard let sType = self.subType else { return nil }
        return FeedSubType(rawValue: sType)
    }
    
    // swiftlint:disable cyclomatic_complexity
    override init(entity: FeedEntity) {
        super.init(entity: entity)
        if let firstP = entity.paragraphs?.first {
            self.description = firstP.description
            self.codeSnippet = firstP.codeSnippet
            if postSubType == .video {
                var videoObj: Video?
                if let videoEntity = entity.video {
                     videoObj = Video(entity: videoEntity)
                } else if let video = Paragraph(entity: firstP).video { videoObj = video }
                if let videoObj = videoObj {
                    videoObj.author = self.author
                    self.medias = [videoObj]
                }
            } else {
                if let images = firstP.images { self.medias = images.map { Media(entity: $0) }
                } else if let mediaEntity = firstP.media {
                    self.medias = [Media(entity: mediaEntity )]
                }
                // getting from ContentPage firstP.description is nil
                if self.description == nil { self.description = self.medias?.first?.description }
            }
            self.defaultImageId = firstP.defaultImageId
            self.paragraphTitle = firstP.title
            self.appStore = firstP.appStore
            self.episodeTitle = firstP.episodeTitle
            self.episodeThumbnail = firstP.episodeThumbnail
        } else {
            self.appStore = entity.appStore
            self.episodeTitle = entity.episodeTitle
            self.description = entity.episodeDescription
            self.codeSnippet = entity.episodeCodeSnippet
            self.episodeThumbnail = entity.episodeThumbnail
        }
        
        if let relatedContent = entity.relatedContent {
            self.description = relatedContent.description
            if let videoEntity = relatedContent.video {
                if let subTypeStr = self.subType, let subType = FeedSubType(rawValue: subTypeStr), subType == .video {
                    let video = Video(entity: videoEntity)
                    self.medias = [video]
                } else {
                    if let videoThumbnail = videoEntity.videoThumbnail {
                        let photo = Media(withImageUrl: videoThumbnail)
                        self.medias = [photo]
                    }
                }
            } else {
                if let photoEntity = relatedContent.photo {
                    let photo = Media(entity: photoEntity)
                    self.medias = [photo]
                }
            }
            self.label = relatedContent.label
            if let pageEntity = relatedContent.page {
                self.author = Author(pageEntity: pageEntity)
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case description
        case mediaCacheHolders
        case defaultImageId
        case codeSnippet
        case paragraphTitle
        case appStore
        case episodeTitle
        case episodeThumbnail
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            if let mediaCacheHolders = try container.decode([MediaCacheHolder]?.self, forKey: .mediaCacheHolders) {
                self.medias = mediaCacheHolders.map({ $0.toMedia() })
            }
        } catch {
            print("decode error caught: \(error)")
            // some posts may not have medias (post text)
        }
        
        self.defaultImageId = try container.decode(String?.self, forKey: .defaultImageId)
        self.description = try container.decode(String?.self, forKey: .description)
        self.paragraphTitle = try container.decode(String?.self, forKey: .paragraphTitle)
        self.appStore = try container.decode(String?.self, forKey: .appStore)
        self.episodeTitle = try container.decode(String?.self, forKey: .episodeTitle)
        self.episodeThumbnail = try container.decode(String?.self, forKey: .episodeThumbnail)
        self.codeSnippet = try container.decode(String?.self, forKey: .codeSnippet)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        if let medias = self.medias {
            let mediaCacheHolders = medias.map({ MediaCacheHolder(item: $0) })
            try container.encode(mediaCacheHolders, forKey: .mediaCacheHolders)
        }
        try container.encode(defaultImageId, forKey: .defaultImageId)
        try container.encode(codeSnippet, forKey: .codeSnippet)
        try container.encode(paragraphTitle, forKey: .paragraphTitle)
        try container.encode(appStore, forKey: .appStore)
        try container.encode(episodeTitle, forKey: .episodeTitle)
        try container.encode(episodeThumbnail, forKey: .episodeThumbnail)
    }
}
