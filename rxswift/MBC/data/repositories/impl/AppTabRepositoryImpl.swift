//
//  AppTabRepositoryImpl.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class AppTabRepositoryImpl: AppTabRepository {
    private let dataKey = "key.user_defaults.data"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedAppListKey = "key.user_defaults.cachedApplist"
    private let cachedAppGrandTotalKey = "key.user_defaults.cachedApplist_grandTotal"
    private let cachedInStreamAppsKey = "key.user_defaults.cachedInStreamApps"
    private let cachedRemainingAppsKey = "key.user_defaults.cachedRemainingApps"
    
    private var expireTime: Int = 0
    
    private var inMemoryList: [String: [App]] = [String: [App]]()
    private let bag = DisposeBag()
    private var dataDisposables = [Disposable]()
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveAppsListFor(pageId: String, appList: [App], grandTotal: Int?) {
        var newArray = [App]()
        if let existingList = getCachedAppsListFor(pageId: pageId).list {
            newArray = existingList
        }
        newArray.append(contentsOf: appList)
        
        let key = "\(cachedAppListKey)_\(pageId)"
        
        inMemoryList[key] = newArray
        subcribeLike(newArray, forPage: pageId)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let total = grandTotal {
                let totalKey = "\(cachedAppGrandTotalKey)_\(pageId)"
                UserDefaults.standard.set(total, forKey: totalKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedAppsListFor(pageId: String) -> (list: [App]?, grandTotal: Int) {
        let key = "\(cachedAppListKey)_\(pageId)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return (nil, 0)
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return (nil, 0)
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            removeListCacheForPage(pageId: pageId)
            return (nil, 0)
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return (nil, 0)
        }
        
        let totalKey = "\(cachedAppGrandTotalKey)_\(pageId)"
        let cachedGrandTotal = UserDefaults.standard.integer(forKey: totalKey)
        
        if let data = inMemoryList[key] { return (list: data, grandTotal: cachedGrandTotal) }
        
        if let list = try? JSONDecoder().decode([App].self, from: encodedData) {
            inMemoryList[key] = list
            
            return (list: list, grandTotal: cachedGrandTotal)
        }
        
        return (nil, 0)
    }
    
    func clearCachedAppsListFor(pageId: String) {
        let key = "\(cachedAppListKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func removeListCacheForPage(pageId: String) {
        let key = "\(cachedAppListKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func subcribeLike(_ list: [App], forPage: String) {
        dataDisposables.forEach { disposable in
            disposable.dispose()
        }
        
        for app in list {
            let disposeable = app.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveAppsListFor(pageId: forPage, appList: [], grandTotal: nil)
            })
            
            disposeable.disposed(by: bag)
            dataDisposables.append(disposeable)
        }
    }
    
    func getInStreamApps() -> [App]? {
        return getCachedHomeStreamApps(key: cachedInStreamAppsKey)
    }
    
    func getRemainingApps() -> [App]? {
        return getCachedHomeStreamApps(key: cachedRemainingAppsKey)
    }
    
    private func getCachedHomeStreamApps(key: String) -> [App]? {
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            if key == cachedRemainingAppsKey {
                clearCachedRemainingApps()
            } else {
                clearCachedInStreamApps()
            }
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let list = try? JSONDecoder().decode([App].self, from: encodedData) {
            return list
        }
        
        return nil
    }
    
    private func saveHomeStreamApps(appList: [App], key: String) {
        var newArray = [App]()
        if let existingList = getCachedHomeStreamApps(key: key) {
            newArray = existingList
        }
        newArray.append(contentsOf: appList)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func saveInStreamApps(appList: [App]) {
        saveHomeStreamApps(appList: appList, key: cachedInStreamAppsKey)
    }
    
    func saveRemainingApps(appList: [App]) {
        saveHomeStreamApps(appList: appList, key: cachedRemainingAppsKey)
    }
    
    func clearCachedInStreamApps() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedInStreamAppsKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    func clearCachedRemainingApps() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedRemainingAppsKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
}
