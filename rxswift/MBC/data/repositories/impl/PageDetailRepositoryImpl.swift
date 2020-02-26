//
//  PageDetailRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageDetailRepositoryImpl: PageDetailRepository {
    
    private let pageDetailDataKey = "key.user_defaults.pageDetailData"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedPageDetailKey = "key.user_defaults.cachedPageDetail"
    private var expireTime: Int = 0
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func savePageDetail(pageDetail: PageDetail) {
        let key = "\(cachedPageDetailKey)_\(pageDetail.entityId)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(pageDetail) {
            let dictionary = [pageDetailDataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedPageDetail(pageId: String) -> PageDetail? {
        let key = "\(cachedPageDetailKey)_\(pageId)"
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
        
        guard let encodedData = dictionary[pageDetailDataKey] as? Data else {
            return nil
        }
        let pageDetail = try? JSONDecoder().decode(PageDetail.self, from: encodedData)
        return pageDetail
    }
    
    func clearPageDetailCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedPageDetailKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    func clearPageDetailCache(pageId: String) {
        let key = "\(cachedPageDetailKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func removeCacheForPage(pageId: String) {
        let key = "\(cachedPageDetailKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
