//
//  AuthenticationService.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol AuthenticationService {
    func signup(signupInfor: SignupInfor)
    func resendEmail(email: String)
    func signinWithEmail(email: String, password: String)
    func signinWithFacebook(viewController: UIViewController)
    func resetPassword(email: String)
    func signout()
    func registerRemoteNotification() -> Observable<Void>
    func unRegisterRemoteNotification() -> Observable<Void>
    func getAccountInfo()
    func refreshToken() -> Observable<Void>
    
    var onDidGetAccountInfoSuccess: Observable<UserProfile?> { get }
    var onDidGetAccountInfoError: Observable<Error> { get }
    
    var onDidSignupSuccess: Observable<Void> { get }
    var onDidSignupError: Observable<Error> { get }
    
    var onDidResendEmailSuccess: Observable<Void> { get }
    var onDidResendEmailError: Observable<Error> { get }
    
    var onDidSigninSuccess: Observable<Void> { get }
    var onDidSigninError: Observable<Error> { get }
    
    var onDidResetPasswordSuccess: Observable<Void> { get }
    var onDidResetPasswordError: Observable<Error> { get }
    
    var onDidSignoutSuccess: Observable<Void> { get }
    var onDidSignoutError: Observable<Error> { get }
    
    var onForceToSignout: Observable<Void> { get }
}
