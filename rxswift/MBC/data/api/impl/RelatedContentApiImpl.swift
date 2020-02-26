//
//  RelatedContentApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import SwiftyJSON

class RelatedContentApiImpl: BaseApiClient<[FeedEntity]>, RelatedContentApi {

    private static let detailOfPlaylist = "/content-presentations/%@/related-contents"

    func getRelatedContents(pageId: String, type: String?, subtype: String?) -> Observable<[FeedEntity]> {
        var url = String(format: RelatedContentApiImpl.detailOfPlaylist, pageId)
        if let type = type, let subtype = subtype {
            url = String(format: "%@?type=%@&subType=%@", url, type, subtype)
        }
        return apiClient.get(url,
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
