//
//  LoginInteractor.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol LoginInteractor {
    
    func signinByEmail(email: String, password: String)
    func signinByFacebook(viewController: UIViewController)
    
    var onDidSigninSuccess: Observable<Void> { get }
    var onDidSigninError: Observable<Error> { get }
}
