//
//  PageDetailApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol PageDetailApi {
    // Get page detail by pageId
    func getPageDetailBy(pageId: String) -> Observable<PageDetailEntity>
}
