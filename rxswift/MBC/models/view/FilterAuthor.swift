//
//  FilterAuthor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterAuthor {
    var listSubType: [String]?
    var id: String
    var title: String
    
    init(entity: FilterAuthorEntity) {
        self.listSubType = entity.listSubType
        self.id = entity.id
        self.title = entity.title
    }
}
