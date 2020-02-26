//
//  AppApi.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
protocol AppApi {
	func getListApp(pageId: String, page: Int, pageSize: Int) -> Observable<PageAppEntity>
}
