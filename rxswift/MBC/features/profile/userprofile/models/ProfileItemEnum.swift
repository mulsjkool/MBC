//
//  ProfileItemEnum.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

enum ProfileItemEnum {
    case fullName
    case email
    case gender
    case password
    case marriedStatus
    case phoneNumber
    case birthday
    case nationality
    case address

    static let allItems: [Any] = [
        ProfileItem(titleLabel: R.string.localizable.userProfileTabProfileFullName(),
                    placeHolder: R.string.localizable.userProfileTabProfileFullName(),
                    type: .fullName),
        ProfileItem(titleLabel: R.string.localizable.userProfileTabProfileEmail(),
                    placeHolder: R.string.localizable.userProfileTabProfileEmail(),
                    type: .email),
        ProfileGenderItem(titleLabel: R.string.localizable.userProfileTabProfileGender(),
                          maleTitle: R.string.localizable.commonButtonMale(),
                          femaleTile: R.string.localizable.commonButtonFemale(),
                          type: .gender),
        ProfilePasswordItem(titleLabel: R.string.localizable.userProfileTabProfilePassword(),
                            placeHolderOldPassword: R.string.localizable.userProfileTabProfileOldPasswordPlaceHolder(),
                            placeHolderNewPassword: R.string.localizable.userProfileTabProfileNewPasswordPlaceHolder(),
                            placeHolderReNewPassword:
            R.string.localizable.userProfileTabProfileRenewPasswordPlaceHolder(),
                            type: .password),
        ProfileItem(titleLabel: R.string.localizable.userProfileTabProfileMarriedStatus(),
                    placeHolder: R.string.localizable.userProfileTabProfileMarriedStatus(),
                    type: .marriedStatus),
        ProfileItem(titleLabel: R.string.localizable.userProfileTabProfilePhoneNumber(),
                    placeHolder: R.string.localizable.userProfileTabProfilePhoneNumber(),
                    type: .phoneNumber),
        ProfileItem(titleLabel: R.string.localizable.userProfileTabProfileBirthday(),
                    placeHolder: R.string.localizable.userProfileTabProfileBirthday(),
                    type: .birthday),
        ProfileItem(titleLabel: R.string.localizable.userProfileTabProfileNationality(),
                    placeHolder: R.string.localizable.userProfileTabProfileNationality(),
                    type: .nationality),
        ProfileAddressItem(titleLabel: R.string.localizable.userProfileTabProfileAddress(),
                           placeHolderAddress: R.string.localizable.userProfileTabProfileAddress(),
                           placeHolderCity: R.string.localizable.userProfileTabProfileCity(),
                           placeHolderCountry: R.string.localizable.userProfileTabProfileCountry(),
                           type: .address)
    ]
}
