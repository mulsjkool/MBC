//
//  ScheduledChannelsApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class ScheduledChannelsApiImpl: BaseApiClient<[ScheduleEntity]>, ScheduledChannelsApi {
    
    let listScheduledChannelsJsonTransfomer: (JSON) -> [ScheduleEntity]
    
    override init(apiClient: ApiClient, jsonTransformer: @escaping (JSON) -> [ScheduleEntity]) {
        self.listScheduledChannelsJsonTransfomer = jsonTransformer
        super.init(apiClient: apiClient, jsonTransformer: listScheduledChannelsJsonTransfomer)
    }
    
    private static let fields = (
        fromTime : "fromTime",
        toTime : "toTime"
    )
    
    private static let path = "/content-presentations/shows/%@/scheduled-channels"
    
    func getListScheduledChannels(pageId: String, fromTime: Double, toTime: Double) -> Observable<[ScheduleEntity]> {
        let fields = ScheduledChannelsApiImpl.fields
        let params: [String: Any] = [
            fields.fromTime: String(format: "%0.f", fromTime),
            fields.toTime: String(format: "%0.f", toTime)
        ]
        
        return apiClient.get(String(format: ScheduledChannelsApiImpl.path, pageId),
                             parameters: params,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: listScheduledChannelsJsonTransfomer)
    }
}
