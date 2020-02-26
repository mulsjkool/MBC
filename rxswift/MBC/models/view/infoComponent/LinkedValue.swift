//
//  LinkedValue.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class LinkedValue: Codable {
    var metadata: [InfoMetaData]
    
    init(entity: LinkedValueEntity) {
        self.metadata = entity.metadata.map {
            InfoMetaData(entity: $0)
        }
    }

}
