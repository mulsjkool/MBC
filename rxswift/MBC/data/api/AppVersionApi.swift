//
//  AppVersionApi.swift
//  MBC
//
//  Created by Dung Nguyen on 3/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol AppVersionApi {
    func getAppVersionWith(version: String, region: String) -> Observable<AppVersionEntity>
}
