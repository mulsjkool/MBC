//
//  LanguageRepository.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/25/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

protocol LanguageRepository {
    func currentLanguage() -> String?
    func currentLanguageEnum() -> LanguageEnum?
    func setLanguage(language: LanguageEnum)
}
