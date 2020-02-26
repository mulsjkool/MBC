//
//  MenuInteractorTest.swift
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

class MenuInteractorTest: XCTestCase {
    var pageApi: MockPageApi!
    var menuInteractor: MenuInteractor!
    
    override func setUp() {
        super.setUp()
        
        pageApi = MockPageApi()
        
        menuInteractor = MenuInteractorImpl(pageApi: pageApi)
        
        stub(pageApi) { stub in
            when(stub.getFeaturePagesBy(siteName: any())).thenReturn(
                Observable.just(PageEntityDataFactory.getListPageEntity(ids: ["1", "2"])))
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetFeaturePagesBy() {
        // swiftlint:disable force_try
        let result = try! menuInteractor.getFeaturePagesBy(siteName: "MBC").toBlocking().toArray().first
        
        XCTAssertNotNil(result )
        XCTAssert(result!.count == 2)
    }
    
}
