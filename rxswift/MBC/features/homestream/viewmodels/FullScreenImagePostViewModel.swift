//
//  FullScreenImagePostViewModel.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class FullScreenImagePostViewModel: BaseViewModel {
	private var interactor: PageDetailInteractor
	var medias = ItemList()
	
	private var pageId: String!
	private var albumId: String?
	private var pageSize: Int!
    private let startLoadTaggedPageOnDemand = PublishSubject<Media>()
    
    // Tagged Pages
    var onDidTaggedPages: Observable<Media>!
    var onWillStartGetTaggedPages = PublishSubject<Void>()
    var onWillStopGetTaggedPages = PublishSubject<Void>()
    //End Tagged Pages
	private var startLoadItemsOnDemand = PublishSubject<PageMenuEnum>()
	private var startLoadNextAlbumOnDemand = PublishSubject<(String, String, String, Bool)>()
	private var startLoadDescriptionOndemand = PublishSubject<(String, String, Int, Int)>()
	// Generic items
	var onDidLoadItems: Observable<ItemList>! /// finish loading a round
	var onFinishLoadListItem: Observable<Void>! /// finish loading the whole collection
	var onWillStartGetListItem = PublishSubject<Void>()
	var onWillStopGetListItem = PublishSubject<Void>()
	// NextAlbum
	var onDidLoadNextAlbum: Observable<Album>!
	var onWillStartGetNextAlbum = PublishSubject<Void>()
	var onWillStopGetNextAlbum = PublishSubject<Void>()
	// get description of post
	var onDidLoadDescription: Observable<Album>!
	var onWillStartGetDescription = PublishSubject<Void>()
	var onWillStopGetDescription = PublishSubject<Void>()
	var descriptionOfImages: Album?
	
	init(interactor: PageDetailInteractor) {
		self.interactor = interactor
		super.init()
		setUpRx()
	}
	
	// MARK: Private functions
	
	private func setUpRx() {
		setUpRxForGetItems()
		setUpRxForGetNextAlbum()
		setUpRxForLoadDescription()
        setUpRxGetTaggedPages()
	}
	
	func loadListDataFrom(pageId: String, albumId: String?, pageSize: Int) {
		self.pageId = pageId
		self.albumId = albumId
		self.pageSize = pageSize
		startLoadItemsOnDemand.onNext(.photos)
	}
    
    func getTaggedPages(media: Media) {
        startLoadTaggedPageOnDemand.onNext(media)
    }
	
	func loadNextAlbum(pageId: String, currentAlbumContentId: String, publishedDate: String, isNext: Bool) {
		self.pageId = pageId
		startLoadNextAlbumOnDemand.onNext((pageId, currentAlbumContentId, publishedDate, isNext))
	}
	
	func loadDescription(pageId: String, postId: String, page: Int, pageSize: Int) {
		self.pageId = pageId
		startLoadDescriptionOndemand.onNext((pageId, postId, page, pageSize))
	}
    
    private func setUpRxGetTaggedPages() {
        onDidTaggedPages = startLoadTaggedPageOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetTaggedPages.onNext(())
            })
            .flatMap { [unowned self] media -> Observable<Media> in
                return self.interactor.getTaggedPagesFor(media: media)
                    .catchError { error -> Observable<Media> in
                        self.onWillStopGetTaggedPages.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetTaggedPages.onNext(())
            })
           // .map { media in Media }
    }
	
	private func setUpRxForLoadDescription() {
		onDidLoadDescription = startLoadDescriptionOndemand
			.do(onNext: { [unowned self] _ in
				self.onWillStartGetDescription.onNext(())
			}).flatMap({ [unowned self] pageId, postId, page, pageSize -> Observable<Album> in
				return self.interactor.loadDescriptionOfPost(pageId: pageId, postId: postId,
															 page: page,
															 pageSize: pageSize,
															 damId: Components.instance.configurations.damId).catchError({ error -> Observable<Album> in
					self.onWillStopGetDescription.onNext(())
					self.showError(error: error)
					return Observable.empty()
				})
			})
			.do(onNext: { [unowned self] _ in
				self.onWillStopGetDescription.onNext(())
			}).do(onNext: { [unowned self] album in
				self.descriptionOfImages = album
			})
	}
	
	private func setUpRxForGetNextAlbum() {
		onDidLoadNextAlbum = startLoadNextAlbumOnDemand
			.do(onNext: { [unowned self] _ in
			self.onWillStartGetNextAlbum.onNext(())
			})
			.flatMap { [unowned self] pageId, currentAlbumContentId, publishedDate, isNext -> Observable<Album> in
				return self.interactor.loadNextAlbum(pageId: pageId, currentAlbumContentId: currentAlbumContentId,
													 publishDate: publishedDate, isNextAlbum: isNext).catchError { error -> Observable<Album> in
					self.onWillStopGetNextAlbum.onNext(())
					self.showError(error: error)
					return Observable.empty()
				}
			}
			.do(onNext: { [unowned self] _ in
				self.onWillStopGetNextAlbum.onNext(())
			})
	}
	
	private func setUpRxForGetItems() {
		onDidLoadItems = startLoadItemsOnDemand
			.do(onNext: { [unowned self] _ in
				if self.medias.list.isEmpty {
					self.onWillStartGetListItem.onNext(())
					self.interactor.shouldStartLoadItems()
				}
			})
			.flatMap { [unowned self] _ -> Observable<ItemList> in
				self.interactor.setPageSize(pageSize: self.pageSize)
				self.interactor.selectedAlbumId = self.albumId
				return self.interactor.getNextItems(pageId: self.pageId, ofPageMenu: .photos, shouldUseCache: false)
					.catchError { error -> Observable<ItemList> in
						self.onWillStopGetListItem.onNext(())
						self.showError(error: error)
						return Observable.empty()
					}
			}
			.do(onNext: { [unowned self] _ in
				if self.medias.list.isEmpty {
					self.onWillStopGetListItem.onNext(())
				}
			})
			.do(onNext: { [unowned self] itemList in
				self.medias.addAll(list: itemList.list)
				self.interactor.resetPageSize()
				
			})
		onFinishLoadListItem = interactor.onFinishLoadItems
	}

}
