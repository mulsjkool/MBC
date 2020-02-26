//
//  LanguageConfigService.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/28/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol LanguageConfigService {
    func getLanguageConfigs(pageDetailEntity: PageDetailEntity) -> Observable<PageDetail>
    func getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity>
    func getCountryList() -> Observable<[ProfileListBoxItem]>
    func getCityList(countryCode: String) -> Observable<[ProfileListBoxItem]>
    func getNationalityList() -> Observable<[ProfileListBoxItem]>
    func clearCache()
    
    var onDidGetCountryListSuccess: Observable<Void> { get }
    var onDidGetCountryListError: Observable<Error> { get }
    
    var onDidGetCityListSuccess: Observable<Void> { get }
    var onDidGetCityListError: Observable<Error> { get }
    
    var onDidGetNationalityListSuccess: Observable<Void> { get }
    var onDidGetNationalityListError: Observable<Error> { get }
}
