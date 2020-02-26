//
//  ContentPageInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class ContentPageInteractorImpl: ContentPageInteractor {
    private let contentPageApi: ContentPageApi
    private let contentPageRepository: ContentPageRepository
    private let relatedContentApi: RelatedContentApi
    
    private let socialService = Components.userSocialService
    private let sessionRepository = Components.sessionRepository
    
    init(contentPageApi: ContentPageApi, contentPageRepository: ContentPageRepository,
         relatedContentApi: RelatedContentApi) {
        self.contentPageApi = contentPageApi
        self.contentPageRepository = contentPageRepository
        self.relatedContentApi = relatedContentApi
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func getContentPage(pageUrl: String, contentPageType: ContentPageType)
        -> Observable<(Feed?, PageDetail?, String?)> {
        switch contentPageType {
        case .postText, .postImage, .postVideo, .postEmbed:
            if let post = contentPageRepository.getCachedPost(pageUrl: pageUrl) {
                let pageDetail = contentPageRepository.getCachedPageDetail(pageUrl: pageUrl)
                return Observable.just((post, pageDetail, nil))
            }
        case .article:
            if let article = contentPageRepository.getCachedArticle(pageUrl: pageUrl) {
                let pageDetail = contentPageRepository.getCachedPageDetail(pageUrl: pageUrl)
                return Observable.just((article, pageDetail, nil))
            }
        case .app:
            if let app = contentPageRepository.getCachedApp(pageUrl: pageUrl) {
                let pageDetail = contentPageRepository.getCachedPageDetail(pageUrl: pageUrl)
                return Observable.just((app, pageDetail, nil))
            }
        default:
            break // TODO: PLEASE IMPLEMENT ME
        }
        
        contentPageRepository.clearCacheOf(pageUrl: pageUrl)
        contentPageRepository.clearPageDetailCacheOf(pageUrl: pageUrl)
        contentPageRepository.clearRelatedContentCache(pageUrl: pageUrl)
        
        return contentPageApi.getContentPage(pageUrl: pageUrl)
            .map({ contentPageEntity -> (Feed?, PageDetail?, String?) in
                let pageDetail = (contentPageEntity.pageDetail != nil) ?
                    PageDetail(entity: contentPageEntity.pageDetail!, languageConfigList: []) : nil
                let feed = Common.fetchFeed(entity: contentPageEntity.content)
                return (feed, pageDetail, contentPageEntity.redirectUrl)
            })
            .do(onNext: { feed, pageDetail, _ in
                if let post = feed as? Post {
                    self.contentPageRepository.savePost(pageUrl: pageUrl, post: post)
                }
                if let article = feed as? Article {
                    self.contentPageRepository.saveArticle(pageUrl: pageUrl, article: article)
                }
                if let app = feed as? App {
                    self.contentPageRepository.saveApp(pageUrl: pageUrl, app: app)
                }
                if let pageDetail = pageDetail {
                    self.contentPageRepository.savePageDetail(pageUrl: pageUrl, pageDetail: pageDetail)
                }
            })
    }
    
    func getContentPage(pageId: String) -> Observable<Feed?> {
        return contentPageApi.getContentPageById(pageId: pageId)
            .map({ feedEntity -> Feed? in
                return Common.fetchFeed(entity: feedEntity)
            })
            .do(onNext: { feed in
                if let post = feed as? Post {
                    self.contentPageRepository.savePost(pageUrl: pageId, post: post)
                }
                if let article = feed as? Article {
                    self.contentPageRepository.saveArticle(pageUrl: pageId, article: article)
                }
                if let app = feed as? App {
                    self.contentPageRepository.saveApp(pageUrl: pageId, app: app)
                }
            })
    }
    
    func getTaggedPagesFor(media: Media) -> Observable<Media> {
        return Components.taggedPagesService.getTaggedPagesFrom(media: media)
    }
    
    func getCommentsFrom(data: CommentSocial) -> Observable<[Comment]> {
        return self.socialService.getComments(data: data)
    }
    
    func getCurrentUser() -> UserProfile? {
        return sessionRepository.currentSession?.user
    }
    
    func getRelatedContent(pageUrl: String, pageId: String, type: String?, subtype: String?) -> Observable<[Feed]?> {
        if let relatedContents = contentPageRepository.getCachedRelatedContents(pageUrl: pageUrl) {
            return Observable.just(relatedContents)
        }

        contentPageRepository.clearRelatedContentCache(pageUrl: pageUrl)
        return relatedContentApi.getRelatedContents(pageId: pageId, type: type, subtype: subtype)
            .map({ feedEntities -> [Feed]? in
                let relatedContents = feedEntities.map({ feedEntity -> Feed in
                    return Common.fetchFeed(entity: feedEntity) ?? Feed(entity: feedEntity)
                })
                
                return relatedContents
            })
            .do(onNext: { relatedContents in
                if let relatedContents = relatedContents {
                    self.contentPageRepository.saveRelatedContents(pageUrl: pageUrl, feeds: relatedContents)
                }
            })
    }
}
