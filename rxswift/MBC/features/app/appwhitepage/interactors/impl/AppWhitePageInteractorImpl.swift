//
//  AppWhitePageInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class AppWhitePageInteractorImpl: AppWhitePageInteractor {
    private let contentPageApi: ContentPageApi
    private let contentPageRepository: ContentPageRepository
	private let socialService = Components.userSocialService
	private let sessionRepository = Components.sessionRepository
    
    init(contentPageApi: ContentPageApi, contentPageRepository: ContentPageRepository) {
        self.contentPageApi = contentPageApi
        self.contentPageRepository = contentPageRepository
    }
    
    func getContentPage(pageUrl: String) -> Observable<(Feed?, PageDetail?, String?)> {
        if let app = contentPageRepository.getCachedApp(pageUrl: pageUrl) {
            let pageDetail = contentPageRepository.getCachedPageDetail(pageUrl: pageUrl)
            return Observable.just((app, pageDetail, nil))
        }
        
        contentPageRepository.clearCacheOf(pageUrl: pageUrl)
        contentPageRepository.clearPageDetailCacheOf(pageUrl: pageUrl)
        
        return contentPageApi.getContentPage(pageUrl: pageUrl)
            .map({ contentPageEntity -> (Feed?, PageDetail?, String?) in
                let pageDetail = (contentPageEntity.pageDetail != nil) ?
                    PageDetail(entity: contentPageEntity.pageDetail!, languageConfigList: []) : nil
                let app = (contentPageEntity.content != nil) ? App(entity: contentPageEntity.content!) : nil
                return (app, pageDetail, contentPageEntity.redirectUrl)
            })
            .do(onNext: { feed, pageDetail, _ in
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
                if let app = feed as? App {
                    self.contentPageRepository.saveApp(pageUrl: pageId, app: app)
                }
            })
    }
	
	func getCommentsFrom(data: CommentSocial) -> Observable<[Comment]> {
		return self.socialService.getComments(data: data)
	}
	
	func getCurrentUser() -> UserProfile? {
		return sessionRepository.currentSession?.user
	}
}
