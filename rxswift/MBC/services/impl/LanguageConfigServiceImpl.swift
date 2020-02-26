//
//  LanguageConfigServiceImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/28/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

class LanguageConfigServiceImpl: LanguageConfigService {
    
    private let languageConfigApi: LanguageConfigApi
    private let languageConfigRepository: LanguageConfigRepository
    
    private let didGetCountryListSuccessSubject = PublishSubject<Void>()
    private let didGetCountryListErrorSubject = PublishSubject<Error>()
    
    private let didGetCityListSuccessSubject = PublishSubject<Void>()
    private let didGetCityListErrorSubject = PublishSubject<Error>()
    
    private let didGetNationalityListSuccessSubject = PublishSubject<Void>()
    private let didGetNationalityListErrorSubject = PublishSubject<Error>()
    
    // Nationality
    
    var onDidGetNationalityListSuccess: Observable<Void> {
        return didGetNationalityListSuccessSubject.asObserver()
    }
    
    var onDidGetNationalityListError: Observable<Error> {
        return didGetNationalityListErrorSubject.asObserver()
    }
    
    // City
    
    var onDidGetCityListSuccess: Observable<Void> {
        return didGetCityListSuccessSubject.asObserver()
    }
    
    var onDidGetCityListError: Observable<Error> {
        return didGetCityListErrorSubject.asObserver()
    }
    
    // Country
    
    var onDidGetCountryListError: Observable<Error> {
        return didGetCountryListErrorSubject.asObserver()
    }
    
    var onDidGetCountryListSuccess: Observable<Void> {
        return didGetCountryListSuccessSubject.asObserver()
    }
    
    //////////////////////////
    
    init(languageConfigApi: LanguageConfigApi, languageConfigRepository: LanguageConfigRepository) {
        self.languageConfigApi = languageConfigApi
        self.languageConfigRepository = languageConfigRepository
    }
    
    func getCityList(countryCode: String) -> Observable<[ProfileListBoxItem]> {
        return languageConfigApi.getCityList(countryCode: countryCode)
            .do(onError: { [unowned self] error in
                self.didGetCityListErrorSubject.onNext(error)
            })
            .map({ [unowned self] languageConfig in
                self.didGetCityListSuccessSubject.onNext(())
                return self.handleMakeListBox(entity: languageConfig)
            })
    }
    
    func getCountryList() -> Observable<[ProfileListBoxItem]> {
        return languageConfigApi.getLanguageConfig(name: Constants.ConfigurationDataType.countries)
            .do(onError: { [unowned self] error in
                self.didGetCountryListErrorSubject.onNext(error)
            })
            .map({ [unowned self] languageConfig in
                self.didGetCountryListSuccessSubject.onNext(())
                return self.handleMakeListBox(entity: languageConfig)
            })
    }
    
    func getNationalityList() -> Observable<[ProfileListBoxItem]> {
        return languageConfigApi.getLanguageConfig(name: Constants.ConfigurationDataType.nationalities)
            .do(onError: { [unowned self] error in
                self.didGetNationalityListErrorSubject.onNext(error)
            })
            .map({ [unowned self] languageConfig in
                self.didGetNationalityListSuccessSubject.onNext(())
                return self.handleMakeListBox(entity: languageConfig)
            })
    }
    
    func getLanguageConfigs(pageDetailEntity: PageDetailEntity) -> Observable<PageDetail> {
        if let pageType = PageType(rawValue: pageDetailEntity.pageInfo.type) {
            switch pageType {
            case .award:
                return getLanguageConfigForAwardType(pageDetailEntity: pageDetailEntity)
            case .business:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.industries),
                    getLanguageConfig(name: Constants.ConfigurationDataType.subIndustries),
                    getLanguageConfig(name: Constants.ConfigurationDataType.countries)) {
                        return (config1: $0, config2: $1, config3: $2)
                }.map { [unowned self] tuple in
                    return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                    languageConfigLists: [tuple.config1, tuple.config2, tuple.config3])
                }
            case .events:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.eventsSubType),
                    getLanguageConfig(name: Constants.ConfigurationDataType.countries)) {
                        return (config1: $0, config2: $1)
                }.map { [unowned self] tuple in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                languageConfigLists: [tuple.config1, tuple.config2])
                }
            case .profile:
                return getLanguageConfigForProfileType(pageDetailEntity: pageDetailEntity)
            case .channel:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.languages),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.regions)) {
                        return (config1: $0, config2: $1, config3: $2)
                }.map { [unowned self] tuple in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                    languageConfigLists: [tuple.config1, tuple.config2, tuple.config3])
                }
            case .show:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.countries),
                    getLanguageConfig(name: Constants.ConfigurationDataType.dialects),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(type: Constants.ConfigurationDataType.subgenres),
                    getLanguageConfig(type: Constants.ConfigurationDataType.occupations)) {
                        return (config1: $0, config2: $1, config3: $2, config4: $3, config5: $4)
                }.map { [unowned self] tuple in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                      languageConfigLists: [tuple.config1,
                                                                                            tuple.config2,
                                                                                            tuple.config3,
                                                                                            tuple.config4,
                                                                                            tuple.config5])
                }
            default:
                return Observable.just(handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                         languageConfigLists: []))
            }
        }
        return Observable.just(handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                 languageConfigLists: []))
    }
    
    private func handleMakeListBox(entity: LanguageConfigListEntity) -> [ProfileListBoxItem] {
        var arrayData = [ProfileListBoxItem]()
        
        for objType in entity.dataList {
            let code: String = objType.code
            var nameEn = ""
            var nameAr = ""
            for objName in objType.names {
                if objName.locate == "en" {
                    nameEn = objName.text
                } else if objName.locate == "ar" {
                    nameAr = objName.text
                }
            }
            let obj = ProfileListBoxItem(titleENLabel: nameEn, titleARLabel: nameAr, value: code)
            arrayData.append(obj)
        }
        return arrayData
    }
    
    private func handleLanguageConfigForPageDetail(pageDetailEntity: PageDetailEntity,
                                                   languageConfigLists: [LanguageConfigListEntity]) -> PageDetail {
        return PageDetail(entity: pageDetailEntity, languageConfigList: languageConfigLists)
    }
    
    func getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity> {
        if let languageConfig = languageConfigRepository.getLanguageConfig(type: name) {
            return Observable.just(languageConfig)
        }
        return languageConfigApi.getLanguageConfig(name: name)
            .catchError { _ -> Observable<LanguageConfigListEntity> in
                return Observable.empty()
            }
            .do(onNext: { [unowned self] languageConfig in
                self.languageConfigRepository.saveLanguageConfig(languageConfig: languageConfig)
            })
    }
    
    func getLanguageConfig(type: String) -> Observable<LanguageConfigListEntity> {
        if let languageConfig = languageConfigRepository.getLanguageConfig(type: type) {
            return Observable.just(languageConfig)
        }
        return languageConfigApi.getLanguageConfig(type: type)
            .catchError { _ -> Observable<LanguageConfigListEntity> in
                return Observable.empty()
            }
            .do(onNext: { [unowned self] languageConfig in
                self.languageConfigRepository.saveLanguageConfig(languageConfig: languageConfig)
            })
    }
    
    private func getLanguageConfigForProfileType(pageDetailEntity: PageDetailEntity) -> Observable<PageDetail> {
        if let subtype = pageDetailEntity.pageMetadata.pageSubType,
            let profileSubType = PageProfileSubType(rawValue: subtype) {
            switch profileSubType {
            case .sportPlayer:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations),
                    getLanguageConfig(name: Constants.ConfigurationDataType.skillLevels),
                    getLanguageConfig(name: Constants.ConfigurationDataType.sportTypes),
                    getLanguageConfig(name: Constants.ConfigurationDataType.countries),
                    getLanguageConfig(type: Constants.ConfigurationDataType.subgenres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations)) {
                        return (config1: $0, config2: $1, config3: $2, config4: $3, config5: $4, config6: $5,
                                config7: $6)
                }.map { [unowned self] tuple in
                    return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                           languageConfigLists: [tuple.config1, tuple.config2, tuple.config3, tuple.config4,
                                                 tuple.config5, tuple.config6, tuple.config7])
                }
            case .star, .guest, .talent:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations),
                    getLanguageConfig(name: Constants.ConfigurationDataType.countries),
                    getLanguageConfig(type: Constants.ConfigurationDataType.subgenres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations)) {
                        return (config1: $0, config2: $1, config3: $2, config4: $3, config5: $4)
                }.map { [unowned self] tuple in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                               languageConfigLists: [tuple.config1, tuple.config2, tuple.config3, tuple.config4,
                                                     tuple.config5])
                }
            case .sportTeam:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.awardMusic),
                    getLanguageConfig(name: Constants.ConfigurationDataType.sportTypes),
                    getLanguageConfig(type: Constants.ConfigurationDataType.subgenres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations)) {
                        return (config1: $0, config2: $1, config3: $2, config4: $3, config5: $4)
                }.map { [unowned self] tuple in
                    return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                    languageConfigLists: [tuple.config1, tuple.config2, tuple.config3, tuple.config4,
                                                          tuple.config5])
                }
            case .band:
                return Observable.combineLatest(
                    getLanguageConfig(name: Constants.ConfigurationDataType.musicTypes),
                    getLanguageConfig(type: Constants.ConfigurationDataType.subgenres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations)) {
                        return (config1: $0, config2: $1, config3: $2, config4: $3)
                }.map { [unowned self] tuple in
                    return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
																  languageConfigLists: [tuple.config1, tuple.config2,
																						tuple.config3, tuple.config4])
                }
            default:
                return Observable.combineLatest(
                    getLanguageConfig(type: Constants.ConfigurationDataType.subgenres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.genres),
                    getLanguageConfig(name: Constants.ConfigurationDataType.occupations)) {
                        return (config1: $0, config2: $1, config3: $2)
                }.map { [unowned self] tuple in
                    return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                    languageConfigLists: [tuple.config1, tuple.config2, tuple.config2])
                }
            }
        }
        return Observable.just(handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                 languageConfigLists: []))
    }
    
    private func getLanguageConfigForAwardType(pageDetailEntity: PageDetailEntity) -> Observable<PageDetail> {
        if let subtype = pageDetailEntity.pageMetadata.pageSubType,
            let awardSubType = PageAwardSubType(rawValue: subtype) {
            switch awardSubType {
            case .beautyPageant:
                return getLanguageConfig(name: Constants.ConfigurationDataType.awardBeautyPageant)
                    .map({ [unowned self] languageConfig in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                      languageConfigLists: [languageConfig])
                    })
            case .music:
                return getLanguageConfig(name: Constants.ConfigurationDataType.awardMusic)
                    .map({ [unowned self] languageConfig in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                      languageConfigLists: [languageConfig])
                    })
            case .sport:
                return getLanguageConfig(name: Constants.ConfigurationDataType.awardSport)
                    .map({ [unowned self] languageConfig in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                      languageConfigLists: [languageConfig])
                    })
            case .film:
                return getLanguageConfig(name: Constants.ConfigurationDataType.awardFilm)
                    .map({ [unowned self] languageConfig in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                      languageConfigLists: [languageConfig])
                    })
            case .television:
                return getLanguageConfig(name: Constants.ConfigurationDataType.awardTelevision)
                    .map({ [unowned self] languageConfig in
                        return self.handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                      languageConfigLists: [languageConfig])
                    })
            default:
                return Observable.just(handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                         languageConfigLists: []))
            }
        }
        return Observable.just(handleLanguageConfigForPageDetail(pageDetailEntity: pageDetailEntity,
                                                                 languageConfigLists: []))
    }
    
    func clearCache() {
        languageConfigRepository.clearLanguageConfigCache()
    }
}
