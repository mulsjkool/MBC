//
//  InterestEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class InterestEntity: Codable {
    let uuid: String
    let name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
}
