//
//  PageDetailApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class PageDetailApiImpl: BaseApiClient<PageDetailEntity>, PageDetailApi {

    private static let getPageDetailByPageIdPath = "/content-presentations/pages/%@"

    func getPageDetailBy(pageId: String) -> Observable<PageDetailEntity> {
        return apiClient.get(String(format: PageDetailApiImpl.getPageDetailByPageIdPath, pageId),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
