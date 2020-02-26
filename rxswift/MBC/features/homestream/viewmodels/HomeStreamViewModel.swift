//
//  HomeStreamViewModel.swift
//  MBC
//
//  Created by azuniMac on 12/16/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class HomeStreamViewModel: BaseViewModel {
    // MARK: variables and properties
    private var interactor: HomeStreamInteractor
    private let socialService: UserSocialService
    private let startLoadItemsOnDemand = PublishSubject<Void>()
    private let startLoadLanguageConfigOnDemand = PublishSubject<String>()
    
    // public
    private(set) var itemsList = [Campaign]()
	private(set) var statistic: SearchStatistic?
    
    // Rx
    var onDidLoadItems: Observable<([Campaign], SearchStatistic?)>! /// finish loading a round
    var onFinishLoadListItem: Observable<Void>! /// finish loading the whole collection
    var onWillStartGetListItem = PublishSubject<Void>()
    var onWillStopGetListItem = PublishSubject<Void>()
	var onDidError = PublishSubject<Void>()
    private var likeStatusDisposeBag = DisposeBag()
    
    private var languageConfigList: [LanguageConfigListEntity] = [LanguageConfigListEntity]()
    
    init(interactor: HomeStreamInteractor, socialService: UserSocialService) {
        self.interactor = interactor
        self.socialService = socialService
        super.init()
        
        setUpRx()
    }
    
    func loadItems() {
        startLoadItemsOnDemand.onNext(())
    }
    
    func refreshItems() {
        likeStatusDisposeBag = DisposeBag()
        itemsList.removeAll()
        interactor.clearCache()
        startLoadItemsOnDemand.onNext(())
    }
    
    func clearCache() {
        interactor.clearCache()
    }
    
    func loadLanguageConfigs() {
        startLoadLanguageConfigOnDemand.onNext(Constants.ConfigurationDataType.occupations)
        startLoadLanguageConfigOnDemand.onNext(Constants.ConfigurationDataType.genres)
    }
    
    func metadataForSearchPage(_ page: Page) -> String? {
        guard let metadata = page.metadata, let pageTypeStr = page.pageType,
            let pageSubTypeStr = page.pageSubType else { return nil }
        
        let pageType = PageType(rawValue: pageTypeStr) ?? PageType.other
        switch pageType {
        case .show:
            return getMetadataForShowType(metadataDict: metadata, subtype: pageSubTypeStr)
        case .profile:
            return getMetadataForProfileType(metadataDict: metadata, subtype: pageSubTypeStr)
        case .channel:
            return getMetadataForChannelType(metadataDict: metadata, subtype: pageSubTypeStr)
        default:
            break
        }

        return nil
    }
    
    private static let metadataFields = (
        genre: "genre",
        id: "id",
        names: "names",
        year: "year",
        season: "season",
        sequenceNumber: "sequenceNumber",
        liveRecord: "liveRecord"
    )
    
    private func getMetadataForShowType(metadataDict: [String: Any?], subtype: String) -> String? {
        let pageSubType = PageSubType(rawValue: subtype) ?? PageSubType.other
        
        var array = [String]()
        let fields = HomeStreamViewModel.metadataFields
        if let genreDict = metadataDict[fields.genre] as? [String: Any?],
            let genreId = genreDict[fields.id] as? String,
            let genreName = genreDict[fields.names] as? String,
            pageSubType == .movie || pageSubType == .series || pageSubType == .program || pageSubType == .play {
            if let localizedString = genreId.getLocalizedString(languageConfigList: languageConfigList,
                                                                   type: Constants.ConfigurationDataType.genres) {
                array.append(localizedString)
            } else {
                array.append(genreName)
            }
        }
        
        if let year = metadataDict[fields.year] as? Int,
            pageSubType == .movie || pageSubType == .series || pageSubType == .program {
            array.append("\(year)")
        }
        
        if let season = metadataDict[fields.season] as? String,
            pageSubType == .series || pageSubType == .program {
            array.append(season)
        }
        
        if let sequenceNumber = metadataDict[fields.sequenceNumber] as? String,
            pageSubType == .movie {
            array.append(sequenceNumber)
        }
        
        if let liveRecordedText = metadataDict[fields.liveRecord] as? String,
            let liveRecorded = LiveRecordType(rawValue: liveRecordedText),
            pageSubType == .news || pageSubType == .match || pageSubType == .play {
            array.append(liveRecorded.getArabicText())
        }
        
        if let sequenceNumber = metadataDict[fields.sequenceNumber] as? String,
            pageSubType == .movie {
            array.append(sequenceNumber)
        }
        
        return array.joined(separator: Constants.DefaultValue.DotSeparatorString)
    }
    
    private func getMetadataForProfileType(metadataDict: [String: Any?], subtype: String) -> String? {
        return nil
//        let pageSubType = PageSubType(rawValue: subtype) ?? PageSubType.other
//
//        var array = [String]()
//        return array.joined(separator: Constants.DefaultValue.DotSeparatorString)
    }
    
    private func getMetadataForChannelType(metadataDict: [String: Any?], subtype: String) -> String? {
        return nil
    }
    
    // MARK: Private functions
    
    private func setUpRx() {
        setUpRxForGetItems()
    }
    
    private func setUpRxForGetItems() {
        onDidLoadItems = startLoadItemsOnDemand
            .do(onNext: { [unowned self] _ in
                if self.itemsList.isEmpty {
                    self.onWillStartGetListItem.onNext(())
                    self.interactor.shouldStartLoadItems()
                }
            })
            .flatMap { [unowned self] _ -> Observable<([Campaign], SearchStatistic?)> in
                return self.interactor.getNextItems()
            }
            .do(onNext: { [unowned self] campaigns, searchStatistic in
                self.itemsList.append(contentsOf: campaigns)
                self.getLikeStatus(campaigns: campaigns)
				if let statistic = searchStatistic { self.statistic = statistic }
            })
            .do(onNext: { [unowned self] _, _ in
                self.onWillStopGetListItem.onNext(())
            })
        disposeBag.addDisposables([
            interactor.onErrorLoadItems.subscribe(onNext: { [unowned self] error in
				self.onDidError.onNext(())
                self.showError(error: error)
            })
        ])
        onFinishLoadListItem = interactor.onFinishLoadItems
        
        startLoadLanguageConfigOnDemand
            .flatMap { [unowned self] name -> Observable<LanguageConfigListEntity> in
                return self.interactor.getLanguageConfig(name: name)
            }
            .catchError { _ -> Observable<LanguageConfigListEntity> in
                return Observable.empty()
            }
            .do(onNext: { [unowned self] languageConfig in
                self.languageConfigList.append(languageConfig)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func getLikeStatus(campaigns: [Campaign]) {
        let ids = campaigns.filter { campaign -> Bool in
            if let item = campaign.items.first, item.contentId != nil { return true }
            return false
        }.map({ $0.items.first!.contentId! })
        guard !ids.isEmpty else { return }
        socialService.getLikeStatus(ids: ids)
            .do(onNext: { [unowned self] array in
                for item in array {
                    guard let id = item.id, let likeStatus = item.liked else {
                        continue
                    }
                    for campaign in self.itemsList {
                        if let likable = campaign.items.first, let contentId = likable.contentId, id == contentId {
                            likable.liked = likeStatus
                            likable.didReceiveLikeStatus.onNext(likable.liked)
                            break
                        }
                    }
                }
            })
            .subscribe()
            .disposed(by: self.likeStatusDisposeBag)
    }
}
