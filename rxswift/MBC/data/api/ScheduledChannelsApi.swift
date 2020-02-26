//
//  ScheduledChannelsApi.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol ScheduledChannelsApi {
    func getListScheduledChannels(pageId: String, fromTime: Double, toTime: Double) -> Observable<[ScheduleEntity]>
}
