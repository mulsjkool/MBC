//
//  SchedulerAllChannelsViewModel.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class SchedulerAllChannelsViewModel: BaseViewModel {
    private var interactor: SchedulerAllChannelsInteractor
    
    private let startLoadItemsOnDemand = PublishSubject<Void>()
    private(set) var schannelArray = [SchedulerOnChannel]()
    private(set) var isLoadingData = false
    
    // Rx
    var onDidLoadItems: Observable<[SchedulerOnChannel]>! /// finish loading a round
    var onWillStartGetListItem = PublishSubject<Void>()
    var onWillStopGetListItem = PublishSubject<Void>()
    var onDidError = PublishSubject<Void>()
    
    init(interactor: SchedulerAllChannelsInteractor) {
        self.interactor = interactor
        super.init()
        
        setUpRx()
    }
    
    func loadItems() {
        if !isLoadingData {
            startLoadItemsOnDemand.onNext(())
        }
    }
    
    private func setUpRx() {
        setUpRxForGetItems()
    }
    
    private func setUpRxForGetItems() {
        onDidLoadItems = startLoadItemsOnDemand
            .do(onNext: { [unowned self] _ in
                self.isLoadingData = true
                self.onWillStartGetListItem.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<[SchedulerOnChannel]> in
                let fromDate = Date().startOfDay
                if let toDate = Date.addDaysFrom(currentDate: fromDate,
                                                 count: Constants.DefaultValue.totalDayForScheduler - 1)?.endOfDay {
                     return self.interactor.getShedulersAllChannel(fromTime: fromDate.milliseconds,
                                                                   toTime: toDate.milliseconds)
                }
                return Observable.empty()
            }
            .do(onNext: { [unowned self] schannelArray in
                self.schannelArray = schannelArray
            })
            .do(onNext: { [unowned self] _ in
                self.isLoadingData = false
                self.onWillStopGetListItem.onNext(())
            })
        disposeBag.addDisposables([
            interactor.onErrorLoadItems.subscribe(onNext: { [unowned self] error in
                self.isLoadingData = false
                self.onDidError.onNext(())
                self.showError(error: error)
            })
        ])
    }
    
}
