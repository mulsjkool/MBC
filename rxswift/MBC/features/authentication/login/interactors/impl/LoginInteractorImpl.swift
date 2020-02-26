//
//  LoginInteractorImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class LoginInteractorImpl: LoginInteractor {
    private let authenticationService: AuthenticationService
    
    private let didSigninSuccessSubject = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    var onDidSigninSuccess: Observable<Void> {
        return authenticationService.onDidSigninSuccess
            .do(onNext: { _ in
                if Components.sessionService.deviceToken != nil {
                    _ = Components.authenticationService.registerRemoteNotification()
                }
            })
    }
    
    var onDidSigninError: Observable<Error> {
        return authenticationService.onDidSigninError
    }
    
    func signinByEmail(email: String, password: String) {
        authenticationService.signinWithEmail(email: email, password: password)
    }
    
    func signinByFacebook(viewController: UIViewController) {
        authenticationService.signinWithFacebook(viewController: viewController)
    }
}
