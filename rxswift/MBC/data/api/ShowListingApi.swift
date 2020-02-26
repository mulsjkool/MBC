//
//  ShowListingApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol ShowListingApi {
    func getShowList(params: [String: Any]) -> Observable<[PageDetailEntity]>
}
