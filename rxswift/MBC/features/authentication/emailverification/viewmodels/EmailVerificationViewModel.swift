//
//  EmailVerificationViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import Foundation

class EmailVerificationViewModel: BaseViewModel {
    let emailString = Variable<String>("")
    
    private var emailVerificationInteractor: EmailVerificationInteractor
    
    var onEmailRequired = PublishSubject<Void>()
    var onInvalidEmail = PublishSubject<Void>()
    var onEmailValidated = PublishSubject<Void>()
    
    var onWillStartResendingEmail = PublishSubject<Void>()
    var onWillStopResendingEmail = PublishSubject<Void>()
    
    var onDidResendEmailSuccess = PublishSubject<Void>()
    
    var onShowError = PublishSubject<GigyaCodeEnum>()
    
    private var resendEmailOnDemand = PublishSubject<String>()
    
    init(interactor: EmailVerificationInteractor, email: String) {
        self.emailVerificationInteractor = interactor
        self.emailString.value = email
        super.init()
        
        setUpRx()
    }
    
    private func validateParams(email: String) -> Bool {
        if email.isEmpty {
            onEmailRequired.onNext(())
        } else {
            email.isEmail ? onEmailValidated.onNext(()) : onInvalidEmail.onNext(())
        }
        return !email.isEmpty && email.isEmail
    }
    
    private func setUpRx() {
        disposeBag.addDisposables([
            resendEmailOnDemand
                .filter({ [unowned self] _ -> Bool in
                    return self.validateParams(email: self.emailString.value)
                })
                .do(onNext: { [unowned self] email in
                    self.onWillStartResendingEmail.onNext(())
                    self.emailVerificationInteractor.resendEmail(email: email)
                })
                .subscribe(),
            emailVerificationInteractor.onDidResendEmailError
                .do(onNext: { [unowned self] error in
                    self.onWillStopResendingEmail.onNext(())
                    let nsError = error as NSError
                    self.onShowError.onNext(GigyaCodeEnum(rawValue: nsError.code) ??
                        GigyaCodeEnum.unknownError)
                })
                .subscribe(),
            emailVerificationInteractor.onDidResendEmailSuccess
                .do(onNext: { [unowned self] in
                    self.onWillStopResendingEmail.onNext(())
                    self.onDidResendEmailSuccess.onNext(())
                })
                .subscribe()
        ])
    }
    
    func resendEmail() {
        resendEmailOnDemand.onNext(emailString.value)
    }
}
