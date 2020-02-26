//
//  LanguageConfigEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class LanguageConfigEntity: Codable {
    var code: String
    var names = [LanguageConfigDataEntity]()
    
    init(code: String, names: [LanguageConfigDataEntity]) {
        self.code = code
        self.names = names
    }
}
