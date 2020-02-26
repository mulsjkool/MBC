//
//  TaggedPagesServiceImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class TaggedPagesServiceImpl: TaggedPagesService {
    let taggedPagesApi: TaggedPagesApi
    
    init(taggedApi: TaggedPagesApi) {
        self.taggedPagesApi = taggedApi
    }
    
    func getTaggedPagesFrom(media: Media) -> Observable<Media> {
        return taggedPagesApi.getTaggedPagesFrom(media: media)
            .map { taggedPageEntity -> Media in
                let items = taggedPageEntity.map { MenuPage(entity: $0) }
                media.taggedPages = items
                return media
            }
    }
}
