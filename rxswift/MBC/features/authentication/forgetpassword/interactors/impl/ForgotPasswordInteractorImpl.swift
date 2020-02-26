//
//  ForgotPasswordInteractorImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class ForgotPasswordInteractorImpl: ForgotPasswordInteractor {
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    var onDidResetPasswordError: Observable<Error> {
        return authenticationService.onDidResetPasswordError
    }
    
    var onDidResetPasswordSuccess: Observable<Void> {
        return authenticationService.onDidResetPasswordSuccess
    }
    
    func resetPassword(email: String) {
        authenticationService.resetPassword(email: email)
    }
}
