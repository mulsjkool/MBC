//
//  ContentPageApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import SwiftyJSON

class ContentPageApiImpl: BaseApiClient<ContentPageEntity>, ContentPageApi {
    
    let contentPageJsonTransformer: (JSON) -> ContentPageEntity
    let feedJsonTransformer: (JSON) -> FeedEntity
    
    init(apiClient: ApiClient, contentPageJsonTransformer: @escaping (JSON) -> ContentPageEntity,
         feedJsonTransformer: @escaping (JSON) -> FeedEntity) {
        self.contentPageJsonTransformer = contentPageJsonTransformer
        self.feedJsonTransformer = feedJsonTransformer
        super.init(apiClient: apiClient, jsonTransformer: contentPageJsonTransformer)
    }
    
    private static let getContentPage = "/content-presentations/pages"
    
    func getContentPage(pageUrl: String) -> Observable<ContentPageEntity> {
        return apiClient.get(String(format: ContentPageApiImpl.getContentPage, ContentPageApiImpl.getContentPage),
                             parameters: ["url": pageUrl],
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: contentPageJsonTransformer)
    }
    
    private static let getContentPageById = "/content-presentations/%@"
    
    func getContentPageById(pageId: String) -> Observable<FeedEntity> {
        return apiClient.get(String(format: ContentPageApiImpl.getContentPageById, pageId),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: feedJsonTransformer)
    }
    
    private static let getPageDetailById = "/content-presentations/pages/%@"
    
    func getPageDetailById(pageId: String) -> Observable<ContentPageEntity> {
        return apiClient.get(String(format: ContentPageApiImpl.getPageDetailById, pageId),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: contentPageJsonTransformer)
    }
}
