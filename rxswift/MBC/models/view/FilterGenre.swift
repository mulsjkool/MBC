//
//  FilterGenre.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FilterGenre {
    var subtypes: [String]?
    var id: String
    var name: String
    
    init(entity: FilterGenreEntity) {
        self.subtypes = entity.subtypes
        self.id = entity.id
        self.name = entity.name
    }
}
