//
//  LanguageConfigListEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class LanguageConfigListEntity: Codable {
    var type: String
    var dataList = [LanguageConfigEntity]()
    
    init(type: String, dataList: [LanguageConfigEntity]) {
        self.type = type
        self.dataList = dataList
    }
}
