//
//  PageDetailInteractorTest.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

@testable import MBC
import Cuckoo
import RxSwift
import RxBlocking
import XCTest

class PageDetailInteractorTest: XCTestCase {
    let pageDetailApi = MockPageDetailApi()
    let pageAlbumApi = MockPageAlbumApi()
    let streamApi = MockStreamApi()
    let pageDetailRepository = MockPageDetailRepository()
    let streamRepository = MockStreamRepository()
    let pageAlbumRepository = MockPageAlbumRepository()
    let languageApi = MockLanguageConfigApi()
    let languageConfigRepository = MockLanguageConfigRepository()
    
    var interactor: PageDetailInteractor!
    
    let pageId = "a page id"
    let postId1 = "post1"
    let albumId1: String? = "albumId1"
    
    override func setUp() {
        super.setUp()
        
        interactor = PageDetailInteractorImpl(pageDetailApi: pageDetailApi,
                                              pageAlbumApi: pageAlbumApi,
                                              streamApi: streamApi,
                                              languageConfigApi: languageApi,
                                              pageDetailRepository: pageDetailRepository,
                                              streamRepository: streamRepository,
                                              pageAlbumRepository: pageAlbumRepository,
                                              languageConfigRepository: languageConfigRepository)
        
        stubbing()
    }
    
    private func stubbing() {
        stub(pageDetailApi) { stub in
            when(stub.getPageDetailBy(pageId: pageId)).thenReturn(Observable.just(PageDetailEntity(id: pageId)))
        }
        stub(streamApi) { stub in
            var feeds = [FeedEntity]()
            feeds.append(FeedEntity(id: postId1))
            
            when(stub.loadStreamBy(pageId: pageId, fromIndex: 0, numberOfItems: 5))
            .thenReturn(Observable.just(StreamEntity(items: feeds, total: 1)))
        }
        stub(pageDetailRepository) { stub in
            when(stub.getCachedPageDetail(pageId: pageId)).thenReturn(PageDetail(id: pageId))
            when(stub.savePageDetail(pageDetail: PageDetail(id: pageId))).thenDoNothing()
        }
        stub(streamRepository) { stub in
            var posts = [Post]()
            posts.append(Post(id: postId1))
            when(stub.getCachedPosts(pageId: pageId)).thenReturn(posts)
            when(stub.savePosts(pageId: pageId, posts: posts)).thenDoNothing()
        }
        stub(pageAlbumApi) { stub in
            when(stub.loadAlbumOf(pageId: pageId, albumId: albumId1, fromIndex: 0, numberOfItems: 5))
                .thenReturn(Observable.just(AlbumEntity(id: albumId1!)))
        }
    }
    
    func testGetPageDetailByIdWithCache() {
        guard let details = try? interactor.getPageDetailBy(pageId: pageId).toBlocking().first(),
            let pDetail = details else {
                XCTFail("There is a problem when getting page dtail")
                return
        }
        
        XCTAssert(pDetail.entityId == pageId)
    }
    
    func testGetPageDetailByIdWithoutCache() {
        stub(pageDetailRepository) { stub in
            when(stub.getCachedPageDetail(pageId: pageId)).thenReturn(nil)
        }
        
        guard let details = try? interactor.getPageDetailBy(pageId: pageId).toBlocking().first(),
            let pDetail = details else {
                XCTFail("There is a problem when getting page dtail")
                return
        }
        
        XCTAssert(pDetail.entityId == pageId)
    }
    
    func testgetNextItemsPost() {
        // with cache
        guard let posts = try? interactor.getNextItems(pageId: pageId, ofPageMenu: PageMenuEnum.newsfeed)
            .toBlocking().toArray() else {
                XCTFail("Something wrong")
                return
        }
        // swiftlint:disable force_cast
        XCTAssert(posts.count == 1 && posts[0].list is [Post] && (posts[0].list.first as! Post).uuid == postId1)
        
        // without cache
        stub(streamRepository) { stub in
            when(stub.getCachedPosts(pageId: pageId)).thenReturn(nil)
        }
        guard let posts1 = try? interactor.getNextItems(pageId: pageId, ofPageMenu: PageMenuEnum.newsfeed)
            .toBlocking().toArray() else {
                XCTFail("Something wrong")
                return
        }
        
        XCTAssert(posts1.count == 1 && posts1[0].list is [Post] && (posts1[0].list.first as! Post).uuid == postId1)
    }
    
//    func testgetNextItemsMedia() {
//        // with cache
//        guard let medias = try? interactor.getNextItems(pageId: pageId, ofPageMenu: PageMenuEnum.photos)
//            .toBlocking().toArray() else {
//                XCTFail("Something wrong")
//                return
//        }
//        XCTAssert(medias.count == 1 && medias[0].list is [Media] && (medias[0].list.first as! Media).uuid == postId1)
//    }
    
}
