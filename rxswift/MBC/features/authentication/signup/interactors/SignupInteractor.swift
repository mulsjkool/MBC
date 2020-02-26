//
//  SignupInteractor.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol SignupInteractor {
    func signup(signupInfor: SignupInfor)
    
    var onDidSignupSuccess: Observable<Void> { get }
    
    var onDidSignupError: Observable<Error> { get }
}
