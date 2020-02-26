//
//  RemoteNotificationTransformer.swift
//  MBC
//
//  Created by admin on 3/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class RemoteNotificationJsonTransformer: JsonTransformer {
    
    private static let dataFields = "data"

    func transform(json: JSON) -> RemoteNotificationEntity {
        let dataFields = RemoteNotificationJsonTransformer.dataFields
        
        let data = json[dataFields].string ?? ""
        
        return RemoteNotificationEntity(data: data)
    }
}
