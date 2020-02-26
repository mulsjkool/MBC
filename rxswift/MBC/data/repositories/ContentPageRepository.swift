//
//  ContentPageRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

protocol ContentPageRepository {
    func saveArticle(pageUrl: String, article: Article)
    func getCachedArticle(pageUrl: String) -> Article?
    func savePost(pageUrl: String, post: Post)
    func getCachedPost(pageUrl: String) -> Post?
    func saveApp(pageUrl: String, app: App)
    func getCachedApp(pageUrl: String) -> App?
    func clearCacheOf(pageUrl: String)
    func savePageDetail(pageUrl: String, pageDetail: PageDetail)
    func getCachedPageDetail(pageUrl: String) -> PageDetail?
    func clearPageDetailCacheOf(pageUrl: String)
    
    func saveRelatedContents(pageUrl: String, feeds: [Feed])
    func getCachedRelatedContents(pageUrl: String) -> [Feed]?
    func clearRelatedContentCache(pageUrl: String)
    func clearRelatedContentsCache()
}
