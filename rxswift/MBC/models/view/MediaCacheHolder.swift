//
//  MediaCacheHolder.swift
//  MBC
//
//  Created by Kevin Nguyen on 2/12/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class MediaCacheHolder: Codable {
    var media: Media?
    var video: Video?
    
    init(item: Media) {
        if let video = item as? Video { self.video = video; return }
        self.media = item
    }
    
    func toMedia() -> Media {
        if let video = self.video { return video }
        return self.media!
    }
}
