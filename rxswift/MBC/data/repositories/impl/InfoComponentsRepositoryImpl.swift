//
//  InfoComponentsRepositoryImpl.swift
//  MBC
//
//  Created by Dung Nguyen on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class InfoComponentsRepositoryImpl: InfoComponentsRepository {
    
    private let infoComponentDataKey = "key.user_defaults.infoComponent"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedInfoComponentKey = "key.user_defaults.cachedInfoComponent"
    private var expireTime: Int = 60
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveInfoComponent(pageId: String, component: [InfoComponent]) {
        let key = "\(cachedInfoComponentKey)_\(pageId)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(component) {
            let dictionary = [infoComponentDataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedInfoComponent(pageId: String) -> [InfoComponent]? {
        let key = "\(cachedInfoComponentKey)_\(pageId)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            removeCacheForPage(pageId: pageId)
            return nil
        }
        
        guard let encodedData = dictionary[infoComponentDataKey] as? Data else {
            return nil
        }
        let infoComponents = try? JSONDecoder().decode([InfoComponent].self, from: encodedData)
        return infoComponents
    }
    
    func clearInfoComponentCache(pageId: String) {
        let key = "\(cachedInfoComponentKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func clearInfoComponentCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedInfoComponentKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    private func removeCacheForPage(pageId: String) {
        let key = "\(cachedInfoComponentKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
