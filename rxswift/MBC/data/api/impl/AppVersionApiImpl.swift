//
//  AppVersionApiImpl.swift
//  MBC
//
//  Created by Dung Nguyen on 3/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class AppVersionApiImpl: BaseApiClient<AppVersionEntity>, AppVersionApi {
    
    private static let getAppVersionPath = "/notifications/apps/version?currentVersion=%@&platform=ios&region=%@"
    
    func getAppVersionWith(version: String, region: String) -> Observable<AppVersionEntity> {
        return apiClient.get(String(format: AppVersionApiImpl.getAppVersionPath, version, region),
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
