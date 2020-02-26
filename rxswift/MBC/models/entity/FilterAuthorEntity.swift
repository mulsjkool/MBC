//
//  FilterAuthorEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FilterAuthorEntity {
    var listSubType: [String]?
    var id: String
    var title: String
    
    init(listSubType: [String]?, id: String, title: String) {
        self.listSubType = listSubType
        self.id = id
        self.title = title
    }
}
