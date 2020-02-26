//
//  FormInteractorImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class FormInteractorImpl: FormInteractor {
    private let formApi: FormApi
    
    init(formApi: FormApi) {
        self.formApi = formApi
    }
    
    var onDidSendFormError: Observable<Error> {
        return self.sendFormErrorInSubject.asObserver()
    }
    
    var onDidSendFormSuccess: Observable<String> {
        return self.sendFormSuccessInSubject.asObserver()
    }
    
    private var sendFormErrorInSubject = PublishSubject<Error>()
    private var sendFormSuccessInSubject = PublishSubject<String>()
    
    // swiftlint:disable:next function_parameter_count
    func sendAdvertisementForm(name: String, fromEmail: String, message: String, advertiseOn: String, company: String,
                               address: String, phone: String) -> Observable<String> {
        return formApi.sendAdvertisementForm(name: name, fromEmail: fromEmail, message: message,
                                             advertiseOn: advertiseOn, company: company, address: address, phone: phone)
            .catchError { error -> Observable<String> in
                self.sendFormErrorInSubject.onNext(error)
                return Observable.empty()
            }
            .do(onNext: { [unowned self] text in
                self.sendFormSuccessInSubject.onNext(text)
            })
    }
    
    // swiftlint:disable:next function_parameter_count
    func sendContactUsForm(name: String, fromEmail: String, message: String, phone: String, subject: String,
                           gender: String, preferContactMethod: String) -> Observable<String> {
        return formApi.sendContactUsForm(name: name, fromEmail: fromEmail, message: message, phone: phone,
                                         subject: subject, gender: gender, preferContactMethod: preferContactMethod)
            .catchError { error -> Observable<String> in
                self.sendFormErrorInSubject.onNext(error)
                return Observable.empty()
            }
            .do(onNext: { [unowned self] text in
                self.sendFormSuccessInSubject.onNext(text)
            })
    }
}
