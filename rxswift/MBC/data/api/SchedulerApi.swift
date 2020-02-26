//
//  SchedulerApi.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol SchedulerApi {
    func getListScheduler(channelId: String, fromTime: Double, toTime: Double) -> Observable<[ScheduleEntity]>
    func getSchedulerOfAllChannels(fromTime: Double, toTime: Double) -> Observable<[ScheduleEntity]>
}
