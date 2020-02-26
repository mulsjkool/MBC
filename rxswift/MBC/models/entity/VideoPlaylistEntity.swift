//
//  VideoPlaylistEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class VideoPlaylistEntity {
    var id: String?
    var publishedDate: Date?
    var type: String?
    var hasTag2Page: Bool?
    var interests: [InterestEntity]?
    var title: String?
    var description: String?
    var label: String?
    
    var thumbnailUrl: String?
    var videoList: [VideoEntity]
    var defaultVideo: VideoEntity?
    var total: Int
    var numberOfComments: Int
    var numberOfLikes: Int
    
    init(id: String?, publishedDate: Date?, type: String?, hasTag2Page: Bool?, interests: [InterestEntity]?,
         title: String?, description: String?, label: String?, thumbnailUrl: String?, videoList: [VideoEntity],
         defaultVideo: VideoEntity?, total: Int, numberOfComments: Int, numberOfLikes: Int) {
        self.id = id
        self.publishedDate = publishedDate
        self.type = type
        self.hasTag2Page = hasTag2Page
        self.interests = interests
        self.title = title
        self.description = description
        self.label = label
        self.thumbnailUrl = thumbnailUrl
        self.videoList = videoList
        self.defaultVideo = defaultVideo
        self.total = total
        self.numberOfComments = numberOfComments
        self.numberOfLikes = numberOfLikes
    }
}
