//
//  BundleItem.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class BundleItem: Codable {
    var type: String
    var order: Int
    var entityId: String
    
    init(entity: BundleItemEntity) {
        self.type = entity.type
        self.order = entity.order
        self.entityId = entity.entityId
    }
}
