//
//  StarPageListingRepositoryImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class StarPageListingRepositoryImpl: StarPageListingRepository {
    private let dataKey = "key.user_defaults.data"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedInCampaignListKey = "key.user_defaults.cachedStarsInCampaignList"
    private let cachedRemainingListKey = "key.user_defaults.cachedStarsRemainingList"
    
    private var expireTime: Int = 0
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveInCampaignList(list: [Star]) {
        saveHomeStreamApps(list: list, key: cachedInCampaignListKey)
    }
    
    func saveRemainingList(list: [Star]) {
        saveHomeStreamApps(list: list, key: cachedRemainingListKey)
    }
    
    func getInCampaignList() -> [Star]? {
        return getCachedHomeStreamApps(key: cachedInCampaignListKey)
    }
    
    func getRemainingList() -> [Star]? {
        return getCachedHomeStreamApps(key: cachedRemainingListKey)
    }
    
    func clearCachedInCampaignList() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedInCampaignListKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    func clearCachedRemainingList() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedRemainingListKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Private methods
    
    private func getCachedHomeStreamApps(key: String) -> [Star]? {
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            if key == cachedRemainingListKey {
                clearCachedRemainingList()
            } else {
                clearCachedInCampaignList()
            }
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let list = try? JSONDecoder().decode([Star].self, from: encodedData) {
            return list
        }
        
        return nil
    }
    
    private func saveHomeStreamApps(list: [Star], key: String) {
        var newArray = [Star]()
        if let existingList = getCachedHomeStreamApps(key: key) {
            newArray = existingList
        }
        newArray.append(contentsOf: list)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
}
