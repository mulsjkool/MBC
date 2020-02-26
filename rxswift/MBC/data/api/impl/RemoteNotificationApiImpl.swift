//
//  RemoteNotificationApiImpl.swift
//  MBC
//
//  Created by admin on 3/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class RemoteNotificationApiImpl: BaseApiClient<RemoteNotificationEntity>, RemoteNotificationApi {
    
    private static let registerTokenPath = "/notifications/users/ios/%@/%@"
//    private static let unregisterTokenPath = "/notifications/users/{deviceType}/{userId}/{token}"
    
    func registerDeviceToken(deviceToken: String) -> Observable<Void> {
        guard let userId = Components.sessionRepository.currentSession?.user.uid else { return Observable.empty() }
        return apiClient.post(String(format: RemoteNotificationApiImpl.registerTokenPath, userId, deviceToken),
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error
        }, parse: { _ -> Void in return })
    }
    
    func unregisterDeviceToken(deviceToken: String) -> Observable<Void> {
        guard let userId = Components.sessionRepository.currentSession?.user.uid else { return Observable.empty() }
        return apiClient.delete(String(format: RemoteNotificationApiImpl.registerTokenPath, userId, deviceToken),
                             parameters: nil, errorHandler: { _, error -> Error in
                                return error
        }, parse: { _ -> Void in return })
    }
}
