//
//  SigninApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class SigninApiImpl: BaseApiClient<SigninEntity>, SigninApi {
    
    public static let signinPath = "/users/token"
    
    private static let signinFields = (
        uid : "uid",
        uidSignature : "uidSignature",
        signatureTimestamp : "signatureTimestamp"
    )
    
    func signin(uid: String, uidSignature: String, signatureTimestamp: String) -> Observable<SigninEntity> {
        let fields = SigninApiImpl.signinFields
        let params: [String: Any] = [
            fields.uid: uid,
            fields.uidSignature: uidSignature,
            fields.signatureTimestamp: signatureTimestamp
        ]
        return apiClient.post(SigninApiImpl.signinPath,
                              parameters: params, errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
    
    public static let regionCodePath = "/configs/list/regions/%@"
    
    func getRegionCodeFrom(countryCode: String) -> Observable<String?> {
        return apiClient.get(String(format: SigninApiImpl.regionCodePath, countryCode),
                              parameters: nil,
                              errorHandler: { _, error -> Error in
                                return error
        }, parse: { json -> String? in
            var listRegion: [String]? = nil
            if let listRegionJson = json.array {
                listRegion = listRegionJson.map({ jsonValue in
                    return jsonValue.stringValue
                })
            }
            //- When region list from API is empty, return nil.
            //- When region list from API has 1 item, we check item's length, when the length = 3, return value
            //other conditions return nil.
            //- When region list from API has more items, we will get item at index 0 and check item's length,
            //when the length = 3, return value, other conditions return nil.
            guard let list = listRegion, !list.isEmpty else { return nil }
            if list.count >= 1 {
                let value = list[0]
                if value.length == 3 { return value }
            }
            return nil
        })
    }
}
