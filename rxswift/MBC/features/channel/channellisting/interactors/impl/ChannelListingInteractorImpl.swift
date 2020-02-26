//
//  ChannelListingInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class ChannelListingInteractorImpl: ChannelListingInteractor {
    private var channelListingApi: ChannelListingApi!
    private var channelRepository: ChannelRepository!
    
    // Variables
    private var index = 0
    private var pageSize = Components.instance.configurations.defaultChannelListPageSize
    private var errorLoadItemsInSubject = PublishSubject<Error>()
    private var finishLoadChannelListInSubject = PublishSubject<Void>()
    
    init(channelListingApi: ChannelListingApi, channelRepository: ChannelRepository) {
        self.channelListingApi = channelListingApi
        self.channelRepository = channelRepository
    }
    
    var onErrorLoadItems: Observable<Error> {
        return errorLoadItemsInSubject.asObservable()
    }
    
    var onFinishLoadChannelList: Observable<Void> {
        return finishLoadChannelListInSubject.asObservable()
    }
    
    func getNextItems() -> Observable<[PageDetail]> {
        if index == 0 {  // first load, try to get from cache
            if let channelList = channelRepository.getCachedChannelList() {
                index += channelList.count
                return Observable.just(channelList)
            }
        }
        
        return channelListingApi.getListChannel(fromIndex: index, size: pageSize)
            .catchError { error -> Observable<[PageDetailEntity]> in
                self.errorLoadItemsInSubject.onNext(error)
                return Observable.empty()
            }
            .map { pageDetailEntities in
                return pageDetailEntities.map({ PageDetail(entity: $0, languageConfigList: []) })
            }
            .do(onNext: { [unowned self] pages in
                self.index += pages.count
                if pages.count < self.pageSize {
                    self.finishLoadChannelListInSubject.onNext(())
                }
            })
            .do(onNext: { pages in
                if !pages.isEmpty {
                    self.channelRepository.saveChannelList(channelList: pages)
                }
            })
    }
    
    func shouldStartLoadItems() {
        index = 0
    }
    
    func clearCache() {
        channelRepository.clearCachedChannelList()
        shouldStartLoadItems()
    }
}
