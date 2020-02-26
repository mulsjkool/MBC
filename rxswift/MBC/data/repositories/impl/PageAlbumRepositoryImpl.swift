//
//  PageAlbumRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/14/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit
import RxSwift

class PageAlbumRepositoryImpl: PageAlbumRepository {
    private let dataKey = "key.user_defaults.defaultAlbumData"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedDefaultAlbumKey = "key.user_defaults.cachedDefaultAlbum"
    private let cachedMediaGrandTotalKey = "key.user_defaults.cachedMedialist_grandTotal"
    private var expireTime: Int = 0
    
    private var inMemoryList: [String: [Media]] = [String: [Media]]()
    private let bag = DisposeBag()
    private var dataDisposables = [Disposable]()
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveDefaultAlbum(pageId: String, mediaList: [Media], grandTotal: Int?) {
        
        var newArray = [Media]()
        if let existingMediaList = getCachedDefaultAlbum(pageId: pageId).0 {
            newArray = existingMediaList
        }
        newArray.append(contentsOf: mediaList)
        
        let key = "\(cachedDefaultAlbumKey)_\(pageId)"
        
        inMemoryList[key] = newArray
        subcribeLike(newArray, forPage: pageId)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let total = grandTotal {
                let totalKey = "\(cachedMediaGrandTotalKey)_\(pageId)"
                UserDefaults.standard.set(total, forKey: totalKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedDefaultAlbum(pageId: String) -> ([Media]?, Int) {
        let key = "\(cachedDefaultAlbumKey)_\(pageId)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return (nil, 0)
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return (nil, 0)
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            removeMediaListCacheForPage(pageId: pageId)
            return (nil, 0)
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return (nil, 0)
        }
        
        let totalKey = "\(cachedMediaGrandTotalKey)_\(pageId)"
        let cachedGrandTotal = UserDefaults.standard.integer(forKey: totalKey)
        if let data = inMemoryList[key] { return (data, cachedGrandTotal) }
        
        if let mediaList = try? JSONDecoder().decode([Media].self, from: encodedData) {
            inMemoryList[key] = mediaList
            return (mediaList, cachedGrandTotal)
        }
        
        return (nil, 0)
    }
    
    func clearDefaultAlbumCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedDefaultAlbumKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
    private func removeMediaListCacheForPage(pageId: String) {
        let key = "\(cachedDefaultAlbumKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func subcribeLike(_ list: [Media], forPage: String) {
        dataDisposables.forEach { disposable in
            disposable.dispose()
        }
        
        for media in list {
            let disposeable = media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveDefaultAlbum(pageId: forPage, mediaList: [], grandTotal: nil)
            })
            
            disposeable.disposed(by: bag)
            dataDisposables.append(disposeable)
        }
    }
    
    func clearDefaultAlbumCache(pageId: String) {
        let key = "\(cachedDefaultAlbumKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}
