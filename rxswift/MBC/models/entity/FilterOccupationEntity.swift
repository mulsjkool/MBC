//
//  FilterOccupationEntity.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterOccupationEntity {
    var name: String
    var title: String
    var monthOfBirthArray: [String]?
    
    init(name: String, title: String, monthOfBirthArray: [String]?) {
        self.name = name
        self.title = title
        self.monthOfBirthArray = monthOfBirthArray
    }
}
