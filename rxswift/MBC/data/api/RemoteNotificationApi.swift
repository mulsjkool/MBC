//
//  RemoteNotificationApi.swift
//  MBC
//
//  Created by admin on 3/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol RemoteNotificationApi {
    func registerDeviceToken(deviceToken: String) -> Observable<Void>
    
    func unregisterDeviceToken(deviceToken: String) -> Observable<Void>
}
