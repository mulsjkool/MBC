//
//  AppVersion.swift
//  MBC
//
//  Created by Dung Nguyen on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AppVersion: Codable {
    
    var status: String
    var message: String
    
    init(entity: AppVersionEntity) {
        self.message = entity.message
        self.status = entity.status
    }
}
