//
//  ChannelListingViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class ChannelListingViewModel: BaseViewModel {
    
    private var interactor: ChannelListingInteractor
    private let startLoadChannelListOnDemand = PublishSubject<Void>()

    // Rx
    var onFinishLoadListItem = PublishSubject<Void>()
    var onWillStartGetListItem = PublishSubject<Void>()
    var onWillStopGetListItem = PublishSubject<Void>()
    
    private(set) var itemsList = [PageDetail]()
    private var isRefreshingData = false
    private var didLoadChannelList = false
    
    init(interactor: ChannelListingInteractor) {
        self.interactor = interactor
        
        super.init()
        setUpRx()
    }
    
    func clearCache() {
        interactor.clearCache()
    }
    
    func refreshItems() {
        isRefreshingData = true
        interactor.clearCache()
        didLoadChannelList = false
        loadItems()
    }
    
    func loadItems() {
        if didLoadChannelList { return }
        startLoadChannelListOnDemand.onNext(())
    }

    // MARK: Private functions
    
    private func setUpRx() {
        setUpRxForGetItems()
    }
    
    private func setUpRxForGetItems() {
        disposeBag.addDisposables([
            startLoadChannelListOnDemand
                .do(onNext: { [unowned self] _ in
                    self.onWillStartGetListItem.onNext(())
                })
                .flatMap { [unowned self] _ -> Observable<[PageDetail]> in
                    return self.interactor.getNextItems()
                }
                .do(onNext: { [unowned self] pages in
                    if self.isRefreshingData {
                        self.itemsList.removeAll()
                        self.isRefreshingData = false
                    }
                    self.itemsList.append(contentsOf: pages)
                })
                .do(onNext: { [unowned self] _ in
                    self.onWillStopGetListItem.onNext(())
                    if self.didLoadChannelList {
                        self.onFinishLoadListItem.onNext(())
                    }
                })
                .subscribe(),
            
            interactor.onErrorLoadItems.subscribe(onNext: { [unowned self] error in
                self.showError(error: error)
            }),
            interactor.onFinishLoadChannelList.subscribe(onNext: { [unowned self] _ in
                self.didLoadChannelList = true
            })
        ])
    }
}
