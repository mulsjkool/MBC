//
//  ShowListingApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class ShowListingApiImpl: BaseApiClient<[PageDetailEntity]>, ShowListingApi {
    
    private static let getShowListingPath = "/content-presentations/pages/show/list"
    
    func getShowList(params: [String: Any]) -> Observable<[PageDetailEntity]> {
        return apiClient.get(ShowListingApiImpl.getShowListingPath,
                             parameters: params,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
