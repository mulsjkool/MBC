//
//  ListingFilterTableViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class ListingFilterTableViewModel: BaseViewModel {
    var filter: ListingFilter?
    var onWillReload = PublishSubject<Void>()

    func selectRow(index: Int) {
        guard let filter = filter else { return }
        filter.selectRow(index: index)
        filter.activeFilterMode = .none
        onWillReload.onNext(())
    }
}
