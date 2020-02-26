//
//  PageDetailViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

class PageDetailViewModel: BaseViewModel {

    //public
    var infoComponents: [InfoComponent]?
    var scheduledChannelList: [Schedule]?
    
    private var interactor: PageDetailInteractor
    private let socialService: UserSocialService
    private var likeStatusDisposeBag = DisposeBag()
    private(set) var pageUrl: String!
    private(set) var pageDetail: PageDetail?
    private(set) var pageId: String!
    
    private(set) var itemsList = ItemList()
	private(set) var lastestCountItemData: Int = 0
	private(set) var currentCountItemData: Int = 0
    private(set) var albumsList = ItemList() // for titled albums
    private(set) var author: Author?
    var displayingAlbumId: String? { // Default Album => Album ID is nil
        didSet {
            resetAndLoadItemsOfAlbum(pageMenu: .photos)
        }
    }
    private var languageConfigList = [LanguageConfigListEntity]()

    init(interactor: PageDetailInteractor, socialService: UserSocialService) {
        self.interactor = interactor
        self.socialService = socialService
        
        super.init()
        
        setUpRx()
    }

    private var getScheduledChannelListOnDemand = PublishSubject<(pageId: String, fromTime: Double, toTime: Double)>()
    private var getDetailByIdOnDemand = PublishSubject<Void>()
    private var getDetailByUrlOnDemand = PublishSubject<Void>()
    private var startLoadItemsOnDemand = PublishSubject<PageMenuEnum>()
    private var startLoadAlbumsOnDemand = PublishSubject<String>()
    private var startLoadCustomVideoPlaylistOnDemand = PublishSubject<String>()
    private var getLanguageConfigOnDemand = PublishSubject<String>()
    private var getInfoComponentOnDemand = PublishSubject<Void>()
	
    // Generic items
    var onDidLoadItems: Observable<ItemList>! /// finish loading a round
    var onFinishLoadListItem: Observable<Void>! /// finish loading the whole collection
    var onErrorLoadListItem: Observable<Error>! /// on error loading Page stream and Photo default album
    var onErrorLoadAlbums: Observable<Error>! /// on error loading albums list
    var onErrorLoadCustomVideoPlaylist: Observable<Error>! /// on error loading albums list
    var onErrorGetDetail: Observable<Error>! /// on error loading page detail
    
    var onWillStartGetListItem = PublishSubject<Void>()
    var onWillStopGetListItem = PublishSubject<Void>()
    
    // Page Detail
    var onDidGetPageDetailById: Observable<Void>!
    var onDidGetPageDetailByUrl: Observable<Void>!
    var onWillStartGetPageDetail = PublishSubject<Void>()
    var onWillStopGetPageDetail = PublishSubject<Void>()
    
    // Albums
    var onDidLoadAlbums: Observable<Void>!
    var onWillStartLoadAlbums = PublishSubject<Void>()
    var onWillStopLoadAlbums = PublishSubject<Void>()
    
    // CustomVidePlaylist
    var onDidLoadCustomVideoPlaylist: Observable<Void>!
    var onWillStartLoadCustomVideoPlaylist = PublishSubject<Void>()
    var onWillStopLoadCustomVideoPlaylist = PublishSubject<Void>()
    
    // InfoComponent
    var onDidGetInfoComponent: Observable<[InfoComponent]>!
    var onWillStartGetInfoComponent = PublishSubject<Void>()
    var onWillStopGetInfoComponent = PublishSubject<Void>()

    // Scheduled Channel
    var onDidLoadScheduledChannelList: Observable<[Schedule]>!
    var onWillStartScheduledChannelList = PublishSubject<Void>()
    var onWillStopScheduledChannelList = PublishSubject<Void>()
    
    var details: PageDetail? { return pageDetail }
    var pageAboutTab: PageAboutTab? {
        return details?.pageAboutTab
    }
    
    func setPageUrl(_ pageUrl: String) {
        self.pageUrl = pageUrl
    }
    
    func setPageId(_ pageId: String) {
        self.pageId = pageId
    }
    
    func getUniversalUrl() -> String? {
        return pageDetail?.universalUrl
    }
    
    func getPageIndex() -> Int {
        return interactor.getPageIndex()
    }
    
    func getPageDetail() {
        if pageId.isEmpty {
            getPageDetailByPageUrl()
        } else {
            getPageDetailByPageId()
        }
    }

    func loadAlbums() {
        startLoadAlbumsOnDemand.onNext(pageId)
    }
    
    func loadCustomVideoPlaylist() {
        startLoadCustomVideoPlaylistOnDemand.onNext(pageId)
    }

    func loadItems(forPageMenu: PageMenuEnum) {
        startLoadItemsOnDemand.onNext(forPageMenu)
    }
    
    func resetItemsAndLoadItemsFor(pageMenu: PageMenuEnum) {
       	resetData()
        loadItems(forPageMenu: pageMenu)
    }
    
    func getInfoComponentByPageId() {
        getInfoComponentOnDemand.onNext(())
    }
	
	func resetData() {
		lastestCountItemData = 0
		currentCountItemData = 0
        likeStatusDisposeBag = DisposeBag()
		itemsList.clear()
        albumsList.clear()
	}
	
	func resetAndLoadItemsOfAlbum(pageMenu: PageMenuEnum) {
		resetDataWithoutResetListAlbumListAlbum()
		loadItems(forPageMenu: pageMenu)
	}
	
	func resetDataWithoutResetListAlbumListAlbum() {
		lastestCountItemData = 0
		currentCountItemData = 0
        likeStatusDisposeBag = DisposeBag()
		itemsList.clear()
	}
	
	func clearCache() {
        interactor.clearCache(pageId: pageId)
    }
    
    func getAccentColor() -> UIColor? {
        guard let accentColorValue = pageDetail?.pageSettings.accentColor else {
            return nil
        }
        return UIColor(rgba: accentColorValue)
    }
    
    func getScheduledChannelList() {
        let fromTime = Date().milliseconds
        guard let toTime = Date.addDaysFrom(currentDate: Date(), count: 8)?.milliseconds else { return }
        getScheduledChannelListOnDemand.onNext((pageId: self.pageId, fromTime: fromTime, toTime: toTime))
    }
    
    // MARK: Private functions

    private func setUpRx() {
        setupRxForDetails()
        setUpRxForGetItems()
        setUpRxForGetAlbums()
        setUpRxGetCustomVideoPlaylist()
        setupRxForInfoComponent()
        setupRxForScheduledChannelList()
    }
    
    private func setupRxForScheduledChannelList() {
        onDidLoadScheduledChannelList = getScheduledChannelListOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartScheduledChannelList.onNext(())
            })
            .flatMap { [unowned self] pageId, fromTime, toTime -> Observable<[Schedule]> in
                return self.interactor.getListScheduledChannels(pageId: pageId, fromTime: fromTime, toTime: toTime)
            }
            .do(onNext: { [unowned self] array in
                self.scheduledChannelList = array
            })
        
        disposeBag.addDisposables([
            interactor.onErrorLoadScheduledChannels.subscribe(onNext: { [unowned self] error in
                self.onWillStopScheduledChannelList.onNext(())
                self.showError(error: error)
            }),
            interactor.onFinishLoadScheduledChannels.subscribe(onNext: { [unowned self] _ in
                self.onWillStopScheduledChannelList.onNext(())
            })
        ])
    }
    
    private func setupRxForInfoComponent() {
        onDidGetInfoComponent = getInfoComponentOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetInfoComponent.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<[InfoComponent]> in
                return self.interactor.getInfoComponent(pageId: self.pageId)
                    .catchError { error -> Observable<[InfoComponent]> in
                        self.onWillStopGetInfoComponent.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    }
            }
            .do(onNext: {[unowned self] _ in
                self.onWillStopGetInfoComponent.onNext(())
            })
            .do(onNext: { [unowned self] components in
                self.infoComponents = components
            })
    }
    
    private func setupRxForDetails() {
        // Detail
        onDidGetPageDetailByUrl = getDetailByUrlOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetPageDetail.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<PageDetail> in
                return self.interactor.getPageDetailUrl(pageUrl: self.pageUrl)
                    .catchError { error -> Observable<PageDetail> in
                        self.onWillStopGetPageDetail.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetPageDetail.onNext(())
            })
            .do(onNext: { [unowned self] pageDetail in
                self.pageDetail = pageDetail
                self.pageDetail?.universalUrl = self.pageUrl
                self.author = Author(pageDetail: pageDetail)

            })
            .map { _ in Void() }
        
        disposeBag.addDisposables([
            interactor.onGetRedirectUrl.subscribe(onNext: { [unowned self] redirectUrl in
                self.pageUrl = redirectUrl
                self.getPageDetailByPageUrl()
            })
        ])
        
        onDidGetPageDetailById = getDetailByIdOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetPageDetail.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<PageDetail> in
                return self.interactor.getPageDetailBy(pageId: self.pageId)
                    .catchError { _ -> Observable<PageDetail> in
                        self.getDetailByUrlOnDemand.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetPageDetail.onNext(())
            })
            .do(onNext: { [unowned self] pageDetail in
                self.pageDetail = pageDetail
                self.pageDetail?.universalUrl = self.pageUrl
                self.author = Author(pageDetail: pageDetail)
            })
            .map { _ in Void() }
    }
    
    private func setUpRxForGetItems() {
        onDidLoadItems = startLoadItemsOnDemand
            .do(onNext: { [unowned self] _ in
                if self.itemsList.list.isEmpty {
                    self.onWillStartGetListItem.onNext(())
                    self.interactor.shouldStartLoadItems()
                }
            })
            .flatMap { [unowned self] pageMenu -> Observable<ItemList> in
                if pageMenu == PageMenuEnum.schedule {
                    let fromDate = Date().startOfDay
                    if let toDate = Date.addDaysFrom(currentDate: fromDate,
                                                     count: Constants.DefaultValue.totalDayForScheduler)?.endOfDay {
                        return self.interactor.getSchedulerFrom(channelId: self.pageId,
                                                                fromTime: fromDate.milliseconds,
                                                                toTime: toDate.milliseconds)
                    }
                    return Observable.empty()
                } else {
                    self.interactor.selectedAlbumId = self.displayingAlbumId
                    return self.interactor.getNextItems(pageId: self.pageId, ofPageMenu: pageMenu, shouldUseCache: true)
                }
            }
            .do(onNext: { [unowned self] _ in
                if self.itemsList.list.isEmpty {
                    self.onWillStopGetListItem.onNext(())
                }
            })
            .do(onNext: { [unowned self] itemList in
                self.currentCountItemData = self.itemsList.list.count
                self.itemsList.addAll(list: itemList.list)
                self.getLikeStatus(items: itemList.list)
                self.itemsList.grandTotal = itemList.grandTotal
                self.itemsList.title = itemList.title
                self.lastestCountItemData = self.itemsList.list.count
            })
        
        disposeBag.addDisposables([
            interactor.onErrorLoadItems.subscribe(onNext: { [unowned self] error in
                self.onWillStopGetListItem.onNext(())
                self.showError(error: error)
            })
        ])
        
        onFinishLoadListItem = interactor.onFinishLoadItems
        onErrorLoadListItem = interactor.onErrorLoadItems
        onErrorGetDetail = interactor.onErrorGetPageDetail
    }
    
    private func setUpRxGetCustomVideoPlaylist() {
        onDidLoadCustomVideoPlaylist = startLoadCustomVideoPlaylistOnDemand
            .do(onNext: { [unowned self] _  in
                self.onWillStartLoadCustomVideoPlaylist.onNext(())
            })
            .flatMap { [unowned self] pageId -> Observable<ItemList> in
                return self.interactor.getCustomPlaylisFrom(pageId: pageId)
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopLoadCustomVideoPlaylist.onNext(())
            })
            .do(onNext: {  [unowned self] itemList in
                self.albumsList.addAll(list: itemList.list)
            })
            .map { _ in Void() }
        disposeBag.addDisposables([
            interactor.onErrorLoadCustomVideoPlaylist.subscribe(onNext: { [unowned self] error in
                self.onWillStopLoadCustomVideoPlaylist.onNext(())
                self.showError(error: error)
            })
        ])
        onErrorLoadCustomVideoPlaylist = interactor.onErrorLoadCustomVideoPlaylist
    }

    private func setUpRxForGetAlbums() {
        onDidLoadAlbums = startLoadAlbumsOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartLoadAlbums.onNext(())
            })
            .flatMap { [unowned self] pageId -> Observable<ItemList> in
                return self.interactor.loadAlbums(pageId: pageId)
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopLoadAlbums.onNext(())
            })
            .do(onNext: { [unowned self] itemList in
                self.albumsList.addAll(list: itemList.list)
            })
            .map { _ in Void() }
        
        disposeBag.addDisposables([
            interactor.onErrorLoadAlbums.subscribe(onNext: { [unowned self] error in
                self.onWillStopLoadAlbums.onNext(())
                self.showError(error: error)
            })
        ])
        
        onErrorLoadAlbums = interactor.onErrorLoadAlbums
    }
    
    private func getPageDetailByPageUrl() {
        getDetailByUrlOnDemand.onNext(())
    }
    
    private func getPageDetailByPageId() {
        getDetailByIdOnDemand.onNext(())
    }
    
    private func getLikeStatus(items: [AnyObject]) {
        let ids = items.filter { item -> Bool in
            if let likable = item as? Likable, likable.contentId != nil { return true }
            return false
        }.map({ ($0 as? Likable)!.contentId! })
        guard !ids.isEmpty else { return }
        socialService.getLikeStatus(ids: ids)
            .do(onNext: { [unowned self] array in
                for item in array {
                    guard let id = item.id, let likeStatus = item.liked else {
                        continue
                    }
                    for anItem in self.itemsList.list {
                        if let likable = anItem as? Likable, let contentId = likable.contentId, id == contentId {
                            likable.liked = likeStatus
                            likable.didReceiveLikeStatus.onNext(likable.liked)
                            break
                        }
                    }
                }
            })
            .subscribe()
            .disposed(by: self.likeStatusDisposeBag)
    }
}
