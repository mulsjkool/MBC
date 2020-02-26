//
//  StarPageListingApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class StarPageListingApiImpl: BaseApiClient<[PageDetailEntity]>, StarPageListingApi {
    
    private static let getStarPageListingPath = "/content-presentations/pages/profile/list"
    
    func getStarPageList(params: [String: Any]) -> Observable<[PageDetailEntity]> {
        var newParams = params
        newParams["subTypes"] = "star,sportPlayer,talent,guest"
        return apiClient.get(StarPageListingApiImpl.getStarPageListingPath,
                             parameters: newParams,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
