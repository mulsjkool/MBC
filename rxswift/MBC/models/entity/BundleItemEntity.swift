//
//  BundleItemEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class BundleItemEntity {
    var type: String
    var order: Int
    var entityId: String
    
    init(type: String, order: Int, entityId: String) {
        self.type = type
        self.order = order
        self.entityId = entityId
    }
}
