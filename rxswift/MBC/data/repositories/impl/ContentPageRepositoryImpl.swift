//
//  ContentPageRepositoryImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class ContentPageRepositoryImpl: ContentPageRepository {
    private let dataKey = "key.user_defaults.data"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    private let cachedKeyContentPage = "key.user_defaults.cachedContentPage"
    private let cachedKeyPageDetailOfContentPage = "key.user_defaults.cachedpageDetailOfContentPage"
    private let cachedRelatedContentKey = "key.user_defaults.cachedRelatedContent"
    private var expireTime: Int = 0
    private var inMemoryData: [String: Feed] = [String: Feed]()
    private var inMemoryRelatedContentData: [String: [Feed]] = [String: [Feed]]()
    private var relatedContentDataDisposables = [Disposable]()
    private let bag = DisposeBag()
    
    init(expireTime: Int) {
        self.expireTime = expireTime
    }
    
    func saveArticle(pageUrl: String, article: Article) {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(article) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedArticle(pageUrl: String) -> Article? {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearCacheOf(pageUrl: pageUrl)
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let data = inMemoryData[key] as? Article { return data }
        
        if let data = try? JSONDecoder().decode(Article.self, from: encodedData) {
            inMemoryData[key] = data
            subcribeLike(feed: data, pageUrl: pageUrl)
            return data
        }
        
        return nil
    }
    
    func savePost(pageUrl: String, post: Post) {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(post) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedPost(pageUrl: String) -> Post? {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearCacheOf(pageUrl: pageUrl)
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let data = inMemoryData[key] as? Post { return data }
        
        if let data = try? JSONDecoder().decode(Post.self, from: encodedData) {
            inMemoryData[key] = data
            subcribeLike(feed: data, pageUrl: pageUrl)
            return data
        }
        
        return nil
    }
    
    func saveApp(pageUrl: String, app: App) {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(app) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedApp(pageUrl: String) -> App? {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearCacheOf(pageUrl: pageUrl)
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let data = inMemoryData[key] as? App { return data }
        
        if let data = try? JSONDecoder().decode(App.self, from: encodedData) {
            inMemoryData[key] = data
            subcribeLike(feed: data, pageUrl: pageUrl)
            return data
        }
        
        return nil
    }
    
    func savePageDetail(pageUrl: String, pageDetail: PageDetail) {
        let key = "\(cachedKeyPageDetailOfContentPage)_\(pageUrl)"
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(pageDetail) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getCachedPageDetail(pageUrl: String) -> PageDetail? {
        let key = "\(cachedKeyPageDetailOfContentPage)_\(pageUrl)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearPageDetailCacheOf(pageUrl: pageUrl)
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        let pageDetail = try? JSONDecoder().decode(PageDetail.self, from: encodedData)
        return pageDetail
    }
    
    func clearCacheOf(pageUrl: String) {
        let key = "\(cachedKeyContentPage)\(pageUrl)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
        inMemoryData.removeValue(forKey: key)
    }
    
    func clearPageDetailCacheOf(pageUrl: String) {
        let key = "\(cachedKeyPageDetailOfContentPage)\(pageUrl)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
        inMemoryData.removeValue(forKey: key)
    }
    
    func saveRelatedContents(pageUrl: String, feeds: [Feed]) {
        let key = "\(cachedRelatedContentKey)_\(pageUrl)"
        inMemoryRelatedContentData[key] = feeds
        subcribeLike(feeds: feeds, forPage: pageUrl)
        
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(feeds.map { CacheHolder(item: $0) }) {
            let dictionary = [dataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            
            UserDefaults.standard.set(dictionary, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    private func subcribeLike(feed: Feed, pageUrl: String) {
        if let article = feed as? Article {
            article.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveArticle(pageUrl: pageUrl, article: article)
            }).disposed(by: bag)
            
            for p in article.paragraphs {
                guard let media = p.media else { return }
                media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.saveArticle(pageUrl: pageUrl, article: article)
                }).disposed(by: bag)
            }
        }
        
        if let post = feed as? Post {
            guard let medias = post.medias else { return }
            for media in medias {
                media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.savePost(pageUrl: pageUrl, post: post)
                }).disposed(by: bag)
            }
        }
        
        if let app = feed as? App {
            guard let media = app.photo else { return }
            media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveApp(pageUrl: pageUrl, app: app)
            }).disposed(by: bag)
        }
    }
    
    private func subcribeLike(feeds: [Feed], forPage: String) {
        relatedContentDataDisposables.forEach { disposable in
            disposable.dispose()
        }
        for item in feeds {
            let disposeable = item.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                self.saveRelatedContents(pageUrl: forPage, feeds: feeds)
            })
            disposeable.disposed(by: bag)
            relatedContentDataDisposables.append(disposeable)
            
            if let p = item as? Post {
                guard let medias = p.medias else { return }
                for media in medias {
                    let disposeable = media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                        self.saveRelatedContents(pageUrl: forPage, feeds: feeds)
                    })
                    disposeable.disposed(by: bag)
                    relatedContentDataDisposables.append(disposeable)
                }
            }
            
            if let article = item as? Article {
                guard let media = article.photo else { return }
                let disposeable = media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.saveRelatedContents(pageUrl: forPage, feeds: feeds)
                })
                disposeable.disposed(by: bag)
                relatedContentDataDisposables.append(disposeable)
                
                for p in article.paragraphs {
                    guard let media = p.media else { return }
                    let disposeable = media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                        self.saveRelatedContents(pageUrl: forPage, feeds: feeds)
                    })
                    disposeable.disposed(by: bag)
                    relatedContentDataDisposables.append(disposeable)
                }
            }
            
            if let app = item as? App {
                guard let media = app.photo else { return }
                let disposeable = media.onToggleLikeSubject.subscribe(onNext: { [unowned self] _ in
                    self.saveRelatedContents(pageUrl: forPage, feeds: feeds)
                })
                disposeable.disposed(by: bag)
                relatedContentDataDisposables.append(disposeable)
            }
        }
    }
    
    func getCachedRelatedContents(pageUrl: String) -> [Feed]? {
        let key = "\(cachedRelatedContentKey)_\(pageUrl)"
        guard let dictionary = UserDefaults.standard.dictionary(forKey: key) else {
            return nil
        }
        
        guard let lastStored = dictionary[lastStoredTimeKey] as? Double else {
            return nil
        }
        let duration = Date().timeIntervalSince1970 - lastStored
        if lastStored == 0 || duration > Double(expireTime) {
            clearRelatedContentCache(pageUrl: pageUrl)
            return nil
        }
        
        guard let encodedData = dictionary[dataKey] as? Data else {
            return nil
        }
        
        if let data = inMemoryRelatedContentData[key] {
            return data
        }
        
        if let decodedList = try? JSONDecoder().decode([CacheHolder].self, from: encodedData) {
            inMemoryRelatedContentData[key] = decodedList.map { ($0.toAnyObject() as? Feed)! }
            return inMemoryRelatedContentData[key]
        }
        
        return nil
    }
    
    func clearRelatedContentCache(pageUrl: String) {
        let key = "\(cachedRelatedContentKey)_\(pageUrl)"
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func clearRelatedContentsCache() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.contains(cachedRelatedContentKey) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
}
