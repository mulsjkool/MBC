//
//  VideoPlaylist.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class VideoPlaylist: Codable {
    var id: String?
    var publishedDate: Date?
    var type: String?
    var hasTag2Page: Bool?
    var interests: [Interest]?
    var title: String?
    var description: String?
    var label: String?

    var thumbnailUrl: String?
    var videoList: [Video]
    var defaultVideo: Video?
    var total: Int
    var numberOfLikes: Int
    var numberOfComments: Int
    var isInterestExpanded = false

    init(entity: VideoPlaylistEntity) {
        self.id = entity.id
        self.publishedDate = entity.publishedDate
        self.type = entity.type
        self.hasTag2Page = entity.hasTag2Page
        if let interests = entity.interests { self.interests = interests.map { Interest(entity: $0) } }
        self.title = entity.title
        self.description = entity.description
        self.label = entity.label
        self.total = entity.total
        self.numberOfLikes = entity.numberOfLikes
        self.numberOfComments = entity.numberOfComments
        self.thumbnailUrl = entity.thumbnailUrl
        self.videoList = entity.videoList.map { Video(entity: $0) }
        if let defaultVideoE = entity.defaultVideo { self.defaultVideo = Video(entity: defaultVideoE) }
    }
}
