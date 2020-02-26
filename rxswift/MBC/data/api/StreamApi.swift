//
//  StreamApi.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol StreamApi {
    func loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<StreamEntity>
    func loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>
    func loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity>
	func getSearchResult(data: SearchCondition) -> Observable<SearchResultEntity>
}
