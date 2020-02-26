//
//  LanguageConfigDataEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class LanguageConfigDataEntity: Codable {
    var text: String
    var locate: String
    
    init(text: String, locate: String) {
        self.text = text
        self.locate = locate
    }
}
