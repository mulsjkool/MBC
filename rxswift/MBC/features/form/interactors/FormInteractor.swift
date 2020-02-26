//
//  FormInteractor.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol FormInteractor {
    // swiftlint:disable:next function_parameter_count
    func sendAdvertisementForm(name: String, fromEmail: String, message: String, advertiseOn: String,
                               company: String, address: String, phone: String) -> Observable<String>
    
    // swiftlint:disable:next function_parameter_count
    func sendContactUsForm(name: String, fromEmail: String, message: String, phone: String, subject: String,
                           gender: String, preferContactMethod: String) -> Observable<String>
    
    var onDidSendFormError: Observable<Error> { get }
    var onDidSendFormSuccess: Observable<String> { get }
}
