//
//  EpisodeRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class EpisodeRepositoryImpl: EpisodeRepository {
    
    private let dataKey = "key.user_defaults.data"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedEpisodeListKey = "key.user_defaults.cachedEpisodeList"
    private let cachedEpisodeGrandTotalKey = "key.user_defaults.cachedEpisodeList_grandTotal"
    
    private var expireTime: Int = 0
    
    private var inMemoryList: [String: [Post]] = [String: [Post]]()
    private let bag = DisposeBag()
    private var dataDisposables = [Disposable]()
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveEpisodeListFor(pageId: String, list: [Post], grandTotal: Int?) {
        var newArray = [Post]()
        if let existingList = getEpisodeListFor(pageId: pageId).list {
            newArray = existingList
        }
        newArray.append(contentsOf: list)
        
        let key = "\(cachedEpisodeListKey)_\(pageId)"
        
        inMemoryList[key] = newArray
        subcribeLike(newArray, forPage: pageId)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newArray) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            
            if let total = grandTotal {
                let totalKey = "\(cachedEpisodeGrandTotalKey)_\(pageId)"
                UserDefaults.standard.set(total, forKey: totalKey)
            }
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func getEpisodeListFor(pageId: String) -> (list: [Post]?, grandTotal: Int) {
        let key = "\(cachedEpisodeListKey)_\(pageId)"
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
        
        let totalKey = "\(cachedEpisodeGrandTotalKey)_\(pageId)"
        let cachedGrandTotal = UserDefaults.standard.integer(forKey: totalKey)
        
        if let data = inMemoryList[key] { return (list: data, grandTotal: cachedGrandTotal) }
        
        if let list = try? JSONDecoder().decode([Post].self, from: encodedData) {
            inMemoryList[key] = list
            
            return (list: list, grandTotal: cachedGrandTotal)
        }
        
        return (nil, 0)
    }
    
    func clearCachedEpisodeListFor(pageId: String) {
        
    }
    
    private func removeListCacheForPage(pageId: String) {
        let key = "\(cachedEpisodeListKey)_\(pageId)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func subcribeLike(_ list: [Post], forPage: String) {
        dataDisposables.forEach { disposable in
            disposable.dispose()
        }
        
        for post in list {
            let disposeable = post.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveEpisodeListFor(pageId: forPage, list: [], grandTotal: nil)
            })
            
            disposeable.disposed(by: bag)
            dataDisposables.append(disposeable)
        }
    }
}
