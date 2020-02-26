//
//  ParagraphEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class ParagraphEntity {
    var type: String?
    var description: String?
    var title: String?
    var images: [ImageEntity]?
    var defaultImageId: String?
    var total: Int?
    var media: MediaEntity?
    var codeSnippet: String?
    var label: String?
    
    // for video
    var sourceLink: String?
    var sourceLabel: String?
    var rawFile: String?
    var duration: String?
    var url: String?
    var videoThumbnail: String?
    var video: VideoEntity?
    var videoId: String?
    // end video
    
    /// for Episode
    var episodeTitle: String?
    var episodeDescription: String?
    var appStore: String?
    var episodeThumbnail: String?
    /// end Episode
    
    init(type: String?, description: String?, title: String?, images: [ImageEntity]?, defaultImage: String?,
         total: Int?, media: MediaEntity?, codeSnippet: String?, sourceLink: String?, sourceLabel: String?,
         rawFile: String?, duration: String?, url: String?, videoThumbnail: String?, episodeTitle: String?,
         episodeDescription: String?, appStore: String?, video: VideoEntity?, videoId: String?,
         episodeThumbnail: String?, label: String?) {
        self.type = type
        self.description = description
        self.title = title
        self.images = images
        self.defaultImageId = defaultImage
        self.total = total
        self.media = media
        self.codeSnippet = codeSnippet
        self.label = label
        
        self.sourceLink = sourceLink
        self.sourceLabel = sourceLabel
        self.rawFile = rawFile
        self.duration = duration
        self.url = url
        self.videoThumbnail = videoThumbnail
        self.video = video
        self.videoId = videoId
        
        self.episodeTitle = episodeTitle
        self.episodeDescription = episodeDescription
        self.appStore = appStore
        self.episodeThumbnail = episodeThumbnail
    }
}
