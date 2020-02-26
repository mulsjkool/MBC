//
//  LanguageConfigApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class LanguageConfigApiImpl: BaseApiClient<LanguageConfigListEntity>, LanguageConfigApi {
    
    private static let getLanguageConfigPath = "/configs/lists/%@?langs=en,ar"

    func getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity> {
        return apiClient.get(String(format: LanguageConfigApiImpl.getLanguageConfigPath, name),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
    
    private static let getCitiesOfCountryPath = "/configs/lists/countries/%@/cities?types=cities&langs=en,ar"
    
    func getCityList(countryCode: String) -> Observable<LanguageConfigListEntity> {
        return apiClient.get(String(format: LanguageConfigApiImpl.getCitiesOfCountryPath, countryCode),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
    
    private static let getLanguageConfigByTypePath = "/configs/lists?type=%@&langs=en,ar"
    
    func getLanguageConfig(type: String) -> Observable<LanguageConfigListEntity> {
        return apiClient.get(String(format: LanguageConfigApiImpl.getLanguageConfigByTypePath, type),
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
