//
//  AuthenticationServiceImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit
import SwiftyJSON

class AuthenticationServiceImpl: AuthenticationService {
    
    private let forceToSignoutSubject = PublishSubject<Void>()
    var onForceToSignout: Observable<Void> {
        return forceToSignoutSubject.asObserver()
            .do(onNext: { [unowned self] _ in
                Gigya.logout()
                self.sessionService.clear()
                self.facebookConnectionService.logOut()
            })
    }
    
    private var regToken: String?
    private var lastUpdatedRegToken: Date?
    
    ////////////////////////
    var onDidResendEmailSuccess: Observable<Void> {
        return didResendEmailSuccessSubject.asObserver()
    }
    
    var onDidResendEmailError: Observable<Error> {
        return didResendEmailErrorSubject.asObserver()
    }
    
    ////////////////////////
    var onDidSignupSuccess: Observable<Void> {
        return didSignupSuccessSubject.asObserver()
    }
    
    var onDidSignupError: Observable<Error> {
        return didSignupErrorSubject.asObserver()
    }
    
    ////////////////////////
    var onDidSigninSuccess: Observable<Void> {
        return didSigninSuccessSubject.asObserver()
    }
    
    var onDidSigninError: Observable<Error> {
        return didSigninErrorSubject.asObserver()
    }
    
    ////////////////////////
    var onDidResetPasswordSuccess: Observable<Void> {
        return didResetPasswordSuccessSubject.asObserver()
    }
    
    var onDidResetPasswordError: Observable<Error> {
        return didResetPasswordErrorSubject.asObserver()
    }
    
    ////////////////////////
    var onDidSignoutSuccess: Observable<Void> {
        return didSignoutSuccessSubject.asObserver()
            .do(onNext: { _ in
                if let user = self.sessionService.currentUser.value {
                    let trackingObject = AnalyticsUser(user: user, userActivity: .logout)
                    Components.analyticsService.logEvent(trackingObject: trackingObject)
                }
            })
            .do(onNext: { [unowned self] _ in
                self.sessionService.clear()
                self.facebookConnectionService.logOut()
            })
    }
    
    var onDidSignoutError: Observable<Error> {
        return didSignoutErrorSubject.asObserver()
    }
    
    ////////////////////////
    var onDidGetAccountInfoError: Observable<Error> {
        return didGetAccountInfoErrorSubject.asObserver()
    }
    
    var onDidGetAccountInfoSuccess: Observable<UserProfile?> {
        return didGetAccountInfoSuccessSubject.asObserver()
    }
    
    private let didSignupSuccessSubject = PublishSubject<Void>()
    private let didSignupErrorSubject = PublishSubject<Error>()
    
    private let didSigninSuccessSubject = PublishSubject<Void>()
    private let didSigninErrorSubject = PublishSubject<Error>()
    
    private let didSignoutSuccessSubject = PublishSubject<Void>()
    private let didSignoutErrorSubject = PublishSubject<Error>()
    
    private let didResendEmailSuccessSubject = PublishSubject<Void>()
    private let didResendEmailErrorSubject = PublishSubject<Error>()
    
    private let didGetAccountInfoSuccessSubject = PublishSubject<UserProfile?>()
    private let didGetAccountInfoErrorSubject = PublishSubject<Error>()
    
    private let didResetPasswordSuccessSubject = PublishSubject<Void>()
    private let didResetPasswordErrorSubject = PublishSubject<Error>()
    
    private let startSigninginOnDemand =
        PublishSubject<(uid: String, uidSignature: String, signatureTimestamp: String)>()
    private let startGetAccountInfoOnDemand = PublishSubject<Void>()
    private let startGetRegionCodeOnDemand = PublishSubject<(String)>()
    
    private var loginByFacebook: Bool = false
    private let sessionService = Components.sessionService
    private let facebookConnectionService = Components.facebookConnectionService
    
    private let signinApi: SigninApi!
    private let userProfileApi: UserProfileApi!
    private let remoteNotificationApi: RemoteNotificationApi!
    
    init(signinApi: SigninApi, userProfileApi: UserProfileApi, remoteNotificationApi: RemoteNotificationApi) {
        self.signinApi = signinApi
        self.userProfileApi = userProfileApi
        self.remoteNotificationApi = remoteNotificationApi
        setUpRx()
    }
    
    let disposeBag = DisposeBag()
    
    private func setUpRx() {
        startSigninginOnDemand
            .flatMap { [unowned self] valueTuple -> Observable<SigninEntity> in
                return self.signinApi.signin(uid: valueTuple.uid, uidSignature: valueTuple.uidSignature,
                                             signatureTimestamp: valueTuple.signatureTimestamp)
                    .catchError { _ -> Observable<SigninEntity> in
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        self.didSigninErrorSubject.onNext(nsError)
                        Gigya.logout()
                        return Observable.empty()
                    }
            }
            .do(onNext: { sEntity in
                let session = Session(accessToken: sEntity.value)
                self.sessionService.updateSession(session: session)
                self.getAccountInfo()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        startGetAccountInfoOnDemand
            .flatMap { [unowned self] _ -> Observable<UserProfileEntity> in
                return self.userProfileApi.getAccountInfo()
                    .catchError { _ -> Observable<UserProfileEntity> in
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        self.didGetAccountInfoErrorSubject.onNext(nsError)
                        self.didSigninErrorSubject.onNext(nsError)
                        
                        // remove local session when after login MBC and log out Gigya
                        self.sessionService.clear()
                        Gigya.logout()
                        
                        return Observable.empty()
                    }
            }
            .do(onNext: { entity in
                self.updateAccountDataLocal(user: entity)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        startGetRegionCodeOnDemand
            .flatMap { [unowned self] countryCode -> Observable<String?> in
                return self.signinApi.getRegionCodeFrom(countryCode: countryCode)
                    .catchError { _ -> Observable<String?> in
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        print(nsError)
                        return Observable.empty()
                    }
            }
            .do(onNext: { regionCode in
                if let session = self.sessionService.currentSession() {
                    session.regionCode = regionCode
                    self.sessionService.updateSession(session: session)
                }
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func refreshToken() -> Observable<Void> {
        forceToSignoutSubject.onNext(())
        
        return Observable.error(ApiError.authenticationFailure(description: "Can't refresh token"))
    }
    
    // MARK: - Sign up
    
    func signup(signupInfor: SignupInfor) {
        initRegistration(signupInfor: signupInfor)
    }
    
    private static let responseFields = (
        statusCode: "statusCode",
        errorCode: "errorCode",
        validationErrors : "validationErrors",
        
        uid : "UID",
        uidSignature : "UIDSignature",
        signatureTimestamp : "signatureTimestamp"
    )
    
    private static let initRegistrationPath = "accounts.initRegistration"
    
    private func initRegistration(signupInfor: SignupInfor) {
        guard let request = GSRequest(forMethod: AuthenticationServiceImpl.initRegistrationPath)
            else { return }

        request.send { response, error in
            if let error = error {
                print(error)
                self.didSignupErrorSubject.onNext(error)
            } else {
                guard let response = response, let regToken = response.object(forKey: "regToken") as? String else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                    self.didSignupErrorSubject.onNext(nsError)
                    return
                }
                self.regToken = regToken
                self.lastUpdatedRegToken = Date()
                let params = self.getSignupParams(signupInfor: signupInfor, regToken: regToken)
                self.signup(params: params)
            }
        }
    }
    
    private static let signupPath = "accounts.register"
    
    private func signup(params: [AnyHashable: Any]) {
        guard let request = GSRequest(forMethod: AuthenticationServiceImpl.signupPath, parameters: params)
            else { return }

        request.send { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")

            guard let response = response else {
                if let error = error as NSError? {
                    self.didSignupErrorSubject.onNext(error)
                }
                return
            }

            guard let validationErrors =
                response[AuthenticationServiceImpl.responseFields.validationErrors] as? NSArray else {
                    if let error = error as NSError? {
                        if let gisyaCode = GigyaCodeEnum(rawValue: error.code),
                            gisyaCode == GigyaCodeEnum.accountPendingVerification {

                            if let trackingObject = AnalyticsUser(response: response, userActivity: .register) {
                                Components.analyticsService.logEvent(trackingObject: trackingObject)
                            }
                        }
                        self.didSignupErrorSubject.onNext(error)
                    }
                    return
            }
            
            if let dict = validationErrors.object(at: 0) as? NSDictionary {
                guard let errorCode = dict[AuthenticationServiceImpl.responseFields.errorCode] as? Int else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                    self.didSignupErrorSubject.onNext(nsError)
                    return
                }
                let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                      code: errorCode, userInfo: nil)
                self.didSignupErrorSubject.onNext(nsError)
            }
        }
    }
    
    private static let signupFields = (
        subscribe: "subscribe",
        terms: "terms",
        name: "name",
        birthDay: "birthDay",
        birthMonth: "birthMonth",
        birthYear: "birthYear",
        gender: "gender",
        email: "email",
        password: "password",
        regToken: "regToken",
        finalizeRegistration: "finalizeRegistration",
        profile: "profile",
        data: "data",
        httpStatusCodes: "httpStatusCodes"
    )

    private func getSignupParams(signupInfor: SignupInfor, regToken: String) -> [AnyHashable: Any] {
        let fields = AuthenticationServiceImpl.signupFields
        
        let data: [AnyHashable: Any] = [
            fields.subscribe: signupInfor.subcribe,
            fields.terms: true
        ]
        
        let genderStr = signupInfor.gender.genderCode()
        var profile: [AnyHashable: Any] = [
            fields.name: signupInfor.name,
            fields.gender: genderStr
        ]

        if let dateOfBirth = signupInfor.dateOfBirth {
            profile[fields.birthDay] = dateOfBirth.day
            profile[fields.birthMonth] = dateOfBirth.month
            profile[fields.birthYear] = dateOfBirth.year
        }
        
        let params: [AnyHashable: Any] = [
            fields.email: signupInfor.email,
            fields.password: signupInfor.password,
            fields.regToken: regToken,
            fields.finalizeRegistration: true,
            fields.profile: profile,
            fields.data: data,
            fields.httpStatusCodes: true
        ]
        return params
    }
    
    // MARK: - Resend email
    
    func resendEmail(email: String) {
        if let regToken = regToken, let lastUpdatedRegToken = lastUpdatedRegToken {
            let timeInteval = Date().timeIntervalSince(lastUpdatedRegToken)
            if timeInteval < Constants.DefaultValue.validTimeOfReqTokenInSeconds {
                let params = self.getResendEmailParams(regToken: regToken, email: email)
                self.resendEmail(params: params)
                return
            }
        }
        
        guard let request = GSRequest(forMethod: AuthenticationServiceImpl.initRegistrationPath)
            else { return }
        
        request.send { response, error in
            if let error = error {
                print(error)
                self.didSignupErrorSubject.onNext(error)
            } else {
                guard let response = response, let regToken = response.object(forKey: "regToken") as? String else {
                    return
                }
                let params = self.getResendEmailParams(regToken: regToken, email: email)
                self.resendEmail(params: params)
            }
        }
    }
    
    private static let resendEmailPath = "accounts.resendVerificationCode"
    
    private func resendEmail(params: [AnyHashable: Any]) {
        guard let request = GSRequest(forMethod: AuthenticationServiceImpl.resendEmailPath, parameters: params)
            else { return }
        request.send { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")
            if let error = error as NSError? {
                self.didResendEmailErrorSubject.onNext(error)
            } else {
                guard let response = response,
                    let statusCode = response[AuthenticationServiceImpl.responseFields.statusCode] as? Int,
                    let errorCode = response[AuthenticationServiceImpl.responseFields.errorCode] as? Int else {
                        let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                              code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        self.didResendEmailErrorSubject.onNext(nsError)
                        return
                }
                
                if statusCode == GigyaCodeEnum.successCode.rawValue {
                    self.didResendEmailSuccessSubject.onNext(())
                } else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: errorCode, userInfo: nil)
                    self.didResendEmailErrorSubject.onNext(nsError)
                }
            }
        }
    }
    
    private static let resendEmailFields = (
        regToken: "regToken",
        email: "email",
        httpStatusCodes: "httpStatusCodes"
    )
    
    private func getResendEmailParams(regToken: String, email: String) -> [AnyHashable: Any] {
        let fields = AuthenticationServiceImpl.resendEmailFields
        
        let params: [AnyHashable: Any] = [
            fields.regToken: regToken,
            fields.email: email,
            fields.httpStatusCodes: true
        ]
        print(params)
        return params
    }
    
    // MARK: - Sign in
    
    private static let signinFields = (
        loginID: "loginID",
        password: "password",
        httpStatusCodes: "httpStatusCodes"
    )
    
    private static let signinWithEmailPath = "accounts.login"
    
    func signinWithEmail(email: String, password: String) {
        let fields = AuthenticationServiceImpl.signinFields
        
        let params: [AnyHashable: Any] = [
            fields.loginID: email,
            fields.password: password,
            fields.httpStatusCodes: true
        ]
        
        guard let request = GSRequest(forMethod: AuthenticationServiceImpl.signinWithEmailPath, parameters: params)
            else { return }
        request.send { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")
            if let error = error as NSError? {
                self.didSigninErrorSubject.onNext(error)
            } else {
                self.handleSignInResponse(response: response)
            }
        }
    }
    
    func signinWithFacebook(viewController: UIViewController) {
        Gigya.login(toProvider: "facebook", parameters: nil, over: viewController) { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")
            if let error = error as NSError? {
                self.didSigninErrorSubject.onNext(error)
            } else {
                self.handleSignInResponse(response: response)
            }
        }
    }
    
    private func handleSignInResponse(response: GSResponse?) {
        guard let response = response,
            let statusCode = response[AuthenticationServiceImpl.responseFields.statusCode] as? Int,
            let errorCode = response[AuthenticationServiceImpl.responseFields.errorCode] as? Int else {
                let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                      code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                self.didSigninErrorSubject.onNext(nsError)
                return
        }
        
        if statusCode == GigyaCodeEnum.successCode.rawValue,
            let uid = response[AuthenticationServiceImpl.responseFields.uid] as? String,
            let uidSignature = response[AuthenticationServiceImpl.responseFields.uidSignature] as? String {
            var signatureTimestamp: String = ""
            if let value = response[AuthenticationServiceImpl.responseFields.signatureTimestamp] as? Int64 {
                signatureTimestamp = String(value)
            } else if let value = response[AuthenticationServiceImpl.responseFields.signatureTimestamp] as? String {
                signatureTimestamp = value
            }
            self.loginByFacebook = true
            self.signinMBCAfterSignin(uid: uid, uidSignature: uidSignature,
                                      signatureTimestamp: signatureTimestamp)
        } else {
            let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                  code: errorCode, userInfo: nil)
            self.didSigninErrorSubject.onNext(nsError)
            Gigya.logout()
        }
    }
    
    private func signinMBCAfterSignin(uid: String, uidSignature: String, signatureTimestamp: String) {
        startSigninginOnDemand.onNext((uid, uidSignature, signatureTimestamp))
    }
    
    // MARK: - Forgot password
    
    private static let resetFields = (
        loginID: "loginID",
        httpStatusCodes: "httpStatusCodes"
    )
    
    private static let resetPasswordPath = "accounts.resetPassword"
    
    func resetPassword(email: String) {
        let fields = AuthenticationServiceImpl.signinFields
        
        let params: [AnyHashable: Any] = [
            fields.loginID: email,
            fields.httpStatusCodes: true
        ]
        
        guard let request = GSRequest(forMethod: AuthenticationServiceImpl.resetPasswordPath, parameters: params)
            else { return }
        request.send { response, error in
            print("Repsone:\(String(describing: response))\nError:\(String(describing: error))")
            if let error = error as NSError? {
                self.didResetPasswordErrorSubject.onNext(error)
            } else {
                guard let response = response,
                    let statusCode = response[AuthenticationServiceImpl.responseFields.statusCode] as? Int,
                    let errorCode = response[AuthenticationServiceImpl.responseFields.errorCode] as? Int else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: GigyaCodeEnum.serverError.rawValue, userInfo: nil)
                        self.didResetPasswordErrorSubject.onNext(nsError)
                        return
                }
                if statusCode == GigyaCodeEnum.successCode.rawValue {
                    self.didResetPasswordSuccessSubject.onNext(())
                } else {
                    let nsError = NSError(domain: Constants.DefaultValue.gigyaErrorDomain,
                                          code: errorCode, userInfo: nil)
                    self.didResetPasswordErrorSubject.onNext(nsError)
                }
            }
        }
    }
    
    // MARK: - Sign out

    func signout() {
        Gigya.logout()
        _ = self.unRegisterRemoteNotification()
        self.didSignoutSuccessSubject.onNext(())
    }
    
    func registerRemoteNotification() -> Observable<Void> {
        if let deviceToken = Components.sessionService.deviceToken {
            return self.remoteNotificationApi.registerDeviceToken(deviceToken: deviceToken)
                .map { _ in
                    
                }
                .catchErrorJustReturn(())
        }
        return Observable<Void>.never()
    }
    
    func unRegisterRemoteNotification() -> Observable<Void> {
        if let deviceToken = Components.sessionService.deviceToken {
            return self.remoteNotificationApi.unregisterDeviceToken(deviceToken: deviceToken)
                .map { _ in
                    
                }
                .catchErrorJustReturn(())
        }
        return Observable<Void>.never()
    }
    
    // MARK: - Get account info
    
    func getAccountInfo() {
        self.startGetAccountInfoOnDemand.onNext(())
    }
    
    private func updateAccountDataLocal(user: UserProfileEntity) {
        let session = Session(entity: user, loginByFacebook: self.loginByFacebook)
        self.sessionService.updateSession(session: session)
        
        //Get region code
        self.startGetRegionCodeOnDemand.onNext((self.sessionService.countryCode))
        
        didGetAccountInfoSuccessSubject.onNext((session.user))
        didSigninSuccessSubject.onNext(())
    }
}
