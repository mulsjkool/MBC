//
//  Author.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
class AuthorEntity {
    var authorId: String
    var active: Bool
    var name: String
    var avatarUrl: String
    var universalUrl: String
    var gender: String?
    var accentColor: String?
    
    init(authorId: String, name: String, avatarUrl: String, universalUrl: String, active: Bool = true,
         gender: String?, accentColor: String?) {
        self.authorId = authorId
        self.name = name
        self.avatarUrl = avatarUrl
        self.universalUrl = universalUrl
        self.active = active
        self.gender = gender
        self.accentColor = accentColor
    }
}
