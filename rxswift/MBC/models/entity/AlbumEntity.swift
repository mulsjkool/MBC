//
//  AlbumEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class AlbumEntity {
    var id: String
    var mediaList: [MediaEntity]?
    var title: String?
    var description: String?
    var cover: MediaEntity?
    var publishedDate: Date
    var contentId: String?
    var total: Int
    var currentPosition: Int
    
    init(id: String, mediaList: [MediaEntity]?, title: String?,
         description: String?, cover: MediaEntity?, publishedDate: Date,
         contentId: String?, total: Int, currentPosition: Int) {
        self.id = id
        self.mediaList = mediaList
        self.title = title
        self.description = description
        self.cover = cover
        self.publishedDate = publishedDate
        self.contentId = contentId
        self.total = total
        self.currentPosition = currentPosition
    }
}
