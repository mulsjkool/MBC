//
//  PageDetailInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol PageDetailInteractor {
    func getPageDetailUrl(pageUrl: String) -> Observable<PageDetail>
    func getPageDetailBy(pageId: String) -> Observable<PageDetail>
    func shouldStartLoadItems()
    func getListScheduledChannels(pageId: String, fromTime: Double, toTime: Double) -> Observable<[Schedule]>
    
    var onFinishLoadItems: Observable<Void> { get }
    var onErrorLoadItems: Observable<Error> { get }
    var onErrorLoadAlbums: Observable<Error> { get }
    var onErrorLoadCustomVideoPlaylist: Observable<Error> { get }
    var onErrorGetPageDetail: Observable<Error> { get }
    var onGetRedirectUrl: Observable<String> { get }
    
    var onFinishLoadScheduledChannels: Observable<Void> { get }
    var onErrorLoadScheduledChannels: Observable<Error> { get }
    
    var selectedAlbumId: String? { get set }
    
    func getPageIndex() -> Int
    func getNextItems(pageId: String, ofPageMenu: PageMenuEnum, shouldUseCache: Bool) -> Observable<ItemList>
    func loadAlbums(pageId: String) -> Observable<ItemList>
	func loadNextAlbum(pageId: String, currentAlbumContentId: String,
					   publishDate: String, isNextAlbum: Bool) -> Observable<Album>
	func loadDescriptionOfPost(pageId: String, postId: String,
							   page: Int, pageSize: Int, damId: String) -> Observable<Album>
    func getTaggedPagesFor(media: Media) -> Observable<Media>
    func getNextDefaultPlaylistFrom(pageId: String)-> Observable<ItemList>
    func getCustomPlaylisFrom(pageId: String)-> Observable<ItemList>
    
    func getSchedulerFrom(channelId: String, fromTime: Double, toTime: Double) -> Observable<ItemList>
	
    func clearCache(pageId: String)
	func setPageSize(pageSize: Int)
	func resetPageSize()
    func getInfoComponent(pageId: String) -> Observable<[InfoComponent]>
}
