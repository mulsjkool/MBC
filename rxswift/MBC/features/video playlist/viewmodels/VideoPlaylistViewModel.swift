//
//  VideoPlaylistViewModel.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class VideoPlaylistViewModel: BaseViewModel {
    
    private var interactor: VideoPlaylistInteractor
    private(set) var pageId: String!
    private(set) var contentId: String?
    private (set) var playlistId: String?
    private(set) var accentColor: UIColor?
    private(set) var itemsList = ItemList()
    private var index: Int = 0
    
    private var startLoadItemsOnDemand = PublishSubject<Void>()
    
    var onDidLoadItems: Observable<ItemList>! /// finish loading a round
    var onFinishLoadListItem: Observable<Void>! /// finish loading the whole collection
    var onErrorLoadListItem: Observable<Error>! /// on error loading Page stream and Photo default album
    
    var onWillStartGetListItem = PublishSubject<Void>()
    var onWillStopGetListItem = PublishSubject<Void>()
    
    private let startLoadTaggedPageOnDemand = PublishSubject<Media>()
    var onWillStartGetTaggedPages = PublishSubject<Void>()
    var onWillStopGetTaggedPages = PublishSubject<Void>()
    
    init(interactor: VideoPlaylistInteractor) {
        self.interactor = interactor
        super.init()
        setUpRx()
    }
    
    func getTaggedPages(media: Media) {
        startLoadTaggedPageOnDemand.onNext(media)
    }
    
    func setVideos(videos: [Video]) {
        self.itemsList.addAll(list: videos)
    }
    
    func setIndex(index: Int) {
        self.interactor.setIndex(index: index)
    }
    
    func setPageId(pageId: String) {
        self.pageId = pageId
    }
    
    func setPlaylistId(playlistId: String) {
        self.playlistId = playlistId
    }
    
    func setContentId(contentId: String?) {
        self.contentId = contentId
    }
    
    func setAccentColor(accentColor: UIColor?) {
        self.accentColor = accentColor
    }
    
    func getDetailPlaylist() {
        guard self.pageId != nil || self.playlistId != nil else { return }
        startLoadItemsOnDemand.onNext(())
    }
    
    // MARK: Private
    private func setUpRxGetTaggedPages() {
        startLoadTaggedPageOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetTaggedPages.onNext(())
            })
            .flatMap { [unowned self] media -> Observable<Media> in
                return self.interactor.getTaggedPagesFor(media: media)
                    .catchError { _ -> Observable<Media> in
                        self.onWillStopGetTaggedPages.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetTaggedPages.onNext(())
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
    
    private func setUpRx() {
        setUpRxForGetItems()
        setUpRxGetTaggedPages()
    }
    
    private func setUpRxForGetItems() {
        onDidLoadItems = startLoadItemsOnDemand
            .do(onNext: { [unowned self] _ in
                if self.itemsList.list.isEmpty {
                    self.onWillStartGetListItem.onNext(())
                }
            })
            .flatMap { [unowned self] _ -> Observable<ItemList> in
                guard self.pageId != nil || self.playlistId != nil else { return Observable.empty() }
                return self.interactor.getDetailOfPlayListFrom(pageId: self.pageId, contentId: self.contentId,
                                                               playlistId: self.playlistId)
            }
            .do(onNext: { [unowned self] _ in
                if self.itemsList.list.isEmpty {
                    self.onWillStopGetListItem.onNext(())
                }
            })
            .do(onNext: { [unowned self] itemList in
				self.injectAds(items: itemList)
                self.itemsList.addAll(list: itemList.list)
                self.itemsList.grandTotal = itemList.grandTotal
                self.itemsList.title = itemList.title
            })
        
        disposeBag.addDisposables([
            self.interactor.onErrorLoadItems.subscribe(onNext: { [unowned self] error in
                self.onWillStopGetListItem.onNext(())
                self.showError(error: error)
            })
        ])
        onFinishLoadListItem = interactor.onFinishLoadItems
        onErrorLoadListItem = interactor.onErrorLoadItems
    }
	
	private func injectAds(items: ItemList) {
		if items.list.isEmpty || items.list.first(where: { ($0 as? BannerAds != nil) }) != nil { return }
		items.insert(item: BannerAds(), index: 1)
	}
    
}
