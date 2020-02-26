//
//  UserProfileServiceImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit
import SwiftyJSON

class UserProfileServiceImpl: UserProfileService {
    var onGetUserProfileSuccess: Observable<UserProfile?> {
        return didGetUserProfileSuccessSubject.asObserver()
    }
    
    var onGetUserProfileError: Observable<Error> {
        return didGetUserProfileErrorSubject.asObserver()
    }

    var onUpdateUserProfileError: Observable<Error> {
        return didUpdateUserProfileErrorSubject.asObserver()
    }
    
    var onUpdateUserProfileSuccess: Observable<UserProfile?> {
        return didUpdateUserProfileSuccessSubject.asObserver()
    }
    
    var onUpdateUserAvatarError: Observable<Error> {
        return didUpdateUserAvatarErrorSubject.asObserver()
    }
    
    var onUpdateUserAvatarSuccess: Observable<UserProfile?> {
        return didUpdateUserAvatarSuccessSubject.asObserver()
    }
    
    private let didGetUserProfileSuccessSubject = PublishSubject<UserProfile?>()
    private let didGetUserProfileErrorSubject = PublishSubject<Error>()
    
    private let didUpdateUserProfileSuccessSubject = PublishSubject<UserProfile?>()
    private let didUpdateUserProfileErrorSubject = PublishSubject<Error>()
    
    private let didUpdateUserAvatarSuccessSubject = PublishSubject<UserProfile?>()
    private let didUpdateUserAvatarErrorSubject = PublishSubject<Error>()
    
    private let startActiveGetDataFromGigyaToMBCOnDemand = PublishSubject<Void>()
    
    private let authenticationService: AuthenticationService!
    private let userProfileApi: UserProfileApi!
    
    private var updateAvatar: Bool = false
    private var getAccountInfo: Bool = false
    
    private static let responseFields = (
        statusCode: "statusCode",
        errorCode: "errorCode"
    )
    
    private let disposeBag = DisposeBag()
    
    init(authenticationService: AuthenticationService, userProfileApi: UserProfileApi) {
        self.authenticationService = authenticationService
        self.userProfileApi = userProfileApi
        setUpRx()
    }
    
    private func setUpRx() {
        startActiveGetDataFromGigyaToMBCOnDemand
            .flatMap { [unowned self] _ -> Observable<UserProfileEntity> in
                return self.userProfileApi.activeGetDataFromGigyaToMBC()
                    .catchError { _ -> Observable<UserProfileEntity> in
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        if self.updateAvatar {
                            self.didUpdateUserAvatarErrorSubject.onNext(nsError)
                        } else {
                            self.didUpdateUserProfileErrorSubject.onNext(nsError)
                        }
                        return Observable.empty()
                    }
            }
            .do(onNext: { _ in
                self.authenticationService.getAccountInfo()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        authenticationService.onDidGetAccountInfoSuccess
            .do(onNext: { user in
                if self.getAccountInfo {
                    self.didGetUserProfileSuccessSubject.onNext(user)
                } else if self.updateAvatar {
                    self.didUpdateUserAvatarSuccessSubject.onNext(user)
                } else {
                    self.didUpdateUserProfileSuccessSubject.onNext(user)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        authenticationService.onDidGetAccountInfoError
            .do(onNext: { error in
                if self.getAccountInfo {
                    self.didGetUserProfileErrorSubject.onNext(error)
                } else if self.updateAvatar {
                    self.didUpdateUserAvatarErrorSubject.onNext(error)
                } else {
                    self.didUpdateUserProfileErrorSubject.onNext(error)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Get account info
    
    func refreshAccountInfo() {
        updateAvatar = false
        getAccountInfo = true
        self.authenticationService.getAccountInfo()
    }
    
    // MARK: - Update avatar
    
    func updateUserAvatar(user: UserProfile?, image: UIImage) {
        updateAvatar = true
        getAccountInfo = false
        guard let userTemp = user else { return }
        let base64String = image.base64(format: .png)
        let params = self.getUpdateAccountAvatarParams(user: userTemp, imageBASE64Encoded: base64String!)
        self.updateUserAvatar(params: params)
    }
    
    private static let updateUserAvatarPath = "accounts.setProfilePhoto"
    
    private func updateUserAvatar(params: [AnyHashable: Any]) {
        guard let request = GSRequest(forMethod: UserProfileServiceImpl.updateUserAvatarPath,
                                      parameters: params) else { return }
        request.send { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")
            if let error = error as NSError? {
                self.didUpdateUserAvatarErrorSubject.onNext(error)
            } else {
                guard let response = response,
                    let statusCode = response[UserProfileServiceImpl.responseFields.statusCode] as? Int,
                    let errorCode = response[UserProfileServiceImpl.responseFields.errorCode] as? Int else {
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        self.didUpdateUserAvatarErrorSubject.onNext(nsError)
                        return
                }
                
                if statusCode == GigyaCodeEnum.successCode.rawValue {
                    self.startActiveGetDataFromGigyaToMBCOnDemand.onNext(())
                } else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: errorCode, userInfo: nil)
                    self.didUpdateUserAvatarErrorSubject.onNext(nsError)
                }
            }
        }
    }
    
    private func getUpdateAccountAvatarParams(user: UserProfile, imageBASE64Encoded: String) -> [AnyHashable: Any] {
        let fields = UserProfileServiceImpl.getUpdateAccountInfoFields
        
        let params: [AnyHashable: Any] = [
            fields.uid: user.uid,
            fields.photoBytes: imageBASE64Encoded,
            fields.publish: "true"
        ]
        
        return params
    }
    // MARK: - Update account info
    
    func updateUserProfile(user: UserProfile?, type: ProfileItemEnum) {
        updateAvatar = false
        getAccountInfo = false
        guard let userTemp = user else { return }
        let params = self.getUpdateAccountInfoParams(user: userTemp, type: type)
        self.updateUserProfile(params: params)
    }
    
    private static let updateUserProfilePath = "accounts.setAccountInfo"
    
    private func updateUserProfile(params: [AnyHashable: Any]) {
        guard let request = GSRequest(forMethod: UserProfileServiceImpl.updateUserProfilePath,
                                      parameters: params) else { return }
        request.send { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")
            if let error = error as NSError? {
                self.didUpdateUserProfileErrorSubject.onNext(error)
            } else {
                guard let response = response,
                    let statusCode = response[UserProfileServiceImpl.responseFields.statusCode] as? Int,
                    let errorCode = response[UserProfileServiceImpl.responseFields.errorCode] as? Int else {
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        self.didUpdateUserProfileErrorSubject.onNext(nsError)
                        return
                }
                
                if statusCode == GigyaCodeEnum.successCode.rawValue {
                    self.startActiveGetDataFromGigyaToMBCOnDemand.onNext(())
                } else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: errorCode, userInfo: nil)
                    self.didUpdateUserProfileErrorSubject.onNext(nsError)
                }
            }
        }
    }
    
    private static let getUpdateAccountInfoFields = (
        uid: "UID",
        httpStatusCodes: "httpStatusCodes",
        
        age : "age",
        birthDay : "birthDay",
        birthMonth : "birthMonth",
        birthYear : "birthYear",
        email : "email",
        gender : "gender",
        name : "name",
        city : "city",
        country : "country",
        photoURL: "photoURL",
        thumbnailURL: "thumbnailURL",
        relationshipStatus: "relationshipStatus",
        
        phones: "phones",
        type: "type",
        number: "number",
        
        address: "address",
        nationality: "nationality",
        
        password: "password",
        newPassword: "newPassword",
        
        profile : "profile",
        data : "data",
        
        photoBytes: "photoBytes",
        publish: "publish"
    )
    
    private func getUpdateAccountInfoParams(user: UserProfile, type: ProfileItemEnum) -> [AnyHashable: Any] {
        let fields = UserProfileServiceImpl.getUpdateAccountInfoFields
        
        var params: [AnyHashable: Any] = [
            fields.uid: user.uid,
            fields.httpStatusCodes: true
        ]
        
        var profile: [AnyHashable: Any] = [AnyHashable: Any]()
        
        let phoneParams: [AnyHashable: Any] = [
            fields.type: "home",
            fields.number: user.phoneNumber
        ]
        
        switch type {
        case .fullName:
            profile[fields.name] = user.name
            params[fields.profile] = profile
        case .email:
            profile[fields.email] = user.email
            params[fields.profile] = profile
        case .gender:
            profile[fields.gender] = user.gender.genderCode()
            params[fields.profile] = profile
        case .password:
            params[fields.password] = user.oldPassword
            params[fields.newPassword] = user.newPassword
        case .marriedStatus:
            profile[fields.relationshipStatus] = user.marriedStatus
            params[fields.profile] = profile
        case .phoneNumber:
            profile[fields.phones] = [phoneParams]
            params[fields.profile] = profile
        case .birthday:
            profile[fields.birthDay] = user.birthday?.day
            profile[fields.birthMonth] = user.birthday?.month
            profile[fields.birthYear] = user.birthday?.year
            params[fields.profile] = profile
        case .nationality:
            profile[fields.nationality] = user.nationality
            params[fields.data] = profile
        case .address:
            profile[fields.address] = user.address
            profile[fields.city] = user.city
            profile[fields.country] = user.country
            params[fields.profile] = profile
        }
        
        return params
    }
}
