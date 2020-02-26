//
//  AppListingApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol AppListingApi {
    func getListApp(params: [String: Any]) -> Observable<[FeedEntity]>
}
