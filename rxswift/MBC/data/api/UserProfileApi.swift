//
//  UserProfileApi.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/31/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserProfileApi {
    func getAccountInfo() -> Observable<UserProfileEntity>
    func activeGetDataFromGigyaToMBC() -> Observable<UserProfileEntity>
}
