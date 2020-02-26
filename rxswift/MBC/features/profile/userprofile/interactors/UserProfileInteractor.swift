//
//  UserProfileInteractor.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserProfileInteractor {
    func getCountryList() -> Observable<[ProfileListBoxItem]>
    func getNationalityList() -> Observable<[ProfileListBoxItem]>
    func getCityList(countryCode: String) -> Observable<[ProfileListBoxItem]>
    func updateAccountInfo(user: UserProfile?, type: ProfileItemEnum)
    func updateUserAvatar(user: UserProfile?, image: UIImage)
    func refreshAccountInfo()
    
    var onDidGetNationalityListError: Observable<Error> { get }
    var onDidGetNationalityListSuccess: Observable<Void> { get }
    
    var onDidGetCountryListError: Observable<Error> { get }
    var onDidGetCountryListSuccess: Observable<Void> { get }
    
    var onDidGetCityListError: Observable<Error> { get }
    var onDidGetCityListSuccess: Observable<Void> { get }
    
    var onDidUpdateUserProfileError: Observable<Error> { get }
    var onDidUpdateUserProfileSuccess: Observable<UserProfile?> { get }
    
    var onDidUpdateUserAvatarError: Observable<Error> { get }
    var onDidUpdateUserAvatarSuccess: Observable<UserProfile?> { get }
    
    var onDidGetUserProfileSuccess: Observable<UserProfile?> { get }
    var onDidGetUserProfileError: Observable<Error> { get }
}
