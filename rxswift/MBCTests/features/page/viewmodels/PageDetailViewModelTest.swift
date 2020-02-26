//
//  PageDetailViewModelTest.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

@testable import MBC
import Cuckoo
import RxSwift
import RxBlocking
import XCTest

class PageDetailViewModelTest: XCTestCase {
    var pageDetailInteractor: MockPageDetailInteractor!
    var errorDecorator: MockErrorDecorator!
    var viewModel: PageDetailViewModel!
    
    let pageId = "page_id"
    let albumId1 = "albumId1"
    let albumId2 = "albumId2"
        
    override func setUp() {
        super.setUp()
        
        pageDetailInteractor = MockPageDetailInteractor()
        errorDecorator = MockErrorDecorator()
        
        stubbing()
        
        viewModel = PageDetailViewModel(interactor: pageDetailInteractor)
        //viewModel.setPageId(pageId)
    }
    
    private func stubbing() {
        stub(pageDetailInteractor) { stub in
            when(stub.onFinishLoadItems).get.thenReturn(Observable.just(()))
            when(stub.getPageDetailBy(pageId: pageId))
                .thenReturn(Observable.just(PageDataFactory.getPageDetail(id: pageId)))
            when(stub.loadAlbums(pageId: pageId))
                .thenReturn(Observable.just(PageDataFactory.getAlbumsList(ids: [albumId1, albumId2])))
            when(stub.getNextItems(pageId: pageId, ofPageMenu: PageMenuEnum.newsfeed))
                .thenReturn(Observable.just(PageDataFactory.getNewsFeedItems(ids: [pageId])))
            when(stub.shouldStartLoadItems()).thenDoNothing()
            when(stub.selectedAlbumId.get).thenReturn(albumId1)
        }
        
        stub(errorDecorator) { stub in
            when(stub.showError(message: anyString(), completed: any())).thenDoNothing()
        }
    }
    
    func testInit() {
        XCTAssert("\(type(of: viewModel.onDidGetPageDetail))".contains("Observable<()>"))
    }
    
    func testDidGetFeaturesPageSuccess() {
        _ = viewModel.onDidGetPageDetail.subscribe(onNext: { [unowned self] _ in
            XCTAssert(self.viewModel.details != nil &&
                self.viewModel.details!.entityId == self.pageId
            )
        })
        
        viewModel.getPageDetailByPageId()
    }
    
    func testOnWillStartStopToGetPageDetails() {
        var willStartCalled = false
        var willStopCalled = false
        _ = viewModel.onDidGetPageDetail.subscribe(onNext: { })
        _ = viewModel.onWillStartGetPageDetail.subscribe(onNext: { _ in
            willStartCalled = true
        })
        _ = viewModel.onWillStopGetPageDetail.subscribe(onNext: { _ in
            willStopCalled = true
        })
        
        viewModel.getPageDetailByPageId()
        XCTAssert(willStartCalled)
        XCTAssert(willStopCalled)
    }
    
    func testOnWillStopStillCalledInCaseGetDetailsError() {
        stub(pageDetailInteractor) { stub in
            when(stub.getPageDetailBy(pageId: anyString()))
                .thenReturn(
                    Observable.error(error: NetworkError.networkNotAvailable)
            )
        }
        
        var willStopCalled = false
        _ = viewModel.onDidGetPageDetail.subscribe(onNext: { })
        _ = viewModel.onWillStopGetPageDetail.subscribe(onNext: { _ in
            willStopCalled = true
        })
        
        viewModel.getPageDetailByPageId()
        XCTAssert(willStopCalled)
    }
    
    func testDidLoadAlbumsSuccess() {
        _ = viewModel.onDidLoadAlbums.subscribe(onNext: { [unowned self] _ in
            XCTAssert(self.viewModel.albumsList.count == 2)
            if let media = self.viewModel.albumsList.list.first as? Media {
                XCTAssert(media.id == self.albumId1)
            }
        })
        
        viewModel.loadAlbums()
    }
    
    func testOnWillStartStopToLoadAlbums() {
        var willStartCalled = false
        var willStopCalled = false
        _ = viewModel.onDidLoadAlbums.subscribe(onNext: { })
        _ = viewModel.onWillStartLoadAlbums.subscribe(onNext: { _ in
            willStartCalled = true
        })
        _ = viewModel.onWillStopLoadAlbums.subscribe(onNext: { _ in
            willStopCalled = true
        })
        
        viewModel.loadAlbums()
        XCTAssert(willStartCalled)
        XCTAssert(willStopCalled)
    }
    
    func testOnWillStopStillCalledInCaseLoadAlbumsError() {
        stub(pageDetailInteractor) { stub in
            when(stub.loadAlbums(pageId: anyString()))
                .thenReturn(
                    Observable.error(error: NetworkError.networkNotAvailable)
            )
        }
        
        var willStopCalled = false
        _ = viewModel.onDidLoadAlbums.subscribe(onNext: { })
        _ = viewModel.onWillStopLoadAlbums.subscribe(onNext: { _ in
            willStopCalled = true
        })
        
        viewModel.loadAlbums()
        XCTAssert(willStopCalled)
    }
    
    func testLoadItems() {
        stub(pageDetailInteractor) { stub in
            let albumId: String? = nil
            when(stub.selectedAlbumId.set(albumId)).thenDoNothing()
        }
        
        var willStartCalled = false
        var willStopCalled = false
        _ = viewModel.onDidLoadItems.subscribe(onNext: { _ in })
        _ = viewModel.onWillStartGetListItem.subscribe(onNext: { _ in
            willStartCalled = true
        })
        _ = viewModel.onWillStopGetListItem.subscribe(onNext: { _ in
            willStopCalled = true
        })

        viewModel.loadItems(forPageMenu: .newsfeed)
        XCTAssert(willStartCalled)
        XCTAssert(willStopCalled)
    }
    
    func testResetItemsAndLoadItems() {
        viewModel.resetItemsAndLoadItemsFor(pageMenu: .newsfeed)
        XCTAssert(viewModel.albumsList.list.isEmpty)
        XCTAssert(viewModel.lastestCountItemData == 0)
        XCTAssert(viewModel.currentCountItemData == 0)
    }
    
    func testResetData() {
        viewModel.albumsList.addAll(list: PageDataFactory.getAlbumsList(ids: ["1", "2"]).list)
        viewModel.itemsList.addAll(list: PageDataFactory.getNewsFeedItems(ids: ["3", "4", "5"]).list)
        XCTAssertFalse(viewModel.albumsList.list.isEmpty)
        XCTAssertFalse(viewModel.itemsList.list.isEmpty)
            
        viewModel.resetData()
        XCTAssert(viewModel.lastestCountItemData == 0)
        XCTAssert(viewModel.currentCountItemData == 0)
        XCTAssert(viewModel.itemsList.list.isEmpty)
    }
    
    func testGetAccentColor() {
        XCTAssertNil(viewModel.getAccentColor())
        
        _ = viewModel.onDidGetPageDetail.subscribe(onNext: { [unowned self] _ in
            XCTAssertNotNil(self.viewModel.getAccentColor())
        })
        viewModel.getPageDetailByPageId()
    }
}
