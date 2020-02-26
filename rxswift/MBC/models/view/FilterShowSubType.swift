//
//  FilterShowSubType.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FilterShowSubType {
    var name: String
    var genres: [String]?
    
    init(entity: FilterShowSubTypeEntity) {
        self.name = entity.name
        self.genres = entity.genres
    }
}
