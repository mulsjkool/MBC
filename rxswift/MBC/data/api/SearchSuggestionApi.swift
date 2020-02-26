//
//  SearchSuggestionApi.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchSuggestionApi {
    func getSearchSuggestion(searchText: String) -> Observable<[SearchSuggestionEntity]>
}
