//
//  StreamApiImpl.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class StreamApiImpl: BaseApiClient<StreamEntity>, StreamApi {
    let streamTransformer: (JSON) -> StreamEntity
    let homeStreamTransformer: (JSON) -> HomeStreamEntity
	let searchResultJsonTransformer: (JSON) -> SearchResultEntity
    private var userId: String = ""
    
    init(apiClient: ApiClient, streamTransformer: @escaping (JSON) -> StreamEntity,
         homeStreamTransformer: @escaping (JSON) -> HomeStreamEntity,
		 searchResultJsonTransformer: @escaping (JSON) -> SearchResultEntity) {
        self.streamTransformer = streamTransformer
        self.homeStreamTransformer = homeStreamTransformer
		self.searchResultJsonTransformer = searchResultJsonTransformer
        
        if let userProfile = Components.sessionService.currentUser.value {
            self.userId = userProfile.uid
        }
        
        super.init(apiClient: apiClient, jsonTransformer: streamTransformer)
    }
    
    private static let streamFields = (
        userId : "userId",
        
        fromIndex : "fromIndex",
        numberOfItems : "numberOfItems",
        isMobile : "isMobile",
        
        timeOffset : "timeOffset"
    )
    
    private static let getPageStreamPath = "/streams/pages/%@"
    
    func loadStreamBy(pageId: String, fromIndex: Int, numberOfItems: Int) -> Observable<StreamEntity> {
        let fields = StreamApiImpl.streamFields
        let params: [String: Any] = [
            fields.userId: self.userId,
            fields.fromIndex: fromIndex,
            fields.numberOfItems: numberOfItems,
            fields.isMobile: "true"
        ]
        return apiClient.get(String(format: StreamApiImpl.getPageStreamPath, pageId),
                             parameters: params,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: streamTransformer)
    }
    
    private static let getHomeStreamPath = "/streams/home"
    
    func loadHomeStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity> {
        let fields = StreamApiImpl.streamFields
        let params: [String: Any] = [
            fields.userId: self.userId,
            fields.timeOffset: timeOffset,
            fields.fromIndex: fromIndex,
            fields.numberOfItems: numberOfItems,
            fields.isMobile: "true"
        ]
        return apiClient.get(StreamApiImpl.getHomeStreamPath,
                             parameters: params,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: homeStreamTransformer)
    }
    
    private static let getVideoStreamPath = "/streams/video"
    
    func loadVideoStreamWith(timeOffset: Int, fromIndex: Int, numberOfItems: Int) -> Observable<HomeStreamEntity> {
        let fields = StreamApiImpl.streamFields
        let params: [String: Any] = [
            fields.userId: self.userId,
            fields.timeOffset: timeOffset,
            fields.fromIndex: fromIndex,
            fields.numberOfItems: numberOfItems,
            fields.isMobile: "true"
        ]
        return apiClient.get(StreamApiImpl.getVideoStreamPath,
                             parameters: params,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: homeStreamTransformer)
    }
	
	private static let searchResultPath = "/search/contents"
	
	func getSearchResult(data: SearchCondition) -> Observable<SearchResultEntity> {
		let parameters = ["term": data.keyword,
						  "type": data.type.rawValue,
						  "fromIndex": data.fromIndex.description,
						  "numberOfItems": data.numberOfItems.description,
						  "hasStatistic": data.hasStatistic.description]
		return apiClient.get(StreamApiImpl.searchResultPath,
							 parameters: parameters,
							 errorHandler: { _, error -> Error in return error },
							 parse: searchResultJsonTransformer)
	}
}
