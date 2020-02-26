//
//  StarPageListingApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol StarPageListingApi {
    func getStarPageList(params: [String: Any]) -> Observable<[PageDetailEntity]>
}
