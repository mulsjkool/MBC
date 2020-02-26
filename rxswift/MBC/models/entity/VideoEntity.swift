//
//  VideoEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class VideoEntity: MediaEntity {
    var title: String?
    var rawFile: String?
    var duration: Int?
    var url: String?
    var videoThumbnail: String?
    var author: AuthorEntity?
    var contentId: String?
    var contentType: String?
	var adsUrl: String?
}
