//
//  FilterSubType.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterSubType {
    var type: String
    var mapSubTypes: [MapSubTypeEntity]?
    
    init(entity: FilterSubTypeEntity) {
        self.type = entity.type
        self.mapSubTypes = entity.mapSubTypes
    }
}
