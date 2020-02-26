//
//  VideoPlayListRepositoryImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class VideoPlayListRepositoryImpl: VideoPlayListRepository {
    
    private let dataKey = "key.user_defaults.defaultPlaylistData"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedDefaultPlaylistKey = "key.user_defaults.cachedDefaultPlaylist"
    private let cachedCustomPlaylistKey = "key.user_defaults.cachedDefaultPlaylist"
    private let cachedVideoGrandTotalKey = "key.user_defaults.cachedPlaylist_grandTotal"
    private var expireTime: Int = 0
    
    private var inMemoryList: [String: [Video]] = [String: [Video]]()
    private let bag = DisposeBag()
    private var dataDisposables = [Disposable]()
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    // MARK: Public
    func saveVideosForCustomPlaylist(playlistId: String, pageId: String, videolist: [Video], grandTotal: Int?) {
        var newArray = [Video]()
        if let existingPlayList = getCachedVideoOfCustomPlaylist(playlistId: playlistId, pageId: pageId).0 {
            newArray = existingPlayList
        }
        newArray.append(contentsOf: videolist)
        let key = "\(cachedCustomPlaylistKey)_\(pageId)_\(playlistId)"
        inMemoryList[key] = newArray
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            if let total = grandTotal {
                let totalKey = "\(cachedVideoGrandTotalKey)_\(pageId)_\(playlistId)"
                UserDefaults.standard.set(total, forKey: totalKey)
            }
            UserDefaults.standard.synchronize()
        }
        
    }
    
    func saveDefaultPlaylist(pageId: String, videolist: [Video], grandTotal: Int?) {
        var newArray = [Video]()
        if let existingPlayList = getCachedDefaultPlaylist(pageId: pageId).0 {
            newArray = existingPlayList
        }
        newArray.append(contentsOf: videolist)
        let key = "\(cachedDefaultPlaylistKey)_\(pageId)"
        inMemoryList[key] = newArray
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let total = grandTotal {
                let totalKey = "\(cachedVideoGrandTotalKey)_\(pageId)"
                UserDefaults.standard.set(total, forKey: totalKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedDefaultPlaylist(pageId: String) -> ([Video]?, Int) {
        let key = "\(cachedDefaultPlaylistKey)_\(pageId)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else { return (nil, 0) }
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else { return (nil, 0) }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            removeDefaulPlayListCacheForPage(pageId: pageId)
            return (nil, 0)
        }
        guard let encodeData = dictionary[dataKey] as? Data else { return (nil, 0) }
        let totalKey = "\(cachedVideoGrandTotalKey)_\(pageId)"
        let cachedGrandTotal = UserDefaults.standard.integer(forKey: totalKey)
        if let data = inMemoryList[key] { return (data, cachedGrandTotal) }
        if let defaultPlayList = try? JSONDecoder().decode([Video].self, from: encodeData) {
            inMemoryList[key] = defaultPlayList
            return (defaultPlayList, cachedGrandTotal)
        }
        return (nil, 0)
    }
    
    func getCachedVideoOfCustomPlaylist(playlistId: String, pageId: String) -> ([Video]?, Int) {
        let key = "\(cachedCustomPlaylistKey)_\(pageId)_\(playlistId)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else { return (nil, 0) }
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else { return (nil, 0) }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            removeVideosOfCustomPlayListCacheForPage(pageId: pageId, playlistId: playlistId)
            return (nil, 0)
        }
        guard let encodeData = dictionary[dataKey] as? Data else { return (nil, 0) }
        let totalKey = "\(cachedVideoGrandTotalKey)_\(pageId)_\(playlistId)"
        let cachedGrandTotal = UserDefaults.standard.integer(forKey: totalKey)
        if let data = inMemoryList[key] { return (data, cachedGrandTotal) }
        if let defaultPlayList = try? JSONDecoder().decode([Video].self, from: encodeData) {
            inMemoryList[key] = defaultPlayList
            return (defaultPlayList, cachedGrandTotal)
        }
        return (nil, 0)
    }
    
    func clearDefaultPlaylistCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedDefaultPlaylistKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Private
    private func removeDefaulPlayListCacheForPage(pageId: String) {
        let key = "\(cachedDefaultPlaylistKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func removeVideosOfCustomPlayListCacheForPage(pageId: String, playlistId: String) {
        let key = "\(cachedCustomPlaylistKey)_\(pageId)_\(playlistId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func subcribeLike(_ list: [Video], forPage: String) {
        dataDisposables.forEach { disposable in
            disposable.dispose()
        }
        
        for video in list {
            let disposeable = video.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveDefaultPlaylist(pageId: forPage, videolist: [], grandTotal: nil)
            })
            
            disposeable.disposed(by: bag)
            dataDisposables.append(disposeable)
        }
    }
}
