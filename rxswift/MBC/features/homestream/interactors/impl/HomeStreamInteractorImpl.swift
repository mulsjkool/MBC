//
//  HomeStreamInteractorImpl.swift
//  MBC
//
//  Created by azuniMac on 12/16/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

class HomeStreamInteractorImpl: HomeStreamInteractor {
    private let streamApi: StreamApi
    private let streamRepository: StreamRepository
    private var languageConfigService: LanguageConfigService
    
    // Variables
    private var index = 0
    private var totalLoaded = 0
    private var pageSize = Components.instance.configurations.defaultPageSize
    private var timeZone: Int
    private var isVideoStream: Bool = false
	
	// For Search result
	private var isSearchResult = false
	private var keyword: String = ""
	private var searchType: SearchItemEnum = .all
	private var hasStatistic: Bool = false
    private var searchStatistic: SearchStatistic!
    
    // Subjects
    private var finishLoadItemsInSubject = PublishSubject<Void>()
    private var errorLoadItemsInSubject = PublishSubject<Error>()
    
    init(streamApi: StreamApi, timeZone: Int, streamRepository: StreamRepository,
         languageConfigService: LanguageConfigService) {
        self.streamApi = streamApi
        self.timeZone = timeZone
        self.streamRepository = streamRepository
        self.languageConfigService = languageConfigService
    }
    
    func setForVideoStream() {
        self.isVideoStream = true
    }
	
	func setForSearchResult(keyword: String, searchType: SearchItemEnum, hasStatistic: Bool) {
		if self.searchType != searchType { shouldStartLoadItems() }
		
		self.isSearchResult = true
		self.keyword = keyword
		self.searchType = searchType
		self.hasStatistic = hasStatistic
	}
    
    public func shouldStartLoadItems() {
        index = 0
        totalLoaded = 0
    }
    
    func clearCache() {
        isVideoStream ? streamRepository.clearVideoCampaignsCache() : streamRepository.clearCampaignsCache()
    }
    
    public func getNextItems() -> Observable<([Campaign], SearchStatistic?)> {
		if isSearchResult {
			return getSearchResult().map { return ($0.items, $0.statistic) }
		}
		
        if isVideoStream { return getNextVideoItems() }
        
        if totalLoaded == 0 {  // first load, try to get from cache
            let data = streamRepository.getCachedCampaigns()
            if let campaigns = data.list {
                self.index = data.index
                self.totalLoaded = data.totalLoaded
                return Observable.just((campaigns, nil))
            }
        }
        
        return streamApi.loadHomeStreamWith(timeOffset: timeZone, fromIndex: index, numberOfItems: pageSize)
            .catchError { error -> Observable<HomeStreamEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .do(onNext: { str in
                let items = str.items
                let total = str.total
                self.totalLoaded += items.count
                self.index += items.count
                if self.totalLoaded >= total || total <= self.pageSize || str.items.isEmpty {
                    self.finishLoadItemsInSubject.onNext(())
                }
            })
            .map { str in
                // filter out not supported types: ads
                let items = self.filterOutNotSupportCampainsFrom(items: str.items)
                return (items.map { Campaign(entity: $0) }, nil)
            }
            .do(onNext: { campaigns, _ in
                self.streamRepository.saveCampaigns(campaigns,
                                                    dataIndex: (index: self.index, totalLoaded: self.totalLoaded))
            })
    }
    
    func getLanguageConfig(name: String) -> Observable<LanguageConfigListEntity> {
        return languageConfigService.getLanguageConfig(name: name)
    }
    
    var onFinishLoadItems: Observable<Void> {
        return finishLoadItemsInSubject.asObservable()
    }
    
    var onErrorLoadItems: Observable<Error> {
        return errorLoadItemsInSubject.asObservable()
    }
    
    // MARK: Private functions
    
    private func getNextVideoItems() -> Observable<([Campaign], SearchStatistic?)> {
        if totalLoaded == 0 {  // first load, try to get from cache
            let data = streamRepository.getCachedVideoCampaigns()
            if let campaigns = data.list {
                self.index = data.index
                self.totalLoaded = data.totalLoaded
                return Observable.just((campaigns, nil))
            }
        }
        
        return streamApi.loadVideoStreamWith(timeOffset: timeZone, fromIndex: index, numberOfItems: pageSize)
            .catchError { error -> Observable<HomeStreamEntity> in
                self.errorLoadItemsInSubject.onNext(error)
                self.finishLoadItemsInSubject.onNext(())
                return Observable.empty()
            }
            .do(onNext: { str in
                let items = str.items
                let total = str.total
                self.totalLoaded += items.count
                self.index += items.count
                if self.totalLoaded >= total || total <= self.pageSize || str.items.isEmpty {
                    self.finishLoadItemsInSubject.onNext(())
                }
            })
            .map { str in
                // filter out, ads
                let items = self.filterOutNotSupportCampainsFrom(items: str.items)
                return (items.map { Campaign(entity: $0) }, nil)
            }
            .do(onNext: { campaigns, _ in
                self.streamRepository.saveVideoCampaigns(campaigns,
                                                    dataIndex: (index: self.index, totalLoaded: self.totalLoaded))
            })
    }
	
	func getSearchResult() -> Observable<SearchResult> {
        let conditionSearchType = (searchType == .all && index > 0) ? .allExcludePage : searchType
		let condition = SearchCondition(keyword: keyword, type: conditionSearchType,
										fromIndex: index, numberOfItems: pageSize, hasStatistic: hasStatistic)
		return streamApi.getSearchResult(data: condition)
			.catchError { error -> Observable<SearchResultEntity> in
				self.errorLoadItemsInSubject.onNext(error)
				self.finishLoadItemsInSubject.onNext(())
				return Observable.empty()
			}
			.map { result in
				var campains: [Campaign] = []
                if self.searchType == .all && self.index == 0 {
                    campains.append(Campaign(fromEntities: result.pages ?? [],
											 title: self.keyword + " " + R.string.localizable.searchResultTitle()))
				}
				if let contents = result.contents { contents.forEach { campains.append(Campaign(searchEntity: $0)) } }
                if self.searchStatistic == nil { self.searchStatistic = SearchStatistic(entity: result.statistic) }
                return SearchResult(items: campains, total: self.searchStatistic.getNumber(type: self.searchType),
                                    statistic: self.searchStatistic)
			}
			.do(onNext: { result in
				let items = result.items
				let total = result.total
				self.totalLoaded += items.count
				self.index += items.count
				if self.totalLoaded >= total || total <= self.pageSize || result.items.isEmpty {
					self.finishLoadItemsInSubject.onNext(())
				}
			})
	}
    
    // TO BE REMOVED
    private func filterOutNotSupportCampainsFrom(items: [CampaignEntity]) -> [CampaignEntity] {
        return items.filter { campaignE in
            if campaignE.items.isEmpty {
                if let type = FeedType(rawValue: campaignE.type) {
                    if type == .article || type == .app || type == .page || type == .bundle
                        || type == .playlist { return true }
                    if type == .post, let sType = campaignE.subType, let subType = FeedSubType(rawValue: sType) {
                        return subType == .text || subType == .image || subType == .embed || subType == .video
                    }
                }
                if let campType = CampaignType(rawValue: campaignE.type), campType == .ads { return true }
				return false
            }
            return !campaignE.items.filter { feedE in
                if let type = FeedType(rawValue: feedE.type) {
                    if type == .article || type == .app || type == .page || type == .bundle ||
                        type == .playlist { return true }
                    if type == .post, let sType = feedE.subType, let subType = FeedSubType(rawValue: sType) {
                        return subType == .text || subType == .image || subType == .embed || subType == .video
                    }
                }
                return false
            }.isEmpty
        }
    }
}
