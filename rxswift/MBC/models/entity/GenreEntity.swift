//
//  GenreEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/17/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class GenreEntity {
    var names: String
    var id: String
    
    init(id: String, names: String) {
        self.names = names
        self.id = id
    }
}
