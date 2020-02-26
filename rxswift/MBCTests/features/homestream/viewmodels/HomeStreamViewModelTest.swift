//
//  HomeStreamViewModelTest.swift
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

class HomeStreamViewModelTest: XCTestCase {
    var interactor: MockHomeStreamInteractor!
    var errorDecorator: MockErrorDecorator!
    var viewModel: HomeStreamViewModel!
    
    let campaignId1 = "uuid for a campaign"
    let campaignId2 = "uuid for another campaign"
    
    override func setUp() {
        super.setUp()

        interactor = MockHomeStreamInteractor()
        errorDecorator = MockErrorDecorator()

        stubbing()

        viewModel = HomeStreamViewModel(interactor: interactor)
    }

    private func stubbing() {
        stub(interactor) { stub in
            when(stub.onFinishLoadItems).get.thenReturn(Observable.just(()))
            when(stub.shouldStartLoadItems()).thenDoNothing()
            when(stub.getNextItems()).thenReturn(Observable.from(optional:
                HomeStreamDataFactory.getNextItems(ids: [campaignId1, campaignId2])))
        }

        stub(errorDecorator) { stub in
            when(stub.showError(message: anyString(), completed: any())).thenDoNothing()
        }
    }

    func testInit() {
        XCTAssert("\(type(of: viewModel.onDidLoadItems))".contains("Observable<Array<Campaign>>"),
                  "type should be \(type(of: viewModel.onDidLoadItems))")
    }

    func testDidLoadItemsSuccess() {
        _ = viewModel.onDidLoadItems.subscribe(onNext: { [unowned self] _ in
            XCTAssert(self.viewModel.itemsList.count == 2)
            if let aCampaign = self.viewModel.itemsList.first {
                XCTAssert(aCampaign.uuid == self.campaignId1)
            }
        })

        viewModel.loadItems()
    }

    func testOnWillStartStopToLoadItems() {
        stub(interactor) { stub in
            when(stub.getNextItems()).thenReturn(Observable.just([Campaign]()))
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

        viewModel.loadItems()
        XCTAssert(willStartCalled)
        XCTAssert(willStopCalled)
    }

    func testOnWillStopStillCalledInCaseLoadItemsError() {
        stub(interactor) { stub in
            when(stub.getNextItems())
                .thenReturn(
                    Observable.error(error: NetworkError.networkNotAvailable)
            )
        }

        var willStopCalled = false
        _ = viewModel.onDidLoadItems.subscribe(onNext: { _ in })
        _ = viewModel.onWillStopGetListItem.subscribe(onNext: { _ in
            willStopCalled = true
        })

        viewModel.loadItems()
        XCTAssert(willStopCalled)
    }
}
