//
//  UserProfileViewModel.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class UserProfileViewModel: BaseViewModel {
    private var countryList = [ProfileListBoxItem]()
    private var cityList = [ProfileListBoxItem]()
    private var nationalityList = [ProfileListBoxItem]()
    
    private var getNationalityListOnDemand = PublishSubject<Void>()
    private var getCountryListOnDemand = PublishSubject<Void>()
    private var getCityListOnDemand = PublishSubject<(String)>()
    private var updateAccountInfoOnDemand = PublishSubject<(user: UserProfile?, type: ProfileItemEnum)>()
    private var updateUserAvatarOnDemand = PublishSubject<(user: UserProfile?, image: UIImage)>()
    private var refreshAccountInfoOnDemand = PublishSubject<(UserProfile?)>()
    
    // Nationality
    var onDidGetNationalityList: Observable<Void>!
    var onWillStartGetNationalityList = PublishSubject<Void>()
    var onWillStopGetNationalityList = PublishSubject<Void>()
    
    // Country
    var onDidGetCountryList: Observable<Void>!
    var onWillStartGetCountryList = PublishSubject<Void>()
    var onWillStopGetCountryList = PublishSubject<Void>()

    // City
    var onDidGetCityList: Observable<Void>!
    var onWillStartGetCityList = PublishSubject<Void>()
    var onWillStopGetCityList = PublishSubject<Void>()
    
    // Update user profile
    var onDidUpdateAccountInfo: Observable<UserProfile?>!
    var onWillStartUpdateAccountInfo = PublishSubject<Void>()
    var onWillStopUpdateAccountInfo = PublishSubject<Void>()
    
    // Update user avatar
    var onDidUpdateUserAvatar: Observable<UserProfile?>!
    var onWillStartUpdateUserAvatar = PublishSubject<Void>()
    var onWillStopUpdateUserAvatar = PublishSubject<Void>()
    
    // Refresh account info
    var onDidRefreshAccountInfo: Observable<UserProfile?>!
    var onWillStartRefreshAccountInfo = PublishSubject<Void>()
    var onWillStopRefreshAccountInfo = PublishSubject<Void>()
    
    private var userProfileInteractor: UserProfileInteractor!
    private let sessionService = Components.sessionService
    
    var onShowError = PublishSubject<GigyaCodeEnum>()
    
    var type: ProfileItemEnum!
    
    private var previousUserObject = Components.sessionRepository.currentSession?.user.copy()
    
    init(interactor: UserProfileInteractor) {
        self.userProfileInteractor = interactor
        super.init()
        setUpRx()
    }
    
    private func setUpRx() {
        setupRxForGetNationalityList()
        setupRxForGetCountryList()
        setupRxForGetCityList()
        setupRxForUpdateAccountInfo()
        setupRxForUpdateUserAvatar()
        setupRxForRefreshAccountInfo()
    }
    
    private func setupRxForGetNationalityList() {
        // Detail
        onDidGetNationalityList = getNationalityListOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetNationalityList.onNext(())
            })
            .flatMap({ [unowned self] _ -> Observable<[ProfileListBoxItem]> in
                return self.userProfileInteractor.getNationalityList()
                    .catchError({ error -> Observable<[ProfileListBoxItem]> in
                        self.onWillStopGetNationalityList.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    })
            })
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetNationalityList.onNext(())
            })
            .do(onNext: { [unowned self] list in
                self.nationalityList = list
            })
            .map { _ in Void() }
    }
    
    private func setupRxForGetCountryList() {
        // Detail
        onDidGetCountryList = getCountryListOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetCountryList.onNext(())
            })
            .flatMap({ [unowned self] _ -> Observable<[ProfileListBoxItem]> in
                return self.userProfileInteractor.getCountryList()
                    .catchError({ error -> Observable<[ProfileListBoxItem]> in
                        self.onWillStopGetCountryList.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    })
            })
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetCountryList.onNext(())
            })
            .do(onNext: { [unowned self] list in
                self.countryList = list
            })
            .map { _ in Void() }
    }
    
    private func setupRxForGetCityList() {
        // Detail
        onDidGetCityList = getCityListOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetCityList.onNext(())
            })
            .flatMap({ [unowned self] countryCode -> Observable<[ProfileListBoxItem]> in
                return self.userProfileInteractor.getCityList(countryCode: countryCode)
                    .catchError({ error -> Observable<[ProfileListBoxItem]> in
                        self.onWillStopGetCityList.onNext(())
                        self.showError(error: error)
                        return Observable.empty()
                    })
            })
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetCityList.onNext(())
            })
            .do(onNext: { [unowned self] list in
                self.cityList = list
            })
            .map { _ in Void() }
    }
    
    private func setupRxForUpdateAccountInfo() {
        onDidUpdateAccountInfo = userProfileInteractor.onDidUpdateUserProfileSuccess
            .do(onNext: { [unowned self] user in
                self.onWillStopUpdateAccountInfo.onNext(())
                self.updateSessionService(user: user!)
            })
        
        disposeBag.addDisposables([
            updateAccountInfoOnDemand
                .do(onNext: { [unowned self] valueTuple in
                    self.onWillStartUpdateAccountInfo.onNext(())
                    self.userProfileInteractor.updateAccountInfo(user: valueTuple.user, type: valueTuple.type)
                })
                .subscribe(),
      
            userProfileInteractor.onDidUpdateUserProfileError
                .do(onNext: { [unowned self] error in
                    self.onWillStopUpdateAccountInfo.onNext(())
                    self.onShowError(error: error as NSError)
                })
                .subscribe()
        ])
    }
    
    private func setupRxForUpdateUserAvatar() {
        onDidUpdateUserAvatar = userProfileInteractor.onDidUpdateUserAvatarSuccess
            .do(onNext: { [unowned self] user in
                self.onWillStopUpdateUserAvatar.onNext(())
                self.updateSessionService(user: user!)
            })
        
        disposeBag.addDisposables([
            updateUserAvatarOnDemand
                .do(onNext: { [unowned self] valueTuple in
                    self.onWillStartUpdateUserAvatar.onNext(())
                    self.userProfileInteractor.updateUserAvatar(user: valueTuple.user, image: valueTuple.image)
                })
                .subscribe(),
            
            userProfileInteractor.onDidUpdateUserAvatarError
                .do(onNext: { [unowned self] error in
                    self.onWillStopUpdateUserAvatar.onNext(())
                    self.onShowError(error: error as NSError)
                })
                .subscribe()
        ])
    }
    
    private func setupRxForRefreshAccountInfo() {
        onDidRefreshAccountInfo = userProfileInteractor.onDidGetUserProfileSuccess
            .do(onNext: { [unowned self] user in
                self.onWillStopRefreshAccountInfo.onNext(())
                self.updateSessionService(user: user!)
            })
        
        disposeBag.addDisposables([
            refreshAccountInfoOnDemand
                .do(onNext: { [unowned self] _ in
                    self.onWillStartRefreshAccountInfo.onNext(())
                    self.userProfileInteractor.refreshAccountInfo()
                })
                .subscribe(),
            
            userProfileInteractor.onDidGetUserProfileError
                .do(onNext: { [unowned self] error in
                    self.onWillStopRefreshAccountInfo.onNext(())
                    let error = error as NSError
                    self.onShowError.onNext(GigyaCodeEnum(rawValue: error.code) ?? GigyaCodeEnum.unknownError)
                })
                .subscribe()
        ])
    }
    
    private func updateSessionService(user: UserProfile) {
        let session = Session(user: user, loginByFacebook: self.sessionService.isLoginByFacebook())
        self.sessionService.updateSession(session: session)
        self.previousUserObject = Components.sessionRepository.currentSession?.user.copy()
    }
    
    private func onShowError(error: NSError) {
        if let obj = self.previousUserObject {
            let session = Session(user: obj, loginByFacebook: self.sessionService.isLoginByFacebook())
            self.sessionService.updateSession(session: session)
            self.previousUserObject = Components.sessionRepository.currentSession?.user.copy()
        }
        self.onShowError.onNext(GigyaCodeEnum(rawValue: error.code) ?? GigyaCodeEnum.unknownError)
    }
    
    // MARK: Public Properties
    
    var totalProfileItems: Int {
        return ProfileItemEnum.allItems.count
    }
    
    var user: UserProfile? {
        return Components.sessionRepository.currentSession?.user
    }
    
    var arrayCountry: [ProfileListBoxItem] { return self.countryList }
    var arrayCity: [ProfileListBoxItem] { return self.cityList }
    var arrayNationality: [ProfileListBoxItem] { return self.nationalityList }
    
    // MARK: Public methods
    
    func removeArrayCityList() {
        self.cityList = [ProfileListBoxItem]()
    }
    
    func profileItemAt(index: Int) -> Any? {
        guard index < totalProfileItems else { return nil }
        return ProfileItemEnum.allItems[index]
    }
    
    func editStatusDisable() {
        for item in ProfileItemEnum.allItems {
            if let obj = item as? ProfileItem {
                obj.isEditting = false
            } else if let obj = item as? ProfileGenderItem {
                obj.isEditting = false
            } else if let obj = item as? ProfilePasswordItem {
                obj.isEditting = false
            } else if let obj = item as? ProfileAddressItem {
                obj.isEditting = false
            }
        }
    }
    
    func getNationalityList() {
        getNationalityListOnDemand.onNext(())
    }
    
    func getCountryList() {
        getCountryListOnDemand.onNext(())
    }
    
    func getCityList(countryCode: String) {
        getCityListOnDemand.onNext((countryCode))
    }
    
    func updateAccountInfo(type: ProfileItemEnum) {
        self.type = type
        self.updateAccountInfoOnDemand.onNext((user: self.user, type: type))
    }
    
    func updateUserAvatar(image: UIImage) {
        self.updateUserAvatarOnDemand.onNext((user: self.user, image: image))
    }
    
    func refreshAccountInfo() {
        self.refreshAccountInfoOnDemand.onNext((self.user))
    }
}
