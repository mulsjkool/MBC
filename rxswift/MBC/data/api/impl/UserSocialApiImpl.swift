//
//  UserSocialApiImpl.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class UserSocialApiImpl: BaseApiClient<Void>, UserSocialApi {
    
    private static let likePath = "/social-activities/likes"
    private static let likeFields = (
        data: "data",
        userId: "userId",
        contentId: "contentId",
        contentType: "contentType"
    )
    
    func like(data: UserSocial) -> Observable<String> {
        let fields = UserSocialApiImpl.likeFields
        let data: [String: Any] = [
            fields.userId: data.userId,
            fields.contentId: data.contentId,
            fields.contentType: data.contentType
        ]
        let params: [String: Any] = [
            fields.data: data
        ]
        return apiClient.post(UserSocialApiImpl.likePath,
                              parameters: params,
                              errorHandler: { _, error -> Error in
                                return error
        }, parse: { json -> String in
            return json[fields.contentId].stringValue
        })
    }
    
    private static let unlikePath = "/social-activities/likes/%@/%@/%@"
    
    func unlike(data: UserSocial) -> Observable<Void> {
        return apiClient.delete(String(format: UserSocialApiImpl.unlikePath,
                                       data.contentId, data.userId, data.contentType),
                                parameters: nil,
                                errorHandler: { _, error -> Error in
                                    return error
        }, parse: { _ -> Void in
            return
        })
    }
    
    private static let likeStatusPath = "/content-presentations/statistic"
    
    private static let likeStatusFields = (
        id: "id",
        liked: "liked",
        ids: "ids"
    )
    
    func getLikeStatus(ids: [String]) -> Observable<[(id: String?, liked: Bool?)]> {
        let fields = UserSocialApiImpl.likeStatusFields
        let idsParam = ids.joined(separator: ",")
        let params: [String: Any] = [
            fields.ids: idsParam
        ]
        return apiClient.get(UserSocialApiImpl.likeStatusPath,
                              parameters: params,
                              errorHandler: { _, error -> Error in
                                return error
        }, parse: { json -> [(id: String?, liked: Bool?)] in
            var tempArray = [(id: String?, liked: Bool?)]()
            if let array = json.array {
                
                tempArray = array.map({ dictJson -> (id: String?, liked: Bool?) in
                    return (id: dictJson[fields.id].string, liked: dictJson[fields.liked].bool)
                })
            }
            return tempArray
        })
    }
}
