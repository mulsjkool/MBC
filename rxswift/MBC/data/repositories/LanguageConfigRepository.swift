//
//  LanguageConfigRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/21/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

protocol LanguageConfigRepository {
    func saveLanguageConfig(languageConfig: LanguageConfigListEntity)
    func getLanguageConfig(type: String) -> LanguageConfigListEntity?
    func clearLanguageConfigCache()
}
