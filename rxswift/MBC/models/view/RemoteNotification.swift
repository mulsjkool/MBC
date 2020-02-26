//
//  RemoteNotification.swift
//  MBC
//
//  Created by admin on 3/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class RemoteNotification: Codable {
    
    var data: String
    
    init(entity: RemoteNotificationEntity) {
        self.data = entity.data
    }
}
