//
//  SigninEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class SigninEntity: NSObject {
    var value: String
    var username: String
    
    init(value: String, username: String) {
        self.value = value
        self.username = username
    }
}
