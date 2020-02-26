//
//  LanguageRepositoryImpl.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/25/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

class LanguageRepositoryImpl: LanguageRepository {
    
    private var userDefaults: UserDefaults
    
    private let currentLanguageKey = "key.user_defaults.current_language"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func currentLanguage() -> String? {
        let language = userDefaults.object(forKey: currentLanguageKey) as? String
        return language
    }
    
    func currentLanguageEnum() -> LanguageEnum? {
        guard let language = userDefaults.object(forKey: currentLanguageKey) as? String else {
            return nil
        }
        return LanguageEnum(rawValue: language)
    }
    
    func setLanguage(language: LanguageEnum) {
        userDefaults.set(language.rawValue, forKey: currentLanguageKey)
        userDefaults.synchronize()
    }
}
