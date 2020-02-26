//
//  UserProfileInteractorImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class UserProfileInteractorImpl: UserProfileInteractor { 
    private let languageConfigService: LanguageConfigService
    private let userProfileService: UserProfileService
    
    init(languageConfigService: LanguageConfigService, userProfileService: UserProfileService) {
        self.languageConfigService = languageConfigService
        self.userProfileService = userProfileService
    }
    
    // Refresh account info
    
    var onDidGetUserProfileSuccess: Observable<UserProfile?> {
        return self.userProfileService.onGetUserProfileSuccess
    }
    
    var onDidGetUserProfileError: Observable<Error> {
        return self.userProfileService.onGetUserProfileError
    }
    
    // Avatar
    
    var onDidUpdateUserAvatarError: Observable<Error> {
        return self.userProfileService.onUpdateUserAvatarError
    }
    
    var onDidUpdateUserAvatarSuccess: Observable<UserProfile?> {
        return self.userProfileService.onUpdateUserAvatarSuccess
    }
    
    // Nationality
    
    var onDidGetNationalityListSuccess: Observable<Void> {
        return self.languageConfigService.onDidGetNationalityListSuccess
    }
    
    var onDidGetNationalityListError: Observable<Error> {
        return self.languageConfigService.onDidGetNationalityListError
    }
    
    // City
    
    var onDidGetCityListError: Observable<Error> {
        return self.languageConfigService.onDidGetCityListError
    }
    
    var onDidGetCityListSuccess: Observable<Void> {
        return self.languageConfigService.onDidGetCityListSuccess
    }
    
    // Country
    
    var onDidGetCountryListSuccess: Observable<Void> {
        return self.languageConfigService.onDidGetCountryListSuccess
    }
    
    var onDidGetCountryListError: Observable<Error> {
        return self.languageConfigService.onDidGetCountryListError
    }
    
    // Update user profile
    
    var onDidUpdateUserProfileSuccess: Observable<UserProfile?> {
        return self.userProfileService.onUpdateUserProfileSuccess
    }
    
    var onDidUpdateUserProfileError: Observable<Error> {
        return self.userProfileService.onUpdateUserProfileError
    }
    
    //Methods
    
    func getCityList(countryCode: String) -> Observable<[ProfileListBoxItem]> {
        return self.languageConfigService.getCityList(countryCode: countryCode)
    }
    
    func getCountryList() -> Observable<[ProfileListBoxItem]> {
        return self.languageConfigService.getCountryList()
    }
    
    func updateAccountInfo(user: UserProfile?, type: ProfileItemEnum) {
        self.userProfileService.updateUserProfile(user: user, type: type)
    }
    
    func getNationalityList() -> Observable<[ProfileListBoxItem]> {
        return self.languageConfigService.getNationalityList()
    }
    
    func updateUserAvatar(user: UserProfile?, image: UIImage) {
        self.userProfileService.updateUserAvatar(user: user, image: image)
    }
    
    func refreshAccountInfo() {
        self.userProfileService.refreshAccountInfo()
    }
}
