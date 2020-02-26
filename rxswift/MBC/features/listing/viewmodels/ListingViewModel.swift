//
//  ListingViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class ListingViewModel: BaseViewModel {
    
    private var interactor: ListingInteractor
    var listingType: ListingType = .showAndProgram
    var filter: ListingFilter?
    
    var onWillStartGetFilterContent = PublishSubject<Void>()
    var onWillStopGetFilterContent = PublishSubject<Void>()
    var onFinishGetListItem = PublishSubject<Void>()
    var onWillStartGetListItem = PublishSubject<Void>()
    var onWillStopGetListItem = PublishSubject<Void>()
    var onDidGetError = PublishSubject<Error>()
    private var startLoadItemsOnDemand = PublishSubject<Void>()
    private let startLoadFilterContentOnDemand = PublishSubject<Void>()
    private let startLoadLanguageConfigOnDemand = PublishSubject<String>()
    
    private(set) var itemsList = [Any]()
    private var isRefreshingData = false
    private var languageConfigService: LanguageConfigService
    private var languageConfigList: [LanguageConfigListEntity] = [LanguageConfigListEntity]()
    
    init(interactor: ListingInteractor, languageConfigService: LanguageConfigService) {
        self.interactor = interactor
        self.languageConfigService = languageConfigService
        super.init()
        setUpRx()
    }
    
    // MARK: Methods
    
    func refreshItemsAndFilterContent() {
        disposeBag = DisposeBag()
        setUpRx()
        interactor.clearCache(listingType: listingType)
        isRefreshingData = true
        if let filter = filter {
            filter.resetData()
        }
        loadFilterContent()
    }
    
    func refreshItems() {
        disposeBag = DisposeBag()
        setUpRx()
        interactor.clearCache(listingType: listingType)
        isRefreshingData = true
        loadItems()
    }
    
    func loadItems() {
        startLoadItemsOnDemand.onNext(())
    }
    
    func startLoadingData() {
        if listingType == .star {
            loadLanguageConfig(name: Constants.ConfigurationDataType.occupations)
        } else {
            loadFilterContent()
        }
    }
    
    func loadFilterContent() {
        startLoadFilterContentOnDemand.onNext(())
    }
    
    private func loadLanguageConfig(name: String) {
        startLoadLanguageConfigOnDemand.onNext(name)
    }
    
    // MARK: Private functions
    
    private func setUpRx() {
        setUpRxForGetItems()
    }
    
    private func setUpRxForGetItems() {
        disposeBag.addDisposables([
            startLoadFilterContentOnDemand
                .do(onNext: { [unowned self] _ in
                    self.onWillStartGetFilterContent.onNext(())
                })
                .flatMap { [unowned self] _ -> Observable<FilterContent> in
                    return self.interactor.getFilterContent(listingType: self.listingType)
                }
                .do(onNext: { [unowned self] filterContent in
                    self.filter = ListingFilter(filterContent: filterContent, listingType: self.listingType)
                })
                .do(onNext: { [unowned self] _ in
                    self.onWillStopGetFilterContent.onNext(())
                    self.loadItems()
                })
                .subscribe(),
            
            startLoadItemsOnDemand
                .do(onNext: { [unowned self] _ in
                    self.onWillStartGetListItem.onNext(())
                })
                .flatMap { [unowned self] _ -> Observable<[Any]> in
                    return self.interactor.getNextItems(filter: self.filter, listingType: self.listingType)
                }
                .do(onNext: { [unowned self] items in
                    if self.isRefreshingData {
                        self.itemsList.removeAll()
                        self.isRefreshingData = false
                    }
                    if self.listingType == .star, let stars = items as? [Star] {
                        self.configLanguageForStarListing(stars: stars,
                                                          type: Constants.ConfigurationDataType.occupations)
                    }
                    self.itemsList.append(contentsOf: items)
                })
                .do(onNext: { [unowned self] _ in
                    self.onWillStopGetListItem.onNext(())
                })
                .subscribe(),
            
            startLoadLanguageConfigOnDemand
                .flatMap { [unowned self] name -> Observable<LanguageConfigListEntity> in
                    return self.languageConfigService.getLanguageConfig(name: name)
                }
                .catchError { _ -> Observable<LanguageConfigListEntity> in
                    self.loadFilterContent()
                    return Observable.empty()
                }
                .do(onNext: { [unowned self] languageConfig in
                    self.languageConfigList.append(languageConfig)
                    self.loadFilterContent()
                })
                .subscribe(),

            interactor.onErrorLoadItems.subscribe(onNext: { [unowned self] error in
                self.onDidGetError.onNext(error)
            }),
            
            interactor.onFinishLoadItems.subscribe(onNext: { [unowned self] _ in
                self.onFinishGetListItem.onNext(())
            })
        ])
    }
    
    private func configLanguageForStarListing(stars: [Star], type: String) {
        for star in stars {
            if let occupations = star.occupations {
                var localizedOccupations = [String]()
                for occupation in occupations {
                    if let localizedString = occupation.getLocalizedString(languageConfigList: languageConfigList,
                                                                            type: type) {
                        localizedOccupations.append(localizedString)
                    } else {
                        localizedOccupations.append(occupation)
                    }
                }
                star.occupations = localizedOccupations
            }
        }
    }
}
