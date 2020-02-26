//
//  FacebookProfile.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/14/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

struct FacebookProfile {
    var fbId: String
    var fbToken: String
    var name: String?
    var email: String?
    var gender: String?
    var birthday: Date?
    
    init(fbId: String, fbToken: String, name: String? = nil, email: String? = nil,
         gender: String? = nil, birthday: Date? = nil) {
        self.fbId = fbId
        self.fbToken = fbToken
        self.name = name
        self.email = email
        self.gender = gender
        self.birthday = birthday
    }
}
