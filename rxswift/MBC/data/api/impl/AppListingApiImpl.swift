//
//  AppListingApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class AppListingApiImpl: BaseApiClient<[FeedEntity]>, AppListingApi {
    
    private static let getAppListingPath = "/content-presentations/content-listing"

    func getListApp(params: [String: Any]) -> Observable<[FeedEntity]> {
        var newParams = params
        newParams["contentType"] = "app"
        return apiClient.get(AppListingApiImpl.getAppListingPath,
                             parameters: newParams,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
