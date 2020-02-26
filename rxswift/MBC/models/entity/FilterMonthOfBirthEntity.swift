//
//  FilterMonthOfBirthEntity.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterMonthOfBirthEntity {
    var name: String
    var title: String
    var occupationArray: [String]?
    
    init(name: String, title: String, occupationArray: [String]?) {
        self.name = name
        self.title = title
        self.occupationArray = occupationArray
    }
}
