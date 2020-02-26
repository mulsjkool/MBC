//
//  SearchInteractor.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol SearchInteractor {
    func getSearchSuggestion(searchText: String) -> Observable<[SearchSuggestion]>
    
    var onDidGetSearchSuggestionError: Observable<Error> { get }
    var onDidGetSearchSuggestionSuccess: Observable<Void> { get }
}
