//
//  Album.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/12/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Album: Codable {
    var id: String
    var mediaList: [Media]?
    var title: String?
    var description: String?
    var cover: Media?
    var publishedDate: Date
    var contentId: String?
    var total: Int
    var currentPosition: Int
    var isInterestExpanded = false

    init(entity: AlbumEntity) {
        self.id = entity.id
        self.title = entity.title
        self.description = entity.description
        self.publishedDate = entity.publishedDate
        self.contentId = entity.contentId
        self.total = entity.total
        self.currentPosition = entity.currentPosition
        
        if let cover = entity.cover {
            self.cover = Media(entity: cover, albumTitle: title)
        }
        
        if let list = entity.mediaList {
            self.mediaList = list.map { Media(entity: $0, albumTitle: title) }
        }
    }
}
