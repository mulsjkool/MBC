//
//  InfoComponentApiImpl.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class InfoComponentApiImpl: BaseApiClient<[InfoComponentEntity]>, InfoComponentApi {

    private static let getInfoComponentById = "/content-presentations/pages/%@/info-component"
    
    func getInfoComponentById(pageId: String) -> Observable<[InfoComponentEntity]> {
        return apiClient.get(String(format: InfoComponentApiImpl.getInfoComponentById, pageId),
                             parameters: nil,
                             errorHandler: {_, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
