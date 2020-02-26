//
//  InfoMetaData.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class InfoMetaData: Codable {
    var code: String
    var name: String
    
    init(entity: InfoMetaDataEntity) {
        self.code = entity.code
        self.name = entity.name
    }

}
