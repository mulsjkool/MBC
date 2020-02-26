//
//  UserSocialApi.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserSocialApi {
    func like(data: UserSocial) -> Observable<String>
    func unlike(data: UserSocial) -> Observable<Void>
    func getLikeStatus(ids: [String]) -> Observable<[(id: String?, liked: Bool?)]>
}
