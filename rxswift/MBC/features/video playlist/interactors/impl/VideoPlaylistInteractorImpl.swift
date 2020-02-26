//
//  VideoPlaylistInteractorImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class VideoPlaylistInteractorImpl: VideoPlaylistInteractor {
    
    private let videoApi: VideoApi
    private let videoPlaylistRepository: VideoPlayListRepository
    
    // Variables
    var index = 0
    private var totalLoaded = 0
    //var pageSize = Components.instance.configurations.defaultPageSize
    var pageSize = 1000000
    
    // Subjects
    private var finishLoadItemsInSubject = PublishSubject<Void>()
    private var errorLoadItemsInSubject = PublishSubject<Error>()
    
    init(videoApi: VideoApi, videoPlaylistRepository: VideoPlayListRepository) {
        self.videoApi = videoApi
        self.videoPlaylistRepository = videoPlaylistRepository
    }
    
    // MARK: Public
    func getIndex() -> Int {
        return index
    }
    
    func setIndex(index: Int) {
        self.index = index
    }
    
    var onFinishLoadItems: Observable<Void> {
        return finishLoadItemsInSubject.asObserver()
    }
    
    var onErrorLoadItems: Observable<Error> {
        return errorLoadItemsInSubject.asObserver()
    }
    
    func getDetailOfPlayListFrom(pageId: String?, contentId: String?, playlistId: String?) -> Observable<ItemList> {
        if totalLoaded == 0, let pageId = pageId { // first load, try to get from cache
            var cachedPlaylist: ([Video]?, Int)?
            if let contentId = contentId {
                cachedPlaylist = videoPlaylistRepository.getCachedVideoOfCustomPlaylist(playlistId: contentId,
                                                                                        pageId: pageId)
            } else {
                cachedPlaylist = videoPlaylistRepository.getCachedDefaultPlaylist(pageId: pageId)
            }
            if  totalLoaded == 0, let videoList = cachedPlaylist?.0 {
                totalLoaded = videoList.count
                index = totalLoaded / pageSize
                index += 1
                let itemList = ItemList(items: videoList)
                itemList.grandTotal = cachedPlaylist?.1
                return Observable.just(itemList)
            }
        }
        return getDetailOfPlayList(pageId: pageId, contentId: contentId, playlistId: playlistId)
            .catchError {  error -> Observable<VideoPlaylistEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .do(onNext: { videoPlaylistE  in
                guard !videoPlaylistE.videoList.isEmpty else {
                    self.finishLoadItemsInSubject.onNext(())
                    return
                }
                self.totalLoaded += videoPlaylistE.videoList.count
                if self.totalLoaded >= videoPlaylistE.total {
                    self.finishLoadItemsInSubject.onNext(())
                }
            })
            .map { videoPlaylistE -> ItemList in
                let items = videoPlaylistE.videoList.map { Video(entity: $0) }
                let itemlist = ItemList()
                itemlist.addAll(list: items)
                return itemlist
            }
            .do(onNext: { itemList in
                guard let pageId = pageId else { return }
                if let playList = itemList.list as? [Video] {
                    if let contentId = contentId {
                        self.videoPlaylistRepository.saveVideosForCustomPlaylist(playlistId: contentId, pageId: pageId,
                                                                             videolist: playList,
                                                                             grandTotal: self.totalLoaded)
                    } else {
                        self.videoPlaylistRepository.saveDefaultPlaylist(pageId: pageId,
                                                                                 videolist: playList,
                                                                                 grandTotal: self.totalLoaded)
                    }
                }
            })
            .do(onNext: { _ in self.index += 1 })
    }
    
    func getTaggedPagesFor(media: Media) -> Observable<Media> {
        return Components.taggedPagesService.getTaggedPagesFrom(media: media)
    }
    
    // MARK: Private
    
    private func getDetailOfPlayList(pageId: String?, contentId: String?,
                                     playlistId: String? ) -> Observable<VideoPlaylistEntity> {
        if let playlistId = playlistId { return getDetailOfPlayListFrom(playlistId: playlistId) }
        guard let pageId = pageId else { return Observable.empty() }
        if let contentId = contentId {
            return videoApi.getDetailOfPlayListFrom(pageId: pageId, contentId: contentId,
                                                    page: index, pageSize: pageSize)
        }
        return videoApi.getDefaultPlaylistFrom(pageId: pageId, page: index, pageSize: pageSize)
    }
    
    private func getDetailOfPlayListFrom(playlistId: String) -> Observable<VideoPlaylistEntity> {
        return videoApi.getDetailOfPlaylistFrom(playlistId: playlistId)
    }
    
}
