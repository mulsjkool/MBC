//
//  FormViewModel.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class FormViewModel: BaseViewModel {
    private var interactor: FormInteractor!
    
    var strName: String = ""
    var strEmail: String = ""
    var strPhone: String = ""
    var strGender: String = ""
    var strSubject: String = ArrayFormItemEnum.arraySubject[0].value
    var strMessage: String = ""
    var strPreferredContactMethod: String = ""
    var strAddress: String = ""
    var strCompany: String = ""
    var strAdvertiseOn: String = ArrayFormItemEnum.arrayAdvertiseOn[0].value
    
    var onShowError = PublishSubject<GigyaCodeEnum>()
    var onNeedReloadTable = PublishSubject<Void>()
    
    private let startSendAdvertisementFormOnDemand = PublishSubject<Void>()
    private let startSendContactUsFormOnDemand = PublishSubject<Void>()
    
    var onDidRefreshAccountInfo: Observable<UserProfile?>!
    
    var onFinishSendForm: Observable<String>!
    var onWillStartSendForm = PublishSubject<Void>()
    var onWillStopSendForm = PublishSubject<Void>()
    
    init(interactor: FormInteractor) {
        self.interactor = interactor
        super.init()
        setUpRx()
    }
    
    // MARK: Public Properties
    
    var totalContactUsItems: Int {
        return FormItemEnum.contactUsItems.count
    }
    
    var totalAdvertisementItems: Int {
        return FormItemEnum.advertisementItems.count
    }
    
    // MARK: Public methods
    
    func contactUsItemAt(index: Int) -> Any? {
        guard index < totalContactUsItems else { return nil }
        return FormItemEnum.contactUsItems[index]
    }
    
    func advertisementItemAt(index: Int) -> Any? {
        guard index < totalAdvertisementItems else { return nil }
        return FormItemEnum.advertisementItems[index]
    }
    
    func printValue() {
        print("---------------------------------------")
        print("strName: \(strName)")
        print("strEmail: \(strEmail)")
        print("strPhone: \(strPhone)")
        print("strGender: \(strGender)")
        print("strSubject: \(strSubject)")
        print("strMessage: \(strMessage)")
        print("strPreferredContactMethod: \(strPreferredContactMethod)")
        print("strAddress: \(strAddress)")
        print("strCompany: \(strCompany)")
        print("strAdvertiseOn: \(strAdvertiseOn)")
    }
    
    func sendAdvertisementForm(array: [Any]) {
        sendData(array: array, isAdvertisementForm: true)
    }
    
    func sendContactUsForm(array: [Any]) {
        sendData(array: array, isAdvertisementForm: false)
    }
    
    func refreshAllError(array: [Any]) {
        for item in array {
            if let item = item as? FormItem {
                item.error = ""
                if item.type == .advertiseOn {
                    item.valueText = ArrayFormItemEnum.arrayAdvertiseOn[0].value
                } else if item.type == .subject {
                    item.valueText = ArrayFormItemEnum.arraySubject[0].value
                } else {
                    item.valueText = ""
                }
            } else if let item = item as? RadioGroupFormItem {
                item.error = ""
                item.valueText = ""
            }
        }
    }
    
    // MARK: - Private functions
    
    private func setUpRx() {
        onFinishSendForm = interactor.onDidSendFormSuccess
            .do(onNext: { [unowned self] _ in
                self.onWillStopSendForm.onNext(())
            })
        
        disposeBag.addDisposables([
            startSendAdvertisementFormOnDemand
                .do(onNext: { [unowned self] _ in
                    self.onWillStartSendForm.onNext(())
                })
                .flatMap({ [unowned self] _ -> Observable<String> in
                    return self.interactor.sendAdvertisementForm(name: self.strName, fromEmail: self.strEmail,
                                                                 message: self.strMessage,
                                                                 advertiseOn: self.strAdvertiseOn,
                                                                 company: self.strCompany, address: self.strAddress,
                                                                 phone: self.strPhone)
                })
                .subscribe(),
            
            startSendContactUsFormOnDemand
                .do(onNext: { [unowned self] _ in
                    self.onWillStartSendForm.onNext(())
                })
                .flatMap({ [unowned self] _ -> Observable<String> in
                    return self.interactor.sendContactUsForm(name: self.strName, fromEmail: self.strEmail,
                                                             message: self.strMessage, phone: self.strPhone,
                                                             subject: self.strSubject, gender: self.strGender,
                                                             preferContactMethod: self.strPreferredContactMethod)
                })
                .subscribe(),
            
            interactor.onDidSendFormError
                .do(onNext: { [unowned self] error in
                    self.onWillStopSendForm.onNext(())
                    let error = error as NSError
                    self.onShowError.onNext(GigyaCodeEnum(rawValue: error.code) ?? GigyaCodeEnum.unknownError)
                })
                .subscribe()
        ])
    }
    
    private func sendData(array: [Any], isAdvertisementForm: Bool) {
        self.checkAllError(array: array)
        self.onNeedReloadTable.onNext(())
        
        if self.canRunAPI(array: array) {
            if isAdvertisementForm {
                startSendAdvertisementFormOnDemand.onNext(())
            } else {
                startSendContactUsFormOnDemand.onNext(())
            }
        }
    }
    
    private func checkAllError(array: [Any]) {
        for item in array {
            if let item = item as? FormItem {
                item.error = ""
                self.checkErrorWith(item: item)
            } else if let item = item as? RadioGroupFormItem {
                item.error = ""
                self.checkErrorWith(item: item)
            }
        }
    }
    
    private func canRunAPI(array: [Any]) -> Bool {
        for item in array {
            if let item = item as? FormItem, !item.error.isEmpty {
                return false
            } else if let item = item as? RadioGroupFormItem, !item.error.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func checkErrorWith(item: FormItem) {
        switch item.type {
        case .name:
            item.valueText = strName
            if strName.isEmpty { item.error = R.string.localizable.errorFieldIsRequired() }
        case .address:
            item.valueText = strAddress
            if strAddress.isEmpty { item.error = R.string.localizable.errorFieldIsRequired() }
        case .company:
            item.valueText = strCompany
            if strCompany.isEmpty { item.error = R.string.localizable.errorFieldIsRequired() }
        case .phone:
            item.valueText = strPhone
            if strPhone.isEmpty {
                item.error = R.string.localizable.errorFieldIsRequired()
            } else if !strPhone.isPhoneNumber {
                item.error = R.string.localizable.errorPhoneNumberFormatIncorrect()
            }
        case .message:
            item.valueText = strMessage
            if strMessage.isEmpty { item.error = R.string.localizable.errorFieldIsRequired() }
        case .email:
            item.valueText = strEmail
            if strEmail.isEmpty {
                item.error = R.string.localizable.errorFieldIsRequired()
            } else if !self.strEmail.isEmail {
                item.error = R.string.localizable.errorEmailFormatIncorrect()
            }
        default: break
        }
    }
    
    private func checkErrorWith(item: RadioGroupFormItem) {
        if item.type == .gender, self.strGender.isEmpty {
            item.error = R.string.localizable.errorFieldIsRequired()
        } else if item.type == .preferredContactMethod, self.strPreferredContactMethod.isEmpty {
            item.error = R.string.localizable.errorFieldIsRequired()
        }
    }
}
