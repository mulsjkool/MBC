//
//  SearchSuggestionFooterCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class SearchSuggestionFooterCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    
    let didTapCell = PublishSubject<String>()
    
    private var searchText: String!
    
    func bindData(searchText: String) {
        self.searchText = searchText
        titleLabel.text = R.string.localizable.searchSuggestionShowAllResult()
        setupEvents()
    }
    
    private func setupEvents() {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapCell.onNext(self.searchText)
            })
            .disposed(by: disposeBag)
    }
}
