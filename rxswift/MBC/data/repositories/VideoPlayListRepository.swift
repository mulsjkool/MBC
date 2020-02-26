//
//  VideoPlayListRepository.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
protocol VideoPlayListRepository {
    func saveDefaultPlaylist(pageId: String, videolist: [Video], grandTotal: Int?)
    func saveVideosForCustomPlaylist(playlistId: String, pageId: String, videolist: [Video], grandTotal: Int?)
    func getCachedDefaultPlaylist(pageId: String) -> ([Video]?, Int)
    func getCachedVideoOfCustomPlaylist(playlistId: String, pageId: String) -> ([Video]?, Int)
    func clearDefaultPlaylistCache()
}
