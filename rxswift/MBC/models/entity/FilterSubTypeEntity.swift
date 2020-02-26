//
//  FilterSubTypeEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FilterSubTypeEntity {
    var type: String
    var mapSubTypes: [MapSubTypeEntity]?
    
    init(type: String, mapSubTypes: [MapSubTypeEntity]?) {
        self.type = type
        self.mapSubTypes = mapSubTypes
    }
}
