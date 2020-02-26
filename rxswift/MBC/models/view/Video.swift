//
//  Video.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class Video: Media {
    var title: String?
    var rawFile: String?
    var videoThumbnail: String?
    var author: Author?
    var duration: Int?
    
    // custom attribute
    var currentTime = Variable<Double>(0) // for restoring playback position
    var hasEnded = Variable<Bool>(false) // for restoring playback position
    
    override init(entity: VideoEntity) {
        self.title = entity.title
        self.rawFile = entity.rawFile
        self.videoThumbnail = entity.videoThumbnail
        if let authorE = entity.author {
            self.author = Author(entity: authorE)
        }
        super.init(entity: entity)
        self.originalLink = entity.url ?? ""
        self.contentId = entity.contentId
        self.contentType = entity.contentType ?? ""
		self.duration = entity.duration
    }
    
    convenience init(title: String?, rawFile: String?, duration: Int?, url: String?, videoThumbnail: String?) {
        let videoE = VideoEntity(id: "", uuid: "", description: "", sourceLink: nil, sourceLabel: nil, universalUrl: "",
                                 label: nil, interests: nil, hasTag2Page: false,
                                 publishedDate: Date().milliseconds, tags: nil,
                                 link: "", originalLink: "", numberOfLikes: 0, numberOfComments: 0, liked: false)
        self.init(entity: videoE)
        
        self.title = title
        self.rawFile = rawFile
        self.originalLink = url ?? ""
        self.videoThumbnail = videoThumbnail
        self.duration = duration
        if let authorE = videoE.author {
            self.author = Author(entity: authorE)
        }
        self.contentType = videoE.contentType ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case rawFile
        case videoThumbnail
        case author
        case duration
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String?.self, forKey: .title)
        rawFile = try container.decode(String?.self, forKey: .rawFile)
        author = try container.decode(Author?.self, forKey: .author)
        duration = try container.decode(Int?.self, forKey: .duration)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(rawFile, forKey: .rawFile)
        try container.encode(author, forKey: .author)
        try container.encode(duration, forKey: .duration)
    }
    
    var thumbnailIsAGif: Bool {
        guard let thumbnail = videoThumbnail else { return false }
        return thumbnail.isGifFileName
    }
}
