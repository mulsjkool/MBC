//
//  UserProfileApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/31/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class UserProfileApiImpl: BaseApiClient<UserProfileEntity>, UserProfileApi {
    
    private static let getAccountInfoPath = "/users/me"
    
    func activeGetDataFromGigyaToMBC() -> Observable<UserProfileEntity> {
        return apiClient.put(UserProfileApiImpl.getAccountInfoPath,
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error }, parse: jsonTransformer)
    }
    
    func getAccountInfo() -> Observable<UserProfileEntity> {
        return apiClient.get(UserProfileApiImpl.getAccountInfoPath,
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error }, parse: jsonTransformer)
    }
}
