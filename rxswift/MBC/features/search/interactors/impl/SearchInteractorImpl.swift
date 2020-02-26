//
//  SearchInteractorImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class SearchInteractorImpl: SearchInteractor {
	
	private var searchSuggestionApi: SearchSuggestionApi!
	
	init(searchSuggestionApi: SearchSuggestionApi) {
		self.searchSuggestionApi = searchSuggestionApi
	}
    
    var onDidGetSearchSuggestionError: Observable<Error> {
        return self.getSearchSuggestionErrorInSubject.asObserver()
    }
    
    var onDidGetSearchSuggestionSuccess: Observable<Void> {
        return self.getSearchSuggestionSuccessInSubject.asObserver()
    }
    
    private var getSearchSuggestionErrorInSubject = PublishSubject<Error>()
    private var getSearchSuggestionSuccessInSubject = PublishSubject<Void>()
    
    func getSearchSuggestion(searchText: String) -> Observable<[SearchSuggestion]> {
        return searchSuggestionApi.getSearchSuggestion(searchText: searchText)
            .catchError { error -> Observable<[SearchSuggestionEntity]> in
                self.getSearchSuggestionErrorInSubject.onNext(error)
                return Observable.empty()
            }
            .map { items in
                return items.map({ SearchSuggestion(entity: $0) })
            }
            .do(onNext: { [unowned self] _ in
                self.getSearchSuggestionSuccessInSubject.onNext(())
            })
    }
}
