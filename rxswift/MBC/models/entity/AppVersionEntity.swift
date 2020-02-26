//
//  AppVersionEntity.swift
//  MBC
//
//  Created by Dung Nguyen on 3/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AppVersionEntity {
    
    var status: String
    var message: String
    
    init(status: String, message: String) {
        self.message = message
        self.status = status
    }
    
}
