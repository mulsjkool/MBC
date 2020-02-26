//
//  FormItemEnum.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum FormItemEnum {
    case name
    case email
    case phone
    case gender
    case subject
    case message
    case preferredContactMethod
    
    case address
    case company
    case advertiseOn
    
    static let contactUsItems: [Any] = [
        FormItem(titleLabel: R.string.localizable.formName(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .name, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formEmail(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .email, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formPhone(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .phone, defaultValue: ""),
        RadioGroupFormItem(title: R.string.localizable.formGender(),
                           titleLeft: R.string.localizable.commonButtonMale(),
                           valueLeft: "",
                           titleRight: R.string.localizable.commonButtonFemale(),
                           valueRight: "",
                           type: .gender),
        FormItem(titleLabel: R.string.localizable.formSubject(),
                 placeHolder: "",
                 type: .subject, defaultValue: ArrayFormItemEnum.arraySubject[0].value),
        FormItem(titleLabel: R.string.localizable.formMessageContactUs(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .message, defaultValue: ""),
        RadioGroupFormItem(title: R.string.localizable.formPreferredContactMethod(),
                           titleLeft: R.string.localizable.formPreferContactMethodByPhone(),
                           valueLeft: "",
                           titleRight: R.string.localizable.formPreferContactMethodByEmail(),
                           valueRight: "",
                           type: .preferredContactMethod)
    ]
    
    static let advertisementItems: [Any] = [
        FormItem(titleLabel: R.string.localizable.formName(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .name, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formEmail(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .email, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formAddress(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .address, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formCompany(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .company, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formAdvertiseOn(),
                 placeHolder: "",
                 type: .advertiseOn, defaultValue: ArrayFormItemEnum.arrayAdvertiseOn[0].value),
        FormItem(titleLabel: R.string.localizable.formPhone(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .phone, defaultValue: ""),
        FormItem(titleLabel: R.string.localizable.formMessageAdvertisement(),
                 placeHolder: R.string.localizable.formPlaceHolderWriteHere(),
                 type: .message, defaultValue: "")
    ]
}

enum ArrayFormItemEnum {
    static let arrayAdvertiseOn: [DropdownListFormItem] = [
        DropdownListFormItem(titleLabel: R.string.localizable.formAdvertiseOnTV(),
                             value: R.string.localizable.formAdvertiseOnTV.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formAdvertiseOnOnline(),
                             value: R.string.localizable.formAdvertiseOnOnline.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formAdvertiseOnRadio(),
                             value: R.string.localizable.formAdvertiseOnRadio.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formAdvertiseOnEvent(),
                             value: R.string.localizable.formAdvertiseOnEvent.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formAdvertiseOnOthers(),
                             value: R.string.localizable.formAdvertiseOnOthers.key)
    ]
    
    static let arraySubject: [DropdownListFormItem] = [
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectWinnerInquiry(),
                             value: R.string.localizable.formSubjectWinnerInquiry.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectCompetitionInquiry(),
                             value: R.string.localizable.formSubjectCompetitionInquiry.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectBillingInquiry(),
                             value: R.string.localizable.formSubjectBillingInquiry.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectGeneralFeedback(),
                             value: R.string.localizable.formSubjectGeneralFeedback.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectMBCChannel(),
                             value: R.string.localizable.formSubjectMBCChannel.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectMBCRadios(),
                             value: R.string.localizable.formSubjectMBCRadios.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectMBCOnline(),
                             value: R.string.localizable.formSubjectMBCOnline.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectSMSServices(),
                             value: R.string.localizable.formSubjectSMSServices.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectEvents(),
                             value: R.string.localizable.formSubjectEvents.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectArabGotTalent(),
                             value: R.string.localizable.formSubjectArabGotTalent.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectArabIdol(),
                             value: R.string.localizable.formSubjectArabIdol.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectTheVoice(),
                             value: R.string.localizable.formSubjectTheVoice.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectTheXfactor(),
                             value: R.string.localizable.formSubjectTheXfactor.key),
        DropdownListFormItem(titleLabel: R.string.localizable.formSubjectTheVoiceKid(),
                             value: R.string.localizable.formSubjectTheVoiceKid.key)
    ]
}
