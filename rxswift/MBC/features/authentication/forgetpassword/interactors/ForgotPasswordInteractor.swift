//
//  ForgotPasswordInteractor.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol ForgotPasswordInteractor {
    
    func resetPassword(email: String)
    
    var onDidResetPasswordSuccess: Observable<Void> { get }
    var onDidResetPasswordError: Observable<Error> { get }
}
