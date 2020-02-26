//
//  ActivityCardMessagePackage.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ActivityCardMessagePackage: Codable {
    var messageFormat: String?
    var argumentList: [String]?
    var argumentNameList: [String]?
    
    init(entity: ActivityCardMessagePackageEntity) {
        self.messageFormat = entity.messageFormat
        self.argumentList = entity.argumentList
        self.argumentNameList = entity.argumentNameList
    }
}
