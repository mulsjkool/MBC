//
//  SignupViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/8/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import Foundation

class SignupViewModel: BaseViewModel {
    let name = Variable<String>("")
    let email = Variable<String>("")
    let gender = Variable<Gender>(Gender.female)
    let dateOfBirth = Variable<String>("")
    let password = Variable<String>("")
    let reEnterPassword = Variable<String>("")
    let isPrivacyAccepted = Variable<Bool>(true)
    let subcribe = Variable<Bool>(false)
    
    private var signupOnDemand = PublishSubject<(SignupInfor)>()
    
    var onEmailRequired = PublishSubject<Void>()
    var onPasswordRequired = PublishSubject<Void>()
    var onReEnterPasswordRequired = PublishSubject<Void>()
    
    var onInvalidPassword = PublishSubject<(String)>()
    var onInvalidReEnterPassword = PublishSubject<Void>()
    var onInvalidEmail = PublishSubject<Void>()
    
    var onPrivacyAcceptedRequired = PublishSubject<Void>()
    
    var onEmailValidated = PublishSubject<Void>()
    var onPasswordValidated = PublishSubject<Void>()
    var onReEnterPasswordValidated = PublishSubject<Void>()
    var onPrivacyAcceptedValidated = PublishSubject<Void>()
    
    var onWillStartSignup = PublishSubject<Void>()
    var onWillStopSignup = PublishSubject<Void>()
    var onShowAccountNotActivatedYet = PublishSubject<Void>()
    var onShowError = PublishSubject<GigyaCodeEnum>()
    var onGetFacebookProfile = PublishSubject<FacebookProfile>()
    
    var getFacebookProfileOnDemand = PublishSubject<(fbId: String, fbToken: String)>()
    var onEnableSignupButton: Observable<Bool> {
        return
            Observable.combineLatest(
                name.asObservable(), email.asObservable(), password.asObservable(),
                // swiftlint:disable line_length
                reEnterPassword.asObservable(), isPrivacyAccepted.asObservable()) { _, email, password, reEnterPassword, isPrivacyAccepted in
                let validated = !email.isEmpty && email.isEmail
                && !password.isEmpty  && !reEnterPassword.isEmpty && password.isPassword
                && password == reEnterPassword && isPrivacyAccepted
                return validated
            }
    }
    
    var onShowPasswordValidated: Observable<Bool> {
        return password.asObservable()
            .map({ password in
                return !password.isEmpty && password.isPassword
            })
    }
    
    var onShowReEnterPasswordValidated: Observable<Bool> {
        return
            Observable.combineLatest(password.asObservable(),
                                     reEnterPassword.asObservable()) { password, reEnterPassword in
                let validated = !password.isEmpty && !reEnterPassword.isEmpty
                    && password.isPassword && password == reEnterPassword
                return validated
            }
    }
    
    private var signupInteractor: SignupInteractor!
    private var facebookConnectionService: FacebookConnectionService!

    init(interactor: SignupInteractor, facebookConnectionService: FacebookConnectionService) {
        self.signupInteractor = interactor
        self.facebookConnectionService = facebookConnectionService
        super.init()
        
        setUpRx()
    }
    
    private func validateParams(signupInfor: SignupInfor) -> Bool {
        if signupInfor.email.isEmpty {
            onEmailRequired.onNext(())
        } else {
            signupInfor.email.isEmail ? onEmailValidated.onNext(()) : onInvalidEmail.onNext(())
        }
        
        if signupInfor.password.isEmpty {
            onPasswordRequired.onNext(())
        } else {
            if !signupInfor.password.isPassword {
                onInvalidPassword.onNext((R.string.localizable.errorPasswordFormatIncorrect()))
            } else {
                onPasswordValidated.onNext(())
                
                if signupInfor.reEnterPassword.isEmpty {
                    onReEnterPasswordRequired.onNext(())
                } else {
                    signupInfor.reEnterPassword != signupInfor.password ? onInvalidReEnterPassword.onNext(())
                        : onReEnterPasswordValidated.onNext(())
                }
            }
        }
        
        signupInfor.isPrivacyAccepted ? onPrivacyAcceptedValidated.onNext(()) : onPrivacyAcceptedRequired.onNext(())
        
        let validated = !signupInfor.email.isEmpty && signupInfor.email.isEmail && !signupInfor.password.isEmpty
            && signupInfor.password.isPassword
            && !signupInfor.reEnterPassword.isEmpty
            && signupInfor.password == signupInfor.reEnterPassword && signupInfor.isPrivacyAccepted
        return validated
    }
    
    private func setUpRx() {
        disposeBag.addDisposables([
            signupOnDemand
                .filter({ [unowned self] signupInfor -> Bool in
                    return self.validateParams(signupInfor: signupInfor)
                })
                .do(onNext: { [unowned self] signupInfor in
                    self.onWillStartSignup.onNext(())
                    self.signupInteractor.signup(signupInfor: signupInfor)
                })
                .subscribe(),
            signupInteractor.onDidSignupError
                .do(onNext: { [unowned self] error in
                    self.onWillStopSignup.onNext(())
                    let nsError = error as NSError
                    self.onShowError.onNext(GigyaCodeEnum(rawValue: nsError.code) ??
                        GigyaCodeEnum.unknownError)
                })
                .subscribe()
        ])
    }
    
    func signUp() {
        let date = dateOfBirth.value.isEmpty ? nil :
            Date.dateFromString(string: dateOfBirth.value, format: Constants.DateFormater.BirthDay)
        let signupInfor = SignupInfor(name: name.value, email: email.value, gender: gender.value,
                dateOfBirth: date, password: password.value, reEnterPassword: reEnterPassword.value,
                subcribe: subcribe.value, isPrivacyAccepted: isPrivacyAccepted.value)
        signupOnDemand.onNext(signupInfor)
    }
    
    func loginFacebook(viewController: UIViewController) {
        disposeBag.addDisposables([
            facebookConnectionService.loginToFacebook(viewController: viewController)
                .flatMap { [unowned self] fbId, fbToken -> Observable<FacebookProfile> in
                    return self.facebookConnectionService.getFacebookUserProfile(fbId: fbId, fbToken: fbToken)
                }
                .do(onNext: { [unowned self] facebookProfile in
                    self.onGetFacebookProfile.onNext(facebookProfile)
                })
                .subscribe()
        ])
    }
}
