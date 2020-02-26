//
//  ChannelRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class ChannelRepositoryImpl: ChannelRepository {
    
    private let dataKey = "key.user_defaults.data"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedChannelListKey = "key.user_defaults.cachedChannelList"
    
    private var expireTime: Int = 0
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveChannelList(channelList: [PageDetail]) {
        var newList = [PageDetail]()
        if let existingItems = getCachedChannelList() {
            newList = existingItems
        }
        
        newList.append(contentsOf: channelList)

        let key = "\(cachedChannelListKey)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newList) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedChannelList() -> [PageDetail]? {
        let key = "\(cachedChannelListKey)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearCachedChannelList()
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let list = try? JSONDecoder().decode([PageDetail].self, from: encodedData) {
            return list
        }
        
        return nil
    }
    
    func clearCachedChannelList() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedChannelListKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
}
