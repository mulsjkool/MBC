//
//  FilterMonthOfBirth.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterMonthOfBirth {
    var name: String
    var title: String = ""
    var occupationArray: [String]?
    
    init(entity: FilterMonthOfBirthEntity) {
        self.name = entity.name
        if !entity.title.isEmpty, let monthText = StarPageMonthOfBirth(rawValue: entity.title) {
            self.title = monthText.localizedMonthOfBirth()
        }
        
        self.occupationArray = entity.occupationArray
    }
}
