//
//  PageApi.swift
//  MBC
//
//  Created by Dao Le Quang on 11/23/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol PageApi {
    // Get feature pages by a site name.
    // In first step, we have only 1 site (mbc.net). This is an consumable API in future
    func getFeaturePagesBy(siteName: String) -> Observable<[PageEntity]>
}
