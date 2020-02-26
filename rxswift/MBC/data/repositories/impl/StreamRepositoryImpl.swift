//
//  StreamRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit
import RxSwift

class StreamRepositoryImpl: StreamRepository {
    private let pageStreamDataKey = "key.user_defaults.pageStreamData"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedPageStreamDataKey = "key.user_defaults.cachedpageStream"
    private let cachedPageStreamIndexKey = "key.user_defaults.cachedpageStream_index"
    private let cachedPageStreamLoadedItemKey = "key.user_defaults.cachedpageStream_loadedItem"
    
    private let campaignsDataKey = "key.user_defaults.campaignsData"
    private let campaignsLastStoredTimeKey = "key.user_defaults.campaignsLastStoredTime"
    private let cachedCampaignsKey = "key.user_defaults.cachedCampaigns"
    private let cachedCampaignsIndexKey = "key.user_defaults.cachedCampaigns_index"
    private let cachedCampaignsLoadedItemKey = "key.user_defaults.cachedCampaigns_loadedItem"
    
    private let videosDataKey = "key.user_defaults.videosData"
    private let videosLastStoredTimeKey = "key.user_defaults.videosLastStoredTime"
    private let cachedVideosKey = "key.user_defaults.cachedvideos"
    private let cachedVideosIndexKey = "key.user_defaults.cachedvideos_index"
    private let cachedVideosLoadedItemKey = "key.user_defaults.cachedvideos_loadedItem"
    
    private var inMemoryHomeData: [Campaign]?
    private var inMemoryVideoData: [Campaign]?
    private var inMemoryPageData: [String: ItemList] = [String: ItemList]()
    private let bag = DisposeBag()
    private var pageDataDisposables = [Disposable]()
    private var homeDataDisposables = [Disposable]()
    private var videoDataDisposables = [Disposable]()
    private var expireTime: Int = 0
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?) {
        var newList = ItemList()
        if let existingList = getCachedPageStream(pageId: pageId).itemList {
            newList = existingList
        }
        newList.addAll(list: itemList.list)
        
        let key = "\(cachedPageStreamDataKey)_\(pageId)"
        inMemoryPageData[key] = newList
        subcribeLike(newList, forPage: pageId)

        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newList.list.map { CacheHolder(item: $0) }) {
            let dictionary = [pageStreamDataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]

            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let index_loaded = dataIndex {
                let indexKey = "\(cachedPageStreamIndexKey)_\(pageId)"
                let totalLoadedKey = "\(cachedPageStreamLoadedItemKey)_\(pageId)"
                UserDefaults.standard.set(index_loaded.index, forKey: indexKey)
                UserDefaults.standard.set(index_loaded.totalLoaded, forKey: totalLoadedKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedPageStream(pageId: String) -> (itemList: ItemList?, index: Int, totalLoaded: Int) {
        let key = "\(cachedPageStreamDataKey)_\(pageId)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return (itemList: nil, index: 0, totalLoaded: 0)
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return (itemList: nil, index: 0, totalLoaded: 0)
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            removePageStreamCacheForPage(pageId: pageId)
            return (itemList: nil, index: 0, totalLoaded: 0)
        }
        
        guard let encodedData = dictionary[pageStreamDataKey] as? Data else {
            return (itemList: nil, index: 0, totalLoaded: 0)
        }
        
        let indexKey = "\(cachedPageStreamIndexKey)_\(pageId)"
        let totalLoadedKey = "\(cachedPageStreamLoadedItemKey)_\(pageId)"
        let index = UserDefaults.standard.integer(forKey: indexKey)
        let totalLoaded = UserDefaults.standard.integer(forKey: totalLoadedKey)
        
        if let data = inMemoryPageData[key] {
            return (itemList: data, index: index, totalLoaded: totalLoaded)
        }
        
        if let decodedList = try? JSONDecoder().decode([CacheHolder].self, from: encodedData) {
            inMemoryPageData[key] = ItemList(items: decodedList.map { $0.toAnyObject() })
            
            return (itemList: inMemoryPageData[key], index: index, totalLoaded: totalLoaded)
        }
        
        return (itemList: nil, index: 0, totalLoaded: 0)
    }
    
    private func removePageStreamCacheForPage(pageId: String) {
        let key = "\(cachedPageStreamDataKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
        inMemoryPageData.removeValue(forKey: key)
    }
    
    func clearPageStreamCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedPageStreamDataKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
        inMemoryPageData.removeAll()
    }
    
    func clearPageStreamCache(pageId: String) {
        let key = "\(cachedPageStreamDataKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // campaigns
    func saveCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?) {
        var newList = [Campaign]()
        if let existingItems = getCachedCampaigns().list {
            newList = existingItems
        }
        
        newList.append(contentsOf: campaigns)
        
        inMemoryHomeData = newList
        subcribeLike(newList)
        
        let key = "\(cachedCampaignsKey)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newList) {
            let dictionary = [campaignsDataKey: encodedData,
                              campaignsLastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let index_loaded = dataIndex {
                let indexKey = "\(cachedCampaignsIndexKey)"
                let totalLoadedKey = "\(cachedCampaignsLoadedItemKey)"
                UserDefaults.standard.set(index_loaded.index, forKey: indexKey)
                UserDefaults.standard.set(index_loaded.totalLoaded, forKey: totalLoadedKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int) {
        let key = "\(cachedCampaignsKey)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return (list: nil, index: 0, totalLoaded: 0)
        }
        
        guard let lastStored = dictionary[campaignsLastStoredTimeKey] as? Double else {
            return (list: nil, index: 0, totalLoaded: 0)
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearCampaignsCache()
            return (list: nil, index: 0, totalLoaded: 0)
        }
        
        guard let encodedData = dictionary[campaignsDataKey] as? Data else {
            return (list: nil, index: 0, totalLoaded: 0)
        }
        
        let indexKey = "\(cachedCampaignsIndexKey)"
        let totalLoadedKey = "\(cachedCampaignsLoadedItemKey)"
        let index = UserDefaults.standard.integer(forKey: indexKey)
        let totalLoaded = UserDefaults.standard.integer(forKey: totalLoadedKey)
        
        if let data = inMemoryHomeData {
            return (list: data, index: index, totalLoaded: totalLoaded)
        }
        
        if let data = try? JSONDecoder().decode([Campaign].self, from: encodedData) {
            inMemoryHomeData = data
            subcribeLike(data)
            return (list: data, index: index, totalLoaded: totalLoaded)
        }
        
        return (list: nil, index: 0, totalLoaded: 0)
    }
    
    func clearCampaignsCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedCampaignsKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
        inMemoryHomeData = nil
    }
    
    func saveVideoCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?) {
        var newList = [Campaign]()
        if let existingItems = getCachedVideoCampaigns().list {
            newList = existingItems
        }
        
        newList.append(contentsOf: campaigns)
        
        inMemoryVideoData = newList
        subcribeLikeVideoStream(newList)
        
        let key = "\(cachedVideosKey)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newList) {
            let dictionary = [videosDataKey: encodedData,
                              videosLastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let index_loaded = dataIndex {
                let indexKey = "\(cachedVideosIndexKey)"
                let totalLoadedKey = "\(cachedVideosLoadedItemKey)"
                UserDefaults.standard.set(index_loaded.index, forKey: indexKey)
                UserDefaults.standard.set(index_loaded.totalLoaded, forKey: totalLoadedKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedVideoCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int) {
        let key = "\(cachedVideosKey)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return (list: nil, index: 0, totalLoaded: 0)
        }
        
        guard let lastStored = dictionary[videosLastStoredTimeKey] as? Double else {
            return (list: nil, index: 0, totalLoaded: 0)
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearVideoCampaignsCache()
            return (list: nil, index: 0, totalLoaded: 0)
        }
        
        guard let encodedData = dictionary[videosDataKey] as? Data else {
            return (list: nil, index: 0, totalLoaded: 0)
        }
        
        let indexKey = "\(cachedVideosIndexKey)"
        let totalLoadedKey = "\(cachedVideosLoadedItemKey)"
        let index = UserDefaults.standard.integer(forKey: indexKey)
        let totalLoaded = UserDefaults.standard.integer(forKey: totalLoadedKey)
        
        if let data = inMemoryVideoData {
            return (list: data, index: index, totalLoaded: totalLoaded)
        }
        
        if let data = try? JSONDecoder().decode([Campaign].self, from: encodedData) {
            inMemoryVideoData = data
            subcribeLikeVideoStream(data)
            return (list: data, index: index, totalLoaded: totalLoaded)
        }
        
        return (list: nil, index: 0, totalLoaded: 0)
    }
    
    func clearVideoCampaignsCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedVideosKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
        inMemoryVideoData = nil
    }
    
    private func subcribeLikeVideoStream(_ campaigns: [Campaign]) {
        videoDataDisposables.forEach { disposable in
            disposable.dispose()
        }
        for c in campaigns {
            for feed in c.items {
                let disposeable = feed.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.saveVideoCampaigns([], dataIndex: nil)
                })
                disposeable.disposed(by: bag)
                videoDataDisposables.append(disposeable)
                
                if feed is Post, let p = feed as? Post {
                    // post's elements
                    guard let medias = p.medias else { return }
                    for media in medias {
                        let disposeable = media.onToggleLikeSubject.subscribe(onNext: { _ in
                            self.saveVideoCampaigns([], dataIndex: nil)
                        })
                        disposeable.disposed(by: bag)
                        videoDataDisposables.append(disposeable)
                    }
                }
            }
        }
    }
    
    private func subcribeLike(_ itemList: ItemList, forPage: String) {
        pageDataDisposables.forEach { disposable in
            disposable.dispose()
        }
        for item in itemList.list {
            if let likable = item as? Likable {
                let disposeable = likable.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.savePageStream(pageId: forPage, itemList: ItemList(), dataIndex: nil)
                })
                disposeable.disposed(by: bag)
                pageDataDisposables.append(disposeable)
            }
            
            if let p = item as? Post {
                // post's elements
                guard let medias = p.medias else { return }
                for media in medias {
                    let disposeable = media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                        self.savePageStream(pageId: forPage, itemList: ItemList(), dataIndex: nil)
                    })
                    disposeable.disposed(by: bag)
                    pageDataDisposables.append(disposeable)
                }
            }
        }
    }
    
    private func subcribeLike(_ campaigns: [Campaign]) {
        homeDataDisposables.forEach { disposable in
            disposable.dispose()
        }
        for c in campaigns {
            for feed in c.items {
                let disposeable = feed.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.saveCampaigns([], dataIndex: nil)
                })
                disposeable.disposed(by: bag)
                homeDataDisposables.append(disposeable)
                
                if feed is Post, let p = feed as? Post {
                    // post's elements
                    guard let medias = p.medias else { return }
                    for media in medias {
                        let disposeable = media.onToggleLikeSubject.subscribe(onNext: { _ in
                            self.saveCampaigns([], dataIndex: nil)
                        })
                        disposeable.disposed(by: bag)
                        homeDataDisposables.append(disposeable)
                    }
                }
            }
        }
    }
}
