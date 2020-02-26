//
//  SigninApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol SigninApi {
    func signin(uid: String, uidSignature: String, signatureTimestamp: String) -> Observable<SigninEntity>
    func getRegionCodeFrom(countryCode: String) -> Observable<String?>
}
