//
//  AppApiImpl.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class AppApiImpl: BaseApiClient<PageAppEntity>, AppApi {
    
	let transformer: (JSON) -> PageAppEntity
    
	init(apiClient: ApiClient, transformer: @escaping (JSON) -> PageAppEntity) {
		self.transformer = transformer
		super.init(apiClient: apiClient, jsonTransformer: transformer)
	}
	
	private static let listAppInAppTabPath = "/content-presentations/pages/%@/content/app?page=%i&size=%i"
	
	func getListApp(pageId: String, page: Int, pageSize: Int) -> Observable<PageAppEntity> {
		return apiClient.get(String(format: AppApiImpl.listAppInAppTabPath, pageId, page, pageSize),
							 parameters: nil,
							 errorHandler: { _, error -> Error in
								return error
		}, parse: transformer)
	}
}
