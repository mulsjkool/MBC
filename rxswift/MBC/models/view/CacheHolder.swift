//
//  CacheHolder.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/18/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class CacheHolder: Codable {
    var post: Post?
    var article: Article?
    var app: App?
    var ads: Feed?
    var bundle: BundleContent?
    var playlist: Playlist?
    
    init(item: AnyObject) {
        if let p = item as? Post { post = p; return }
        if let art = item as? Article { article = art; return }
        if let ap = item as? App { app = ap; return }
        if let ads = item as? Feed, let type = CampaignType(rawValue: ads.type), type == CampaignType.ads {
            self.ads = ads
            return
        }
        if let bundleItem = item as? BundleContent {
            if let playlistItem = item as? Playlist { playlist = playlistItem; return }
            self.bundle = bundleItem
            return
        }
    }
    
    func toAnyObject() -> AnyObject {
        if let p = post { return p }
        if let art = article { return art }
        if let ap = app { return ap }
        
        if let ads = self.ads { return ads }
        if let bundle = self.bundle {
            if let playlist = self.playlist { return playlist }
            return bundle
        }
        
        // swiftlint:disable fatal_error
        fatalError("Please add the missing object")
    }
}
