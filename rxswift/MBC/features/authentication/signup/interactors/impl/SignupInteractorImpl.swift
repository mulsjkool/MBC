//
//  SignupInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class SignupInteractorImpl: SignupInteractor {
    var onDidSignupSuccess: Observable<Void> {
        return authenticationService.onDidSignupSuccess
    }
    
    var onDidSignupError: Observable<Error> {
        return authenticationService.onDidSignupError
    }
    
    private let authenticationService: AuthenticationService

    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func signup(signupInfor: SignupInfor) {
        authenticationService.signup(signupInfor: signupInfor)
    }
}
