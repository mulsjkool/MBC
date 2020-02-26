//
//  PageAlbumRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/14/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

protocol PageAlbumRepository {
    func saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?)
    func getCachedDefaultAlbum(pageId: String) -> ([Media]?, Int)
    func clearDefaultAlbumCache()
    func clearDefaultAlbumCache(pageId: String)
}
