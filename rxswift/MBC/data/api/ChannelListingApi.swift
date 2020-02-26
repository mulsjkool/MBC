//
//  ChannelListingApi.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol ChannelListingApi {
    func getListChannel(fromIndex: Int, size: Int) -> Observable<[PageDetailEntity]>
}
