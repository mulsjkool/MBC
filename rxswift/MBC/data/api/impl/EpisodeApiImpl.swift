//
//  EpisodeApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class EpisodeApiImpl: BaseApiClient<[FeedEntity]>, EpisodeApi {
    
    private static let listEpisodePath = "/content-presentations/pages/%@/content/post?subType=episode&page=%i&size=%i"
    
    func getListEpisode(pageId: String, page: Int, pageSize: Int) -> Observable<[FeedEntity]> {
        return apiClient.get(String(format: EpisodeApiImpl.listEpisodePath, pageId, page, pageSize),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
