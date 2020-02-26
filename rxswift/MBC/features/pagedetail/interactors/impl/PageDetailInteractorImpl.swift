//
//  PageDetailInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class PageDetailInteractorImpl: PageDetailInteractor {
    private let contentPageApi: ContentPageApi
    private let streamApi: StreamApi
    private let pageAlbumApi: PageAlbumApi
	private let appApi: AppApi
    private let videoApi: VideoApi
    private let infoComponentApi: InfoComponentApi
    private let pageDetailApi: PageDetailApi
    private let schedulerApi: SchedulerApi
    private let episodeApi: EpisodeApi
    private let scheduledChannelsApi: ScheduledChannelsApi
    
    private let videoPlaylistRepository: VideoPlayListRepository
    private let pageDetailRepository: PageDetailRepository
    private let infoComponentRepository: InfoComponentsRepository
    private let streamRepository: StreamRepository
    private let pageAlbumRepository: PageAlbumRepository
    private let appTabRepository: AppTabRepository
    private let episodeRepository: EpisodeRepository
    private let languageConfigService: LanguageConfigService
    private let startToGetInfoComponentOnDemand = PublishSubject<Void>()
    
    // Variables
    private var index = 0
    private var totalLoaded = 0
    var pageSize = Components.instance.configurations.defaultPageSize
    var customVideoPlaylistpageSize = 1000000
    
    // Subjects
    private var finishLoadItemsInSubject = PublishSubject<Void>()
    private var finishLoadCustomPlaylistItemsInSubject = PublishSubject<Void>()
    private var finishLoadScheduledChannelsInSubject = PublishSubject<Void>()
    private var errorLoadItemsInSubject = PublishSubject<Error>()
    private var errorLoadAlbumsInSubject = PublishSubject<Error>()
    private var errorLoadCustomVideoPlaylistInSubject = PublishSubject<Error>()
    private var errorGetPageDetailInSubject = PublishSubject<Error>()
    private var getRedirectUrlInSubject = PublishSubject<String>()
    private var errorLoadScheduledChannelsInSubject = PublishSubject<Error>()
    
	init(contentPageApi: ContentPageApi, pageAlbumApi: PageAlbumApi, streamApi: StreamApi, appApi: AppApi,
         videoApi: VideoApi, infoComponentApi: InfoComponentApi, languageConfigService: LanguageConfigService,
         pageDetailRepository: PageDetailRepository, streamRepository: StreamRepository,
         pageAlbumRepository: PageAlbumRepository, appTabRepository: AppTabRepository,
         videoPlaylistRepository: VideoPlayListRepository, pageDetailApi: PageDetailApi,
         schedulerApi: SchedulerApi, infoComponentRepository: InfoComponentsRepository, episodeApi: EpisodeApi,
         episodeRepository: EpisodeRepository, scheduledChannelsApi: ScheduledChannelsApi) {
        self.contentPageApi = contentPageApi
        self.pageAlbumApi = pageAlbumApi
        self.streamApi = streamApi
		self.appApi = appApi
        self.videoApi = videoApi
        self.languageConfigService = languageConfigService
        self.pageDetailRepository = pageDetailRepository
        self.streamRepository = streamRepository
        self.pageAlbumRepository = pageAlbumRepository
        self.videoPlaylistRepository = videoPlaylistRepository
        self.appTabRepository = appTabRepository
        self.infoComponentApi = infoComponentApi
        self.pageDetailApi = pageDetailApi
        self.schedulerApi = schedulerApi
        self.scheduledChannelsApi = scheduledChannelsApi
        self.infoComponentRepository = infoComponentRepository
        self.episodeApi = episodeApi
        self.episodeRepository = episodeRepository
    }

    func getPageDetailUrl(pageUrl: String) -> Observable<PageDetail> {
        if let pageDetail = pageDetailRepository.getCachedPageDetail(pageId: pageUrl) {
            return Observable.just(pageDetail)
        }

        return contentPageApi.getContentPage(pageUrl: pageUrl)
            .flatMap({ [unowned self] contentPageEntity -> Observable<PageDetail> in
                if let pageDetailEntity = contentPageEntity.pageDetail {
                    return self.languageConfigService.getLanguageConfigs(pageDetailEntity: pageDetailEntity)
                } else {
                    if let redirectUrl = contentPageEntity.redirectUrl {
                        self.getRedirectUrlInSubject.onNext(redirectUrl)
                    }
                    return Observable.empty()
                }
            })
            .catchError { error -> Observable<PageDetail> in
                self.errorGetPageDetailInSubject.onNext(error)
                return Observable.empty()
            }
            .do(onNext: { [unowned self] pageDetail in
                self.pageDetailRepository.savePageDetail(pageDetail: pageDetail)
            })
    }

    func getPageDetailBy(pageId: String) -> Observable<PageDetail> {
        if let pageDetail = pageDetailRepository.getCachedPageDetail(pageId: pageId) {
            return Observable.just(pageDetail)
        }
        return pageDetailApi.getPageDetailBy(pageId: pageId)
            .flatMap({ [unowned self] pageDetailEntity -> Observable<PageDetail> in
                self.languageConfigService.getLanguageConfigs(pageDetailEntity: pageDetailEntity)
            })
            .catchError { error -> Observable<PageDetail> in
                self.errorGetPageDetailInSubject.onNext(error)
                return Observable.empty()
            }
            .do(onNext: { [unowned self] pageDetail in
                self.pageDetailRepository.savePageDetail(pageDetail: pageDetail)
            })
    }

    func shouldStartLoadItems() {
        index = 0
        totalLoaded = 0
    }
    
    func getPageIndex() -> Int {
        return self.index
    }
    
    var onFinishLoadItems: Observable<Void> {
        return finishLoadItemsInSubject.asObserver()
    }
    
    var onErrorLoadItems: Observable<Error> {
        return errorLoadItemsInSubject.asObservable()
    }
    
    var onErrorLoadAlbums: Observable<Error> {
        return errorLoadAlbumsInSubject.asObserver()
    }
    
    var onErrorLoadCustomVideoPlaylist: Observable<Error> {
        return errorLoadCustomVideoPlaylistInSubject.asObserver()
    }
    
    var onErrorGetPageDetail: Observable<Error> {
        return errorGetPageDetailInSubject.asObserver()
    }
    
    var onGetRedirectUrl: Observable<String> {
        return getRedirectUrlInSubject.asObserver()
    }
    
    var onFinishLoadScheduledChannels: Observable<Void> {
        return finishLoadScheduledChannelsInSubject.asObserver()
    }
    
    var onErrorLoadScheduledChannels: Observable<Error> {
        return errorLoadScheduledChannelsInSubject.asObserver()
    }
    
    var selectedAlbumId: String? 
    
    func getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool = true) -> Observable<ItemList> {
        switch ofPageMenu {
        case .newsfeed:
			return getNextFeeds(pageId)
        case .photos:
            return getNextMediaItems(pageId, shouldUseCache: shouldUseCache)
        case .apps:
            return getNextApps(pageId: pageId)
        case .episodes:
            return getNextEpisodes(pageId: pageId)
        default:
            return getNextDefaultPlaylistFrom(pageId: pageId)
		}
    }
    
    func loadAlbums(pageId: String) -> Observable<ItemList> {
        /// caching code goes here
        
        return pageAlbumApi.loadAlbums(pageId: pageId)
            .catchError { error -> Observable<[AlbumEntity]> in
                self.errorLoadAlbumsInSubject.onNext(error)
                return Observable.empty()
            }
            .map { ItemList(items: $0.map { album in Album(entity: album) }) }
            .do(onNext: { albums in
                /// caching code goes here
                print(albums)
            })
    }
    
    func clearCache(pageId: String) {
        pageDetailRepository.clearPageDetailCache(pageId: pageId)
        streamRepository.clearPageStreamCache(pageId: pageId)
        pageAlbumRepository.clearDefaultAlbumCache(pageId: pageId)
        appTabRepository.clearCachedAppsListFor(pageId: pageId)
        infoComponentRepository.clearInfoComponentCache(pageId: pageId)
        videoPlaylistRepository.clearDefaultPlaylistCache()
    }
	
	func setPageSize(pageSize: Int) {
		self.pageSize = pageSize
	}
	
	func resetPageSize() {
		pageSize = Components.instance.configurations.defaultPageSize
	}

    func getInfoComponent(pageId: String) -> Observable<[InfoComponent]> {
        
        if let infoComponent = infoComponentRepository.getCachedInfoComponent(pageId: pageId) {
            return Observable.just(infoComponent)
        }
        return self.infoComponentApi.getInfoComponentById(pageId: pageId)
            .map { components in
                let items = components.map { InfoComponent(entity: $0) }
                self.infoComponentRepository.saveInfoComponent(pageId: pageId, component: items)
                return items
            }
    }
    
    // MARK: Private functions
    private func getNextFeeds(_ pageId: String) -> Observable<ItemList> {
        
        if totalLoaded == 0 { // first load, try to get from cache
            let cachedData = streamRepository.getCachedPageStream(pageId: pageId)
            if let feedList = cachedData.itemList {
                totalLoaded = cachedData.totalLoaded
                index = cachedData.index
                return Observable.just(feedList)
            }
        }
        
        return streamApi.loadStreamBy(pageId: pageId, fromIndex: index, numberOfItems: pageSize)
            .catchError { error -> Observable<StreamEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .do(onNext: { str in
                guard let feedEntities = str.items, !feedEntities.isEmpty, let totalItems = str.total else {
                    self.finishLoadItemsInSubject.onNext(())
                    return
                }
                
                self.totalLoaded += feedEntities.count
                self.index = self.totalLoaded
                if self.totalLoaded >= totalItems || feedEntities.isEmpty {
                    self.finishLoadItemsInSubject.onNext(())
                }
            })
            .map { str in
                let filteredFeeds = self.filterOutNotSupportFeedsFrom(items: str.items)
				let feeds = self.fetchFeeds(filteredFeeds)
				if let total = str.total {
					feeds.grandTotal = total
				}
                
                return feeds
            }
            .do(onNext: { itemList in
                let index_loaded: (index: Int, totalLoaded: Int) = (self.index, self.totalLoaded)
                self.streamRepository.savePageStream(pageId: pageId, itemList: itemList, dataIndex: index_loaded)
            })
    }

    private func fetchFeeds(_ feedEntities: [FeedEntity]?) -> ItemList {
        var items = [Feed]()
        guard let entities = feedEntities else { return ItemList() }
        
        for fEntity in entities {
			if let type = CampaignType(rawValue: fEntity.type), type == .ads { items.append(Feed(entity: fEntity)) }
            
            if let type = FeedType(rawValue: fEntity.type) {
                switch type {
                case .post:
                    items.append(Post(entity: fEntity))
                case .article:
                    items.append(Article(entity: fEntity))
                case .app:
                    items.append(App(entity: fEntity))
                default:
                    break
                }
            }
        }
        
        return ItemList(items: items)
    }
	
	private var shouldGetCachedAlbum: Bool {
		return selectedAlbumId == nil
	}
	
	private func getNextMediaItems(_ pageId: String, shouldUseCache: Bool = true) -> Observable<ItemList> {
		
		if shouldUseCache {
			let cachedAlbum = pageAlbumRepository.getCachedDefaultAlbum(pageId: pageId)
			
			if shouldGetCachedAlbum, totalLoaded == 0,
				let mediaList = cachedAlbum.0 {
				totalLoaded = mediaList.count
				index = totalLoaded / pageSize
                index += 1
				let itemList = ItemList(items: mediaList)
				itemList.grandTotal = cachedAlbum.1
                
                return Observable.just(itemList)
			}
		}
		return pageAlbumApi.loadAlbumOf(pageId: pageId, albumId: selectedAlbumId,
                                        fromIndex: index, numberOfItems: pageSize)
            .catchError { error -> Observable<AlbumEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .do(onNext: { albumEntity in
                if let mediaItems = albumEntity.mediaList, !mediaItems.isEmpty {
                    self.totalLoaded += mediaItems.count
                    if self.totalLoaded >= albumEntity.total {
                        self.finishLoadItemsInSubject.onNext(())
                    }
                } else { self.finishLoadItemsInSubject.onNext(()) }
            })
            .map { albumE in
                let items = albumE.mediaList?.map { Media(entity: $0, albumTitle: albumE.title) }
				if let items = items {
					let itemlist = ItemList(items: items)
					itemlist.grandTotal = albumE.total
					return itemlist
				}
				return ItemList()
            }
            .do(onNext: { itemList in
                if self.shouldGetCachedAlbum, let mediaList = itemList.list as? [Media] {
                    self.pageAlbumRepository.saveDefaultAlbum(pageId: pageId, mediaList: mediaList,
                                                              grandTotal: itemList.grandTotal)
                }
            })
            .do(onNext: { _ in self.index += 1 })
    }
	
	func loadNextAlbum(pageId: String, currentAlbumContentId: String,
							   publishDate: String, isNextAlbum: Bool) -> Observable<Album> {
		return pageAlbumApi.loadNextAlbum(pageId: pageId, currentAlbumContentId: currentAlbumContentId,
										  publishDate: publishDate, isNextAlbum: isNextAlbum)
			.map { Album(entity: $0) }
	}
	
	func loadDescriptionOfPost(pageId: String, postId: String, page: Int,
							   pageSize: Int, damId: String) -> Observable<Album> {
		return pageAlbumApi.loadDescriptionOfPost(pageId: pageId, postId: postId,
												  page: page, pageSize: pageSize, damId: damId)
			.map { Album(entity: $0) }
	}
	
	private func getNextApps(pageId: String) -> Observable<ItemList> {
        if totalLoaded == 0 { // first load, try to get from cache
            let cachedData = appTabRepository.getCachedAppsListFor(pageId: pageId)
            if let list = cachedData.list {
                totalLoaded = list.count
                index = totalLoaded / pageSize
                index += 1
                let itemList = ItemList(items: list)
                itemList.grandTotal = cachedData.grandTotal
                return Observable.just(itemList)
            }
        }
		return appApi.getListApp(pageId: pageId, page: index, pageSize: pageSize)
			.do(onNext: { [unowned self] pageAppEntity in
				self.totalLoaded += pageAppEntity.entities.count
				if self.totalLoaded >= pageAppEntity.total || pageAppEntity.entities.isEmpty {
					self.finishLoadItemsInSubject.onNext(())
				}
			})
            .catchError { error -> Observable<PageAppEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .map { pageAppEntity in
				let items = pageAppEntity.entities.map { App(entity: $0) }
				let itemList = ItemList(items: items)
				itemList.grandTotal = pageAppEntity.total
				itemList.title = pageAppEntity.title
				return itemList
            }
            .do(onNext: { itemList in
                if let list = itemList.list as? [App] {
                    self.appTabRepository.saveAppsListFor(pageId: pageId, appList: list,
                                                          grandTotal: itemList.grandTotal)
                }
            })
			.do(onNext: { [unowned self] _ in self.index += 1 })
	}
    
    private func getNextEpisodes(pageId: String) -> Observable<ItemList> {
        if totalLoaded == 0 { // first load, try to get from cache
            let cachedData = episodeRepository.getEpisodeListFor(pageId: pageId)
            if let list = cachedData.list {
                totalLoaded = list.count
                index = totalLoaded / pageSize
                index += 1
                let itemList = ItemList(items: list)
                itemList.grandTotal = cachedData.grandTotal
                return Observable.just(itemList)
            }
        }
        return episodeApi.getListEpisode(pageId: pageId, page: index, pageSize: pageSize)
            .do(onNext: { [unowned self] feedEntities in
                self.totalLoaded += feedEntities.count
                if self.totalLoaded >= feedEntities.count || feedEntities.isEmpty {
                    self.finishLoadItemsInSubject.onNext(())
                }
            })
            .catchError { error -> Observable<[FeedEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .map { feedEntities in
                let items = feedEntities.map { Post(entity: $0) }
                let itemList = ItemList(items: items)
                itemList.grandTotal = self.totalLoaded
                return itemList
            }
            .do(onNext: { itemList in
                if let list = itemList.list as? [Post] {
                    self.episodeRepository.saveEpisodeListFor(pageId: pageId, list: list,
                                                              grandTotal: itemList.grandTotal)
                }
            })
            .do(onNext: { [unowned self] _ in self.index += 1 })
    }
    
    func getTaggedPagesFor(media: Media) -> Observable<Media> {
        return Components.taggedPagesService.getTaggedPagesFrom(media: media)
    }
    
    func getCustomPlaylisFrom(pageId: String) -> Observable<ItemList> {
        return videoApi.getCustomPlaylistFrom(pageId: pageId, page: 0, pageSize: customVideoPlaylistpageSize)
            .catchError { error -> Observable<[VideoPlaylistEntity]> in
                self.errorLoadCustomVideoPlaylistInSubject.onNext(error)
                return Observable.empty()
            }
            .map { customPlaylistE in
                let items = customPlaylistE.map { VideoPlaylist(entity: $0) }
                let itemList = ItemList(items: items)
                return itemList
            }
    }
    
    func getNextDefaultPlaylistFrom(pageId: String) -> Observable<ItemList> {
        if totalLoaded == 0 { // first load, try to get from cache
            let cachedPlaylist = videoPlaylistRepository.getCachedDefaultPlaylist(pageId: pageId)
            if  totalLoaded == 0, let videoList = cachedPlaylist.0 {
                totalLoaded = videoList.count
                index = totalLoaded / pageSize
                index += 1
                let itemList = ItemList(items: videoList)
                itemList.grandTotal = cachedPlaylist.1
                return Observable.just(itemList)
            }
        }
        
        return videoApi.getDefaultPlaylistFrom(pageId: pageId, page: index, pageSize: pageSize)
            .do(onNext: { [unowned self] defaultPlaylistE in
                self.totalLoaded += defaultPlaylistE.videoList.count
                if self.totalLoaded >= defaultPlaylistE.total || defaultPlaylistE.videoList.isEmpty {
                    self.finishLoadItemsInSubject.onNext(())
                }
            })
            .catchError { error -> Observable<VideoPlaylistEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .map { defaultPlaylistE in
                let items = defaultPlaylistE.videoList.map { Video(entity: $0) }
                let itemList = ItemList(items: items)
                itemList.grandTotal = defaultPlaylistE.total
                return itemList
            }
            .do(onNext: { itemList in
                if let playList = itemList.list as? [Video] {
                    self.videoPlaylistRepository.saveDefaultPlaylist(pageId: pageId, videolist: playList,
                                                              grandTotal: itemList.grandTotal)
                }
            })
            .do(onNext: { [unowned self] _ in self.index += 1 })
    }
    
    func getSchedulerFrom(channelId: String, fromTime: Double, toTime: Double) -> Observable<ItemList> {
        return schedulerApi.getListScheduler(channelId: channelId, fromTime: fromTime, toTime: toTime)
            .catchError { error -> Observable<[ScheduleEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .map { schedulers in
                var items = schedulers.map { Schedule(entity: $0) }
                let itemList = ItemList()
                if items.isEmpty { return itemList }
                items = items.sorted(by: { obj1, obj2 -> Bool in
                    if obj1.startTime.compare(obj2.startTime) == .orderedSame {
                        if let publishDate1 = obj1.channelPublishedDate, let publishDate2 = obj2.channelPublishedDate {
                            return publishDate1.compare(publishDate2) == .orderedAscending
                        }
                    }
                    return obj1.startTime.compare(obj2.startTime) == .orderedAscending
                })
               
                var currentDayIndex = 0
                var schedulerOnDay = SchedulersOnDay()
                    schedulerOnDay.index = currentDayIndex
                for schedule in items {
                    let dayIndex = schedule.startTime.getIndexInWeek()
                    if dayIndex != currentDayIndex {
                        schedulerOnDay = SchedulersOnDay()
                        schedulerOnDay.list.append(schedule)
                        schedulerOnDay.index = dayIndex
                        currentDayIndex = dayIndex
                        itemList.addItem(item: schedulerOnDay)
                    } else {
                        schedulerOnDay.list.append(schedule)
                        if itemList.list.isEmpty {
                            itemList.addItem(item: schedulerOnDay)
                        }
                    }
                }
                
                return itemList
            }
        
    }
    
    // TO BE REMOVED
    private func filterOutNotSupportFeedsFrom(items: [FeedEntity]?) -> [FeedEntity]? {
        if let items = items {
            return items.filter { feedE in
                if let type = FeedType(rawValue: feedE.type) {
					if type == .app { return true }
                    if type == .article { return true }
                    if type == .post {
                        if let subType = feedE.subType, let sType = FeedSubType(rawValue: subType) {
                            return sType == .text || sType == .image || sType == .embed || sType == .video
                                || sType == .episode
                        }
                    }
                }
				if let type = CampaignType(rawValue: feedE.type), type == .ads { return true }
                return false
            }
        }
        
        return nil
    }
    
    // MARK: Scheduled Channels List
    
    func getListScheduledChannels(pageId: String, fromTime: Double, toTime: Double) -> Observable<[Schedule]> {
        return scheduledChannelsApi.getListScheduledChannels(pageId: pageId, fromTime: fromTime, toTime: toTime)
            .catchError { error -> Observable<[ScheduleEntity]> in
                self.errorLoadScheduledChannelsInSubject.onNext(error)
                return Observable.empty()
            }
            .do(onNext: { _ in
                self.finishLoadScheduledChannelsInSubject.onNext(())
            })
            .map { array in
                let items = array.map({ Schedule(entity: $0) })
                return items
            }
    }
}
