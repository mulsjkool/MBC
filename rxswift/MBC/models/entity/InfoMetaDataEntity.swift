//
//  InfoMetaDataEntity.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class InfoMetaDataEntity: Codable {
    var code: String
    var name: String
    
    init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}
