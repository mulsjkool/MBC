//
//  LinkedCharacterPage.swift
//  MBC
//
//  Created by Dung Nguyen on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class LinkedCharacterPage: Codable {
    var entityId: String
    var displayName: String
    
    init(entity: LinkedCharacterPageEntity) {
        self.entityId = entity.entityId
        self.displayName = entity.displayName
    }
    
}
