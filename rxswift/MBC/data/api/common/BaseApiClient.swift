//
//  BaseApiClient.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/12/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseApiClient<T> {
    let apiClient: ApiClient
    let jsonTransformer: (JSON) -> T

    init(apiClient: ApiClient, jsonTransformer: @escaping (JSON) -> T) {
        self.apiClient = apiClient
        self.jsonTransformer = jsonTransformer
    }
}
