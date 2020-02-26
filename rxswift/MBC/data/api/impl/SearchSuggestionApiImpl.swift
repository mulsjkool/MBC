//
//  SearchSuggestionApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class SearchSuggestionApiImpl: BaseApiClient<[SearchSuggestionEntity]>, SearchSuggestionApi {
    
    private static let getSearchSuggestionPath = "/search/suggestion"
    
    func getSearchSuggestion(searchText: String) -> Observable<[SearchSuggestionEntity]> {
        return apiClient.get(SearchSuggestionApiImpl.getSearchSuggestionPath,
                             parameters: ["term": searchText],
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
