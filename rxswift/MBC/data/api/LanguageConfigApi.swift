//
//  LanguageConfigApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol LanguageConfigApi {
    func getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>
    func getCityList(countryCode: String) -> Observable<LanguageConfigListEntity>
    func getLanguageConfig(type: String) -> Observable<LanguageConfigListEntity>
}
