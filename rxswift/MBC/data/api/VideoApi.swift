//
//  VideoApi.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol VideoApi {
    func getDefaultPlaylistFrom(pageId: String, page: Int, pageSize: Int) -> Observable<VideoPlaylistEntity>
    func getCustomPlaylistFrom(pageId: String, page: Int, pageSize: Int) -> Observable<[VideoPlaylistEntity]>
    func getDetailOfPlayListFrom(pageId: String, contentId: String,
                                 page: Int, pageSize: Int) -> Observable<VideoPlaylistEntity>
    func getDetailOfPlaylistFrom(playlistId: String) -> Observable<VideoPlaylistEntity>
}
