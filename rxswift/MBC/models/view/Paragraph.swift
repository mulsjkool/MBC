//
//  Paragraph.swift
//  MBC
//
//  Created by azuniMac on 12/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Paragraph: Codable {
    var type = ParagraphType.unknown
    var description: String
    var title: String
    var media: Media?
    var isTextExpanded = false
    var defaultImageId: String?
    var codeSnippet: String?
    var label: String?
    
    // video
    var video: Video?
    // end video
    
    var embeddedViewHeight: CGFloat = 0
    
    init(entity: ParagraphEntity) {
        if let eType = entity.type, let pType = ParagraphType(rawValue: eType) {
            type = pType
        }
        
        description = entity.description ?? ""
        title = entity.title ?? ""
        codeSnippet = entity.codeSnippet
        label = entity.label
        
        self.media = entity.media == nil ? nil : Media(entity: entity.media!, albumTitle: title)
		
		let durationS = Common.convertDurationToSeconds(data: entity.duration)
		
        if type == .video {
            if let video = entity.video {
                self.media = Video(entity: video)
            } else {
                self.video = Video(title: entity.title, rawFile: entity.rawFile, duration: durationS,
								   url: entity.url, videoThumbnail: entity.videoThumbnail)
                self.video?.description = description
                self.video?.contentType = type.rawValue
                self.video?.id = entity.videoId ?? ""
            }
        }
    }

	// It's only for the Ads placeholder
    init() {
        self.type = .ads
        self.description = ""
        self.title = ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case description
        case title
        case media
        case defaultImageId
        case codeSnippet
        case label
        case video
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try ParagraphType(rawValue: container.decode(String.self, forKey: .type))!
        self.description = try container.decode(String.self, forKey: .description)
        self.title = try container.decode(String.self, forKey: .title)
        self.media = try container.decode(Media?.self, forKey: .media)
        self.defaultImageId = try container.decode(String?.self, forKey: .defaultImageId)
        self.codeSnippet = try container.decode(String?.self, forKey: .codeSnippet)
        self.label = try container.decode(String?.self, forKey: .label)
        self.video = try container.decode(Video?.self, forKey: .video)
       
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(description, forKey: .description)
        try container.encode(title, forKey: .title)
        try container.encode(media, forKey: .media)
        try container.encode(defaultImageId, forKey: .defaultImageId)
        try container.encode(codeSnippet, forKey: .codeSnippet)
        try container.encode(label, forKey: .label)
        try container.encode(video, forKey: .video)
    }
}
