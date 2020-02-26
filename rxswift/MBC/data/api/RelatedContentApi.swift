//
//  RelatedContentApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol RelatedContentApi {
    func getRelatedContents(pageId: String, type: String?, subtype: String?) -> Observable<[FeedEntity]>
}
