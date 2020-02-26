//
//  PageHeaderViewModelTest.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

@testable import MBC
import XCTest

class PageHeaderViewModelTest: XCTestCase {
    
    func testInit() {
        let viewModel = PageHeaderViewModel(pageDetail: PageDetail(id: "page_id"))
        XCTAssertNotNil(viewModel.pageDetail)
        XCTAssert(viewModel.metadataString.isEmpty)
        
        let vModel = PageHeaderViewModel(pageDetail: nil)
        XCTAssertNil(vModel.pageDetail)
        XCTAssert(vModel.metadataString.isEmpty)
    }
}
