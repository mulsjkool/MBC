//
//  AppVersionJsonTransformer.swift
//  MBC
//
//  Created by Dung Nguyen on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class AppVersionJsonTransformer: JsonTransformer {
    
    private static let statusFields = "status"
    private static let messageFields = "message"
    
    func transform(json: JSON) -> AppVersionEntity {
        
        let statusFields = AppVersionJsonTransformer.statusFields
        let messageFields = AppVersionJsonTransformer.messageFields
        
        let status = json[statusFields].string ?? ""
        let message = json[messageFields].string ?? ""
        return AppVersionEntity(status: status, message: message)
    }
}
