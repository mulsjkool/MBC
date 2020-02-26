//
//  MenuViewModelTest.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/1/17.
//  Copyright © 2017 MBC. All rights reserved.
//

@testable import MBC
import Cuckoo
import RxSwift
import RxBlocking
import XCTest

class MenuViewModelTest: XCTestCase {
    var menuInteractor: MockMenuInteractor!
    var errorDecorator: MockErrorDecorator!
    var viewModel: MenuViewModel!
    
    override func setUp() {
        super.setUp()
        
        menuInteractor = MockMenuInteractor()
        errorDecorator = MockErrorDecorator()
        
        viewModel = MenuViewModel(interactor: menuInteractor)
        
        stub(menuInteractor) { stub in
            when(stub.getFeaturePagesBy(siteName: anyString()))
                .thenReturn(
                    Observable.just(PageDataFactory.getListPage(ids: ["1", "2", "3"]))
            )
        }
        
        stub(errorDecorator) { stub in
            when(stub.showError(message: anyString(), completed: any())).thenDoNothing()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        XCTAssert(viewModel.siteName == Constants.DefaultValue.SiteName)
        XCTAssert("\(type(of: viewModel.onDidGetFeaturePages))".contains("Observable<()>"))
    }
    
    func testDidGetFeaturesPageSuccess() {
        _ = viewModel.onDidGetFeaturePages.subscribe(onNext: { [unowned self] _ in
            XCTAssert(self.viewModel.totalFeaturePageItems == 3)
        })
        
        viewModel.startToGetFeaturePages()
    }
    
    func testOnWillStartToGetFeaturePages() {
        var willStartCalled = false
        _ = viewModel.onDidGetFeaturePages.subscribe(onNext: { })
        _ = viewModel.onWillStartToGetFeaturePages.subscribe(onNext: { _ in
            willStartCalled = true
        })
        
        viewModel.startToGetFeaturePages()
        XCTAssert(willStartCalled == true)
    }
    
    func testOnWillStopToGetFeaturePages() {
        var willStopCalled = false
        _ = viewModel.onDidGetFeaturePages.subscribe(onNext: { })
        _ = viewModel.onWillStopToGetFeaturePages.subscribe(onNext: { _ in
            willStopCalled = true
        })
        
        viewModel.startToGetFeaturePages()
        XCTAssert(willStopCalled == true)
    }
    
    func testOnWillStopStillCalledInCaseGetPagesError() {
        stub(menuInteractor) { stub in
            when(stub.getFeaturePagesBy(siteName: anyString()))
                .thenReturn(
                    Observable.error(error: NetworkError.networkNotAvailable)
            )
        }
        
        var willStopCalled = false
        _ = viewModel.onDidGetFeaturePages.subscribe(onNext: { })
        _ = viewModel.onWillStopToGetFeaturePages.subscribe(onNext: { _ in
            willStopCalled = true
        })
        
        viewModel.startToGetFeaturePages()
        XCTAssert(willStopCalled == true)
    }
    
    func testShowErrorIsCalledInCaseGetPagesError() {
        stub(menuInteractor) { stub in
            when(stub.getFeaturePagesBy(siteName: anyString()))
                .thenReturn(
                    Observable.error(error: NetworkError.networkNotAvailable)
            )
        }
        
        viewModel.errorDecorator = errorDecorator
        
        _ = viewModel.onDidGetFeaturePages.subscribe(onNext: { })
        
        viewModel.startToGetFeaturePages()
        
        verify(self.errorDecorator).showError(message: anyString(), completed: any())
    }
    
    func testMiscelaneous() {
        XCTAssert(self.viewModel.totalStaticItems == 9)
        XCTAssert(self.viewModel.totalAboutItems == 9)
        _ = viewModel.onDidGetFeaturePages.subscribe(onNext: { [unowned self] _ in
            XCTAssert(self.viewModel.totalFeaturePageItems == 3)
            
            XCTAssertNil(self.viewModel.featurePageItemAt(index: 10))
            XCTAssertNotNil(self.viewModel.featurePageItemAt(index: 2))
            
            XCTAssertNil(self.viewModel.staticPageItemAt(index: 10))
            XCTAssertNotNil(self.viewModel.staticPageItemAt(index: 2))
            
            XCTAssertNil(self.viewModel.aboutItemAt(index: 10))
            XCTAssertNotNil(self.viewModel.aboutItemAt(index: 2))
        })
        
        viewModel.startToGetFeaturePages()
    }
}
