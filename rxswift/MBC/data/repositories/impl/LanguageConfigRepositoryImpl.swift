//
//  LanguageConfigRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/21/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class LanguageConfigRepositoryImpl: LanguageConfigRepository {
    private let dataKey = "key.user_defaults.LanguageConfigData"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedLanguageConfigKey = "key.user_defaults.cachedLanguageConfig"
    private var expireTime: Int = 0
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveLanguageConfig(languageConfig: LanguageConfigListEntity) {
        let key = "\(cachedLanguageConfigKey)_\(languageConfig.type)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(languageConfig) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getLanguageConfig(type: String) -> LanguageConfigListEntity? {
        let key = "\(cachedLanguageConfigKey)_\(type)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }

        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            return nil
        }

        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        let languageConfig = try? JSONDecoder().decode(LanguageConfigListEntity.self, from: encodedData)
        return languageConfig
    }
    
    func clearLanguageConfigCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedLanguageConfigKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
}
