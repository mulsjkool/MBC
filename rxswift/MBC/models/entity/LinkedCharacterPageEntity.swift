//
//  LinkedPageEntity.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class LinkedCharacterPageEntity: Codable {
    var entityId: String
    var displayName: String
    
    init(entityId: String, displayName: String) {
        self.entityId = entityId
        self.displayName = displayName
    }
}
