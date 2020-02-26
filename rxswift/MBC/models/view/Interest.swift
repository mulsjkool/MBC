//
//  Interest.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Interest: Codable {
    var uuid: String
    var name: String
    
    init(entity: InterestEntity) {
        self.uuid = entity.uuid
        self.name = entity.name
    }
	
	convenience init(name: String) {
		self.init(entity: InterestEntity(uuid: "", name: name))
	}
}
