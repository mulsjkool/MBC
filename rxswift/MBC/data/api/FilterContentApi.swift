//
//  FilterContentApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol FilterContentApi {
    func getFilterContent(type: String) -> Observable<FilterContentEntity>
    func getStarFilterContent() -> Observable<FilterContentEntity>
    func getShowFilterContent() -> Observable<FilterContentEntity>
}
