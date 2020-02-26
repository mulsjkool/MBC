//
//  FilterContentApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class FilterContentApiImpl: BaseApiClient<FilterContentEntity>, FilterContentApi {
    
    private static let getFilterContentPath
        = "/content-presentations/content-listing/filter"
    
    func getFilterContent(type: String) -> Observable<FilterContentEntity> {
        return apiClient.get(String(format: FilterContentApiImpl.getFilterContentPath, type),
                             parameters: ["contentType": type],
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
    
    private static let getStarFilterContentPath
        = "/content-presentations/filtering-options/star"
    
    func getStarFilterContent() -> Observable<FilterContentEntity> {
        return apiClient.get(FilterContentApiImpl.getStarFilterContentPath,
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
    
    private static let getShowFilterContentPath
        = "/content-presentations/filtering-options/show"
    
    func getShowFilterContent() -> Observable<FilterContentEntity> {
        return apiClient.get(FilterContentApiImpl.getShowFilterContentPath,
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
