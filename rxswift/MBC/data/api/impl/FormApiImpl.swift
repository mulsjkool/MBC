//
//  FormApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 4/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

class FormApiImpl: BaseApiClient<Void>, FormApi {
    private static let formFields = (
        name: "name",
        fromEmail: "fromEmail",
        message: "message",
        gender: "gender",
        advertiseOn: "advertiseOn",
        company: "company",
        address: "address",
        phone: "phone",
        subject: "subject",
        preferContactMethod: "preferContactMethod",
        messageId: "messageId"
    )
    
    // MARK: Advertisement form
    
    private static let advertisePath = "/notifications/forms/advertise-us"
    
    // swiftlint:disable:next function_parameter_count
    func sendAdvertisementForm(name: String, fromEmail: String, message: String, advertiseOn: String,
                               company: String, address: String, phone: String) -> Observable<String> {
        let fields = FormApiImpl.formFields
        let params: [String: Any] = [
            fields.name: name,
            fields.fromEmail: fromEmail,
            fields.message: message,
            fields.advertiseOn: advertiseOn,
            fields.company: company,
            fields.address: address,
            fields.phone: phone
        ]
        
        return apiClient.post(FormApiImpl.advertisePath,
                              parameters: params,
                              errorHandler: { _, error -> Error in
                                return error
        }, parse: { json -> String in
            return json[fields.messageId].stringValue
        })
    }
    
    // MARK: Contact us form
    
    private static let contactUsPath = "/notifications/forms/contact-us"
    
    // swiftlint:disable:next function_parameter_count
    func sendContactUsForm(name: String, fromEmail: String, message: String, phone: String, subject: String,
                               gender: String, preferContactMethod: String) -> Observable<String> {
        let fields = FormApiImpl.formFields
        let params: [String: Any] = [
            fields.name: name,
            fields.fromEmail: fromEmail,
            fields.message: message,
            fields.gender: gender,
            fields.subject: subject,
            fields.preferContactMethod: preferContactMethod,
            fields.phone: phone
        ]
        
        return apiClient.post(FormApiImpl.contactUsPath,
                              parameters: params,
                              errorHandler: { _, error -> Error in
                                return error
        }, parse: { json -> String in
            return json[fields.messageId].stringValue
        })
    }
}
