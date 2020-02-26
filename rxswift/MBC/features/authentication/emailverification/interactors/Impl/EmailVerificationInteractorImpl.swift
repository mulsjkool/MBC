//
//  EmailVerificationInteractorImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class EmailVerificationInteractorImpl: EmailVerificationInteractor {
    var onDidResendEmailSuccess: Observable<Void> {
        return authenticationService.onDidResendEmailSuccess
    }
    
    var onDidResendEmailError: Observable<Error> {
        return authenticationService.onDidResendEmailError
    }
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func resendEmail(email: String) {
        self.authenticationService.resendEmail(email: email)
    }
}
