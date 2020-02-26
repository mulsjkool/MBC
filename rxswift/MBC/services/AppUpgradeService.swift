//
//  AppUpgradeService.swift
//  MBC
//
//  Created by Dung Nguyen on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol AppUpgradeService {
    
    func startGetAppVersion()
    
    var onAppVersionUpgradeSuccess: Observable<AppVersion> { get }
    var onAppVersionUpgradeError: Observable<Error> { get }

}
