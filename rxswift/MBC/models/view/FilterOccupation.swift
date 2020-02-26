//
//  FilterOccupation.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterOccupation {
    var name: String
    var title: String
    var monthOfBirthArray: [String]?
    
    init(entity: FilterOccupationEntity) {
        self.name = entity.name
        self.title = entity.title
        self.monthOfBirthArray = entity.monthOfBirthArray
    }
}
