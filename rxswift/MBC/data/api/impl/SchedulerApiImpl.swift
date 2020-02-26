//
//  SchedulerApiImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class SchedulerApiImpl: BaseApiClient<[ScheduleEntity]>, SchedulerApi {
    
    let listScheduleJsontransformer: (JSON) -> [ScheduleEntity]
    
    init(apiClient: ApiClient, listScheduleJsontransformer: @escaping (JSON) -> [ScheduleEntity]) {
        self.listScheduleJsontransformer = listScheduleJsontransformer
        super.init(apiClient: apiClient, jsonTransformer: listScheduleJsontransformer)
    }
    
    private static let schedulerPath = "/content-presentations/channels/%@/shows?fromTime=%0.f&toTime=%0.f"
    
    func getListScheduler(channelId: String, fromTime: Double, toTime: Double) -> Observable<[ScheduleEntity]> {
        return apiClient.get(String(format: SchedulerApiImpl.schedulerPath, channelId, fromTime, toTime),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: listScheduleJsontransformer)
    }
    
    private static let schedulerOfAllChannels = "/content-presentations/shows?fromTime=%0.f&toTime=%0.f"
   
    func getSchedulerOfAllChannels(fromTime: Double, toTime: Double) -> Observable<[ScheduleEntity]> {
        return apiClient.get(String(format: SchedulerApiImpl.schedulerOfAllChannels, fromTime, toTime),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: listScheduleJsontransformer)
    }
}
