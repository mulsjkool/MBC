//
//  ActivityCardMessagePackageEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ActivityCardMessagePackageEntity {
    var messageFormat: String?
    var argumentList: [String]?
    var argumentNameList: [String]?
    
    init(messageFormat: String?, argumentList: [String]?, argumentNameList: [String]?) {
        self.messageFormat = messageFormat
        self.argumentList = argumentList
        self.argumentNameList = argumentNameList
    }
}
