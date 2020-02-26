//
//  EmailVerificationInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol EmailVerificationInteractor {
    func resendEmail(email: String)
    
    var onDidResendEmailSuccess: Observable<Void> { get }
    var onDidResendEmailError: Observable<Error> { get }
}
