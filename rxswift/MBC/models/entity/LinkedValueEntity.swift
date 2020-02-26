//
//  LinkedValueEntity.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class LinkedValueEntity: Codable {
    
    var metadata: [InfoMetaDataEntity]
    
    init(metadata: [InfoMetaDataEntity]) {
        self.metadata = metadata
    }
}
