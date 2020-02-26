//
//  ChannelListingInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol ChannelListingInteractor {
    func shouldStartLoadItems()
    func getNextItems() -> Observable<[PageDetail]>
    func clearCache()
    
    var onFinishLoadChannelList: Observable<Void> { get }
    var onErrorLoadItems: Observable<Error> { get }
}
