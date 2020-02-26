//
//  PageApiImpl.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 11/24/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class PageApiImpl: BaseApiClient<[PageEntity]>, PageApi {

    private static let getFeaturePagesPath = "/content-presentations/sites/%@/feature-pages"

    func getFeaturePagesBy(siteName: String) -> Observable<[PageEntity]> {
        return apiClient.get(String(format: PageApiImpl.getFeaturePagesPath, siteName),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
