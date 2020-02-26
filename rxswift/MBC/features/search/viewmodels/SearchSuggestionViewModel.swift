//
//  SearchSuggestionViewModel.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class SearchSuggestionViewModel: BaseViewModel {
    private var interactor: SearchInteractor
    
    private let startGetSearchSuggestionOnDemand = PublishSubject<String>()
    
    var onFinishGetSearchSuggestion: Observable<Void>!
    var onWillStartGetSearchSuggestion = PublishSubject<Void>()
    var onWillStopGetSearchSuggestion = PublishSubject<Void>()
    
    private(set) var arraySearchSuggestion = [SearchSuggestion]()
    
    var onShowSearchSuggestionError = PublishSubject<GigyaCodeEnum>()
    
    init(interactor: SearchInteractor) {
        self.interactor = interactor
        
        super.init()
        setUpRx()
    }
    
    func getGetSearchSuggestion(searchText: String) {
        startGetSearchSuggestionOnDemand.onNext(searchText)
    }
    
    func setArraySearchSuggestion(array: [SearchSuggestion]) {
        self.arraySearchSuggestion = array
    }
    
    // MARK: Private functions
    
    private func setUpRx() {
        setUpRxForGetItems()
    }
    
    private func setUpRxForGetItems() {
        onFinishGetSearchSuggestion = startGetSearchSuggestionOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetSearchSuggestion.onNext(())
            })
            .flatMap({ [unowned self] searchText -> Observable<[SearchSuggestion]> in
                return self.interactor.getSearchSuggestion(searchText: searchText)
                    .catchError({ error -> Observable<[SearchSuggestion]> in
                        self.onWillStopGetSearchSuggestion.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    })
            })
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetSearchSuggestion.onNext(())
            })
            .do(onNext: { [unowned self] list in
                self.setArraySearchSuggestion(array: list)
            })
            .map { _ in Void() }
    }
}
