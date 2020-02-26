//
//  PageEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 11/24/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageEntity {
    var id: String
    var title: String
    var logo: String
    var posterUrl: String
    var externalUrl: String
    var gender: String
    let accentColor: String?

    init(id: String, title: String, logo: String, externalUrl: String,
         gender: String, accentColor: String?, posterUrl: String) {
        self.id = id
        self.title = title
        self.logo = logo
        self.externalUrl = externalUrl
        self.gender = gender
        self.accentColor = accentColor
        self.posterUrl = posterUrl
    }
    
    convenience init(id: String) {
        self.init(id: id, title: "", logo: "", externalUrl: "", gender: "", accentColor: nil, posterUrl: "")
    }
}
