//
//  RelatedContentEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class RelatedContentEntity {
    var description: String?
    var page: PageEntity?
    var photo: MediaEntity?
    var label: String?
    var appPhotoUrl: String?
    var video: VideoEntity?
    var whitePageUrl: String?
    
    init(description: String?, page: PageEntity?, photo: MediaEntity?, label: String?, appPhotoUrl: String?,
         video: VideoEntity?, whitePageUrl: String?) {
        self.description = description
        self.page = page
        if let photo = photo {
            self.photo = photo
            if photo.originalLink.isEmpty {
                self.photo?.originalLink = photo.link
            }
        }
        self.label = label
        self.appPhotoUrl = appPhotoUrl
        self.video = video
        self.whitePageUrl = whitePageUrl
    }
}
