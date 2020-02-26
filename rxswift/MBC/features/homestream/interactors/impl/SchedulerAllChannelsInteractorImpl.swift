//
//  SchedulerAllChannelsInteractorImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class SchedulerAllChannelsInteractorImpl: SchedulerAllChannelsInteractor {
    
    private let schedulerApi: SchedulerApi
    
    private var errorLoadItemsInSubject = PublishSubject<Error>()
    
    init(schedulerApi: SchedulerApi) {
        self.schedulerApi = schedulerApi
    }
    
    var onErrorLoadItems: Observable<Error> {
        return errorLoadItemsInSubject.asObservable()
    }
    
    func getShedulersAllChannel(fromTime: Double, toTime: Double) -> Observable<[SchedulerOnChannel]> {
        return schedulerApi.getSchedulerOfAllChannels(fromTime: fromTime, toTime: toTime)
            .catchError { error -> Observable<[ScheduleEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                return Observable.empty()
            }
        .map { schedulers in
            let items = schedulers.sorted(by: { obj1, obj2 -> Bool in
                if obj1.startTime.compare(obj2.startTime) == .orderedSame {
                    if let publishDate1 = obj1.channelPublishedDate, let publishDate2 = obj2.channelPublishedDate {
                        return publishDate1.compare(publishDate2) == .orderedDescending
                    }
                }
                return obj1.startTime.compare(obj2.startTime) == .orderedDescending
            })
            
            let dictionary = NSMutableDictionary()
            var schedulersOnChannelArray = [SchedulerOnChannel]()
            for schedule in items {
                var schedulerOnChannel = dictionary[schedule.channelId] as? SchedulerOnChannel
                if schedulerOnChannel == nil {
                    let scheduler = SchedulerOnChannel()
                    scheduler.schedules = [Schedule]()
                    scheduler.channelId = schedule.channelId
                    scheduler.channelName = schedule.channelTitle
                    scheduler.schedules.append(Schedule(entity: schedule))
                    dictionary[schedule.channelId] = scheduler
                    schedulersOnChannelArray.append(scheduler)
                    schedulerOnChannel = scheduler
                    schedulerOnChannel?.channelLogo = schedule.channelLogo ?? ""
                }
                schedulerOnChannel?.schedules.append(Schedule(entity: schedule))
                
            }
            return schedulersOnChannelArray
        }
    }
}
