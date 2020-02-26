//
//  VideoApiImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class VideoApiImpl: BaseApiClient<VideoPlaylistEntity>, VideoApi {
    let videoPlaylistTransformer: (JSON) -> VideoPlaylistEntity
    let videoCustomPlaylistTransformer: (JSON) -> [VideoPlaylistEntity]
    
    init(apiClient: ApiClient, videoPlaylistTransformer: @escaping (JSON) -> VideoPlaylistEntity,
         videoCustomPlaylistTransformer: @escaping (JSON) -> [VideoPlaylistEntity]) {
        self.videoPlaylistTransformer = videoPlaylistTransformer
        self.videoCustomPlaylistTransformer = videoCustomPlaylistTransformer
        super.init(apiClient: apiClient, jsonTransformer: videoPlaylistTransformer)
    }
    
    private static let playlistDefault = "/content-presentations/pages/%@/default-playlist?page=%d&size=%d"
    
    func getDefaultPlaylistFrom(pageId: String, page: Int, pageSize: Int) -> Observable<VideoPlaylistEntity> {
        return apiClient.get(String(format: VideoApiImpl.playlistDefault, pageId, page, pageSize),
                             parameters: nil, errorHandler: { _, error -> Error in
            return error
        }, parse: videoPlaylistTransformer)
    }
    
    private static let getCustomPlaylist = "/content-presentations/pages/%@/custom-playlists?page=%d&size=%d"
    
    func getCustomPlaylistFrom(pageId: String, page: Int, pageSize: Int) -> Observable<[VideoPlaylistEntity]> {
        return apiClient.get(String(format: VideoApiImpl.getCustomPlaylist, pageId, page, pageSize),
                             parameters: nil, errorHandler: { _, error -> Error in
            return error
        }, parse: videoCustomPlaylistTransformer)
    }
    
    private static let detailOfPlaylist = "/content-presentations/pages/%@/content/%@/playlist?page=%d&size=%d"
    
    func getDetailOfPlayListFrom(pageId: String, contentId: String,
                                 page: Int, pageSize: Int) -> Observable<VideoPlaylistEntity> {
        return apiClient.get(String(format: VideoApiImpl.detailOfPlaylist, pageId, contentId, page, pageSize),
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error
        }, parse: videoPlaylistTransformer)
        
    }
    
    private static let detailOfPlaylistFromPlaylistId = "/content-presentations/playlists/%@"
    
    func getDetailOfPlaylistFrom(playlistId: String) -> Observable<VideoPlaylistEntity> {
        return apiClient.get(String(format: VideoApiImpl.detailOfPlaylistFromPlaylistId, playlistId),
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error
        }, parse: videoPlaylistTransformer)
    }
}
