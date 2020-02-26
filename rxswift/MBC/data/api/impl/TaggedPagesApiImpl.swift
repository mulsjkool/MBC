//
//  TaggedPagesApiImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class TaggedPagesApiImpl: BaseApiClient<[PageEntity]>, TaggedPagesApi {
    
    private static let getTaggedPagesFromImageUUID = "/content-presentations/%@/tagged-pages"
    
    func getTaggedPagesFrom(media: Media) -> Observable<[PageEntity]> {
        var id = media.uuid
        if media is Video {
            id = media.id
        }
        return apiClient.get(String(format: TaggedPagesApiImpl.getTaggedPagesFromImageUUID, id),
                             parameters: nil, errorHandler: { _, error -> Error in
            return error
            
        }, parse: jsonTransformer)
    }
}
