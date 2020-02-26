//
//  ListingInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol ListingInteractor {
    func shouldStartLoadItems()
    func getNextItems(filter: ListingFilter?, listingType: ListingType) -> Observable<[Any]>
    func clearCache(listingType: ListingType)
    
    var onFinishLoadItems: Observable<Void> { get }
    var onErrorLoadItems: Observable<Error> { get }
    
    func getFilterContent(listingType: ListingType) -> Observable<FilterContent>
    
    var onFinishLoadFilterContent: Observable<Void> { get }
    var onErrorLoadFilterContent: Observable<Error> { get }
}
