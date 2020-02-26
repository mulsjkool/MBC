//
//  LoginViewModel.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import Foundation

class LoginViewModel: BaseViewModel {
    let emailString = Property<String?>("")
    let passwordString = Property<String?>("")

    var signinEnabled: Observable<Bool>!
    
    private var signinByEmailOnDemand = PublishSubject<(email: String, password: String)>()
    private var signinByFacebookOnDemand = PublishSubject<(UIViewController)>()
    
    var onEmailRequired = PublishSubject<Void>()
    var onInvalidEmail = PublishSubject<Void>()
    var onEmailValidated = PublishSubject<Void>()
    
    var onWillStartSignin = PublishSubject<Void>()
    var onWillStopSignin = PublishSubject<Void>()
    
    var onStartHomeAfterSignin: Observable<Void>!
    
    var onShowError = PublishSubject<GigyaCodeEnum>()
    
    private var loginInteractor: LoginInteractor!
    
    init(interactor: LoginInteractor) {
        self.loginInteractor = interactor
        super.init()
        
        setUpRx()
    }
    
    private func validateParams(email: String, password: String) -> Bool {
        if email.isEmpty {
            onEmailRequired.onNext(())
        } else {
            email.isEmail ? onEmailValidated.onNext(()) : onInvalidEmail.onNext(())
        }
        
        let validated = !email.isEmpty && email.isEmail && !password.isEmpty
        return validated
    }
    
    private func setUpRx() {
        signinEnabled = Observable.combineLatest(emailString.asObservable(),
                                                 passwordString.asObservable()) { email, password -> Bool in
            guard let email = email, let password = password else { return false }
            return !email.isEmpty && !password.isEmpty
        }

        onStartHomeAfterSignin = loginInteractor.onDidSigninSuccess
            .do(onNext: { [unowned self] _ in
                if let user = Components.sessionService.currentUser.value {
                    Components.analyticsService.logEvent(trackingObject: AnalyticsUser(user: user,
                                                                                       userActivity: .login))
                    if Components.sessionService.deviceToken != nil {
                        _ = Components.authenticationService.registerRemoteNotification()
                    }
                }
                self.onWillStopSignin.onNext(())
            })
        
        disposeBag.addDisposables([
            signinByEmailOnDemand
                .filter({ [unowned self] _ -> Bool in
                    return self.validateParams(email: self.emailString.value ?? "",
                                               password: self.passwordString.value ?? "")
                })
                .do(onNext: { [unowned self] _ in
                    self.onWillStartSignin.onNext(())
                    self.loginInteractor.signinByEmail(email: self.emailString.value ?? "",
                                                       password: self.passwordString.value ?? "")
                })
                .subscribe(),
            
            signinByFacebookOnDemand
                .do(onNext: { [unowned self] viewController in
                    self.onWillStartSignin.onNext(())
                    self.loginInteractor.signinByFacebook(viewController: viewController)
                })
                .subscribe(),
            
            loginInteractor.onDidSigninError
                .do(onNext: { [unowned self] error in
                    self.onWillStopSignin.onNext(())
                    let nsError = error as NSError
                    self.onShowError.onNext(GigyaCodeEnum(rawValue: nsError.code) ??
                        GigyaCodeEnum.unknownError)
                })
                .subscribe()
        ])
    }
    
    func signinByEmail() {
        signinByEmailOnDemand.onNext((email: self.emailString.value ?? "", password: self.passwordString.value ?? ""))
    }
    
    func signinByFacebook(viewController: UIViewController) {
        signinByFacebookOnDemand.onNext(viewController)
    }
}
