//
//  ForgotPasswordViewModel.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import Foundation

class ForgotPasswordViewModel: BaseViewModel {
    let emailString = Variable<String>("")
    
    private var resetPasswordOnDemand = PublishSubject<(String)>()
    
    var onInvalidEmail = PublishSubject<Void>()
    
    var onEmailValidated = PublishSubject<Void>()
    
    var onWillStartResetPassword = PublishSubject<Void>()
    var onWillStopResetPassword = PublishSubject<Void>()
    
    var onDidResetPasswordSuccess: Observable<Void>!
    
    var onShowError = PublishSubject<GigyaCodeEnum>()
    
    private var forgotPasswordInteractor: ForgotPasswordInteractor!
    
    init(interactor: ForgotPasswordInteractor) {
        self.forgotPasswordInteractor = interactor
        super.init()
        
        setUpRx()
    }
    
    private func validateParams(email: String) -> Bool {
        email.isEmail ? onEmailValidated.onNext(()) : onInvalidEmail.onNext(())
        
        let validated = !email.isEmpty && email.isEmail
        return validated
    }
    
    private func setUpRx() {
        onDidResetPasswordSuccess = forgotPasswordInteractor.onDidResetPasswordSuccess
            .do(onNext: { [unowned self] _ in
                self.onWillStopResetPassword.onNext(())
            })
        
        disposeBag.addDisposables([
            resetPasswordOnDemand
                .filter({ [unowned self] _ -> Bool in
                    return self.validateParams(email: self.emailString.value)
                })
                .do(onNext: { [unowned self] _ in
                    self.onWillStartResetPassword.onNext(())
                    self.forgotPasswordInteractor.resetPassword(email: self.emailString.value)
                })
                .subscribe(),
            forgotPasswordInteractor.onDidResetPasswordError
                .do(onNext: { [unowned self] error in
                    self.onWillStopResetPassword.onNext(())
                    let nsError = error as NSError
                    self.onShowError.onNext(GigyaCodeEnum(rawValue: nsError.code) ??
                        GigyaCodeEnum.unknownError)
                })
                .subscribe()
        ])
    }
    
    func resetPassword() {
        resetPasswordOnDemand.onNext(self.emailString.value)
    }
}
