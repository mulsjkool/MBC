//
//  HomeStreamInteractor.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeStreamInteractor {
    func shouldStartLoadItems()
	
    func getNextItems() -> Observable<([Campaign], SearchStatistic?)>
    func clearCache()
    func setForVideoStream()
	func setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool)
    func getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>
    
    var onFinishLoadItems: Observable<Void> { get }
    var onErrorLoadItems: Observable<Error> { get }
}
