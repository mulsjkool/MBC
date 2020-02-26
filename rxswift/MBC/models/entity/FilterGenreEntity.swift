//
//  FilterGenreEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class FilterGenreEntity {
    var subtypes: [String]?
    var id: String
    var name: String
    
    init(subtypes: [String]?, id: String, name: String) {
        self.subtypes = subtypes
        self.id = id
        self.name = name
    }
}
