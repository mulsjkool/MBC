//
//  FilterShowSubTypeEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FilterShowSubTypeEntity {
    var name: String
    var genres: [String]?
    
    init(genres: [String]?, name: String) {
        self.genres = genres
        self.name = name
    }
}
