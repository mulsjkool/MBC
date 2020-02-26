//
//  GenreShow.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class GenreShowEntity {
    var id: String
    var code: String
    var defaultName: String
    var localeNamesAr: String
    var localeNamesEn: String
    
    init(id: String, code: String, defaultName: String, localeNamesAr: String, localeNamesEn: String) {
        self.id = id
        self.code = code
        self.defaultName = defaultName
        self.localeNamesAr = localeNamesAr
        self.localeNamesEn = localeNamesEn
    }
}
