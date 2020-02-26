//
//  ListingInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class ListingInteractorImpl: ListingInteractor {

    private var appListingApi: AppListingApi!
    private var filterContentApi: FilterContentApi!
    private var appTabRepository: AppTabRepository!
    private var starPageListingApi: StarPageListingApi!
    private var starPageListingRepository: StarPageListingRepository!
    private var showListingApi: ShowListingApi!
    private var showListingRepository: ShowListingRepository!
    
    // Variables
    private var inStreamIndex = 0
    private var remainingindex = 0
    private var finishLoadInStream = false
    private var finishLoadRemaining = false
    private var pageSize = Components.instance.configurations.defaultPageSize
    
    private var errorLoadItemsInSubject = PublishSubject<Error>()
    private var finishLoadFilterContentInSubject = PublishSubject<Void>()
    private var errorLoadFilterContentInSubject = PublishSubject<Error>()
    private var finishLoadItemsInSubject = PublishSubject<Void>()
    
    init(appListingApi: AppListingApi, appTabRepository: AppTabRepository, filterContentApi: FilterContentApi,
         starPageListingApi: StarPageListingApi, starPageListingRepository: StarPageListingRepository,
         showListingApi: ShowListingApi, showListingRepository: ShowListingRepository) {
        self.appListingApi = appListingApi
        self.appTabRepository = appTabRepository
        self.filterContentApi = filterContentApi
        self.starPageListingApi = starPageListingApi
        self.starPageListingRepository = starPageListingRepository
        self.showListingApi = showListingApi
        self.showListingRepository = showListingRepository
    }
    
    var onErrorLoadItems: Observable<Error> {
        return errorLoadItemsInSubject.asObservable()
    }
    
    var onFinishLoadItems: Observable<Void> {
        return finishLoadItemsInSubject.asObservable()
    }
    
    func getNextItems(filter: ListingFilter?, listingType: ListingType) -> Observable<[Any]> {
        let params = paramsForListingApi(filter: filter)
        switch listingType {
        case .appAndGame:
            return getAppList(params: params)
        case .star:
            return getStarList(params: params)
        case .showAndProgram:
            return getShowList(params: params)
        }
    }
    
    private static let listingApiParams = (
        inCampaign: "inCampaign",
        fromIndex: "fromIndex",
        size: "size"
    )
    
    private func paramsForListingApi(filter: ListingFilter?) -> [String: Any] {
        var params = [String: Any]()
        if let filter = filter, let filterParams = filter.paramsForListingApi() {
            params = filterParams
        }
        let fields = ListingInteractorImpl.listingApiParams
        if finishLoadInStream {
            params[fields.inCampaign] = "false"
            params[fields.fromIndex] = remainingindex
        } else {
            params[fields.inCampaign] = "true"
            params[fields.fromIndex] = inStreamIndex
        }
        params[fields.size] = pageSize
        return params
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getCachedData(listingType: ListingType) -> [Any]? {
        if inStreamIndex == 0 && !finishLoadInStream {
            switch listingType {
            case .appAndGame:
                if let listApp = appTabRepository.getInStreamApps() {
                    inStreamIndex += listApp.count
                    return listApp
                }
            case .star:
                if let listStar = starPageListingRepository.getInCampaignList() {
                    inStreamIndex += listStar.count
                    return listStar
                }
            case .showAndProgram:
                if let listShow = showListingRepository.getInCampaignList() {
                    inStreamIndex += listShow.count
                    return listShow
                }
            }
        } else if remainingindex == 0 && !finishLoadRemaining {
            switch listingType {
            case .appAndGame:
                if let listApp = appTabRepository.getRemainingApps() {
                    remainingindex += listApp.count
                    return listApp
                }
            case .star:
                if let listStar = starPageListingRepository.getRemainingList() {
                    remainingindex += listStar.count
                    return listStar
                }
            case .showAndProgram:
                if let listShow = showListingRepository.getRemainingList() {
                    remainingindex += listShow.count
                    return listShow
                }
            }
        }
        return nil
    }
    
    private func getAppList(params: [String: Any]) -> Observable<[Any]> {
        return appListingApi.getListApp(params: params)
            .catchError { error -> Observable<[FeedEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                return Observable.empty()
            }
            .map { apps in
                return apps.map({ App(entity: $0) })
            }
            .do(onNext: { [unowned self] items in
                guard let apps = items as? [App] else { return }
                if !self.finishLoadInStream {
                    self.inStreamIndex += apps.count
                    if apps.count < self.pageSize {
                        self.finishLoadInStream = true
                    }
                } else {
                    self.remainingindex += apps.count
                    if apps.count < self.pageSize {
                        self.finishLoadRemaining = true
                        self.finishLoadItemsInSubject.onNext(())
                    }
                }
            })
    }
    
    private func getStarList(params: [String: Any]) -> Observable<[Any]> {
        return starPageListingApi.getStarPageList(params: params)
            .catchError { error -> Observable<[PageDetailEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                return Observable.empty()
            }
            .map { items in
                return items.map({ Star(entity: $0) })
            }
            .do(onNext: { [unowned self] items in
                guard let stars = items as? [Star] else { return }
                if !self.finishLoadInStream {
                    self.inStreamIndex += stars.count
                    if stars.count < self.pageSize {
                        self.finishLoadInStream = true
                    }
                } else {
                    self.remainingindex += stars.count
                    if stars.count < self.pageSize {
                        self.finishLoadRemaining = true
                        self.finishLoadItemsInSubject.onNext(())
                    }
                }
            })
    }
    
    private func getShowList(params: [String: Any]) -> Observable<[Any]> {
        return showListingApi.getShowList(params: params)
            .catchError { error -> Observable<[PageDetailEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                return Observable.empty()
            }
            .map { items in
                return items.map({ Show(entity: $0) })
            }
            .do(onNext: { [unowned self] items in
                guard let shows = items as? [Show] else { return }
                if !self.finishLoadInStream {
                    self.inStreamIndex += shows.count
                    if shows.count < self.pageSize {
                        self.finishLoadInStream = true
                    }
                } else {
                    self.remainingindex += shows.count
                    if shows.count < self.pageSize {
                        self.finishLoadRemaining = true
                        self.finishLoadItemsInSubject.onNext(())
                    }
                }
            })
    }
    
    func shouldStartLoadItems() {
        inStreamIndex = 0
        remainingindex = 0
        finishLoadInStream = false
        finishLoadRemaining = false
    }
    
    func clearCache(listingType: ListingType) {
        switch listingType {
        case .appAndGame:
            appTabRepository.clearCachedInStreamApps()
            appTabRepository.clearCachedRemainingApps()
        case .star:
            starPageListingRepository.clearCachedInCampaignList()
            starPageListingRepository.clearCachedRemainingList()
        case .showAndProgram:
            showListingRepository.clearCachedRemainingList()
            showListingRepository.clearCachedInCampaignList()
        }
        shouldStartLoadItems()
    }
    
    func getFilterContent(listingType: ListingType) -> Observable<FilterContent> {
        switch listingType {
        case .appAndGame:
            return filterContentApi.getFilterContent(type: FeedType.app.contentTypeForFilterContentApi())
                .catchError { error -> Observable<FilterContentEntity> in
                    self.errorLoadFilterContentInSubject.onNext(error)
                    return Observable.empty()
                }
                .map { filterContent in
                    var filterAuthors = [FilterAuthor]()
                    if let filterAuthorEntities = filterContent.filterAuthors {
                        filterAuthors = filterAuthorEntities.map({ return FilterAuthor(entity: $0) })
                    }
                    var filterSubtypes = [FilterSubType]()
                    if let filterSubtypeEntities = filterContent.filterSubTypes {
                        filterSubtypes = filterSubtypeEntities.map({ return FilterSubType(entity: $0) })
                    }
                    return FilterContent(filterAuthors: filterAuthors, filterSubTypes: filterSubtypes)
                }
        case .star:
            return filterContentApi.getStarFilterContent()
                .catchError { error -> Observable<FilterContentEntity> in
                    self.errorLoadFilterContentInSubject.onNext(error)
                    return Observable.empty()
                }
                .map { filterContent in
                    var filterOccupations = [FilterOccupation]()
                    if let filterOccupationEntities = filterContent.filterOccupations {
                        filterOccupations = filterOccupationEntities.map({ return FilterOccupation(entity: $0) })
                    }
                    var filterMonthOfBirths = [FilterMonthOfBirth]()
                    if let filterMonthOfBirthEntities = filterContent.filterMonthOfBirths {
                        filterMonthOfBirths = filterMonthOfBirthEntities.map({ return FilterMonthOfBirth(entity: $0) })
                    }
                    
                    return FilterContent(filterOccupations: filterOccupations, filterMonthOfBirths: filterMonthOfBirths)
                }
        case .showAndProgram:
            return filterContentApi.getShowFilterContent()
                .catchError { error -> Observable<FilterContentEntity> in
                    self.errorLoadFilterContentInSubject.onNext(error)
                    return Observable.empty()
                }
                .map { filterContent in
                    var filterGenres = [FilterGenre]()
                    if let filterGenresEntities = filterContent.filterGenres {
                        filterGenres = filterGenresEntities.map({ return FilterGenre(entity: $0) })
                    }
                    var filterShowSubtypes = [FilterShowSubType]()
                    if let filterShowSubtypesEntities = filterContent.filterShowSubTypes {
                        filterShowSubtypes = filterShowSubtypesEntities.map({ return FilterShowSubType(entity: $0) })
                    }
                    
                    return FilterContent(filterGenres: filterGenres, filterShowSubtypes: filterShowSubtypes)
                }
        }
    }
    
    var onFinishLoadFilterContent: Observable<Void> {
        return finishLoadFilterContentInSubject.asObserver()
    }
    
    var onErrorLoadFilterContent: Observable<Error> {
        return errorLoadFilterContentInSubject.asObserver()
    }
}
