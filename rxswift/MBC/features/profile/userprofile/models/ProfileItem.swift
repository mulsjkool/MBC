//
//  ProfileItem.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class ProfileItem {
    var titleLabel: String
    var placeHolder: String
    var isEditting: Bool = false
    var type: ProfileItemEnum
    
    init(titleLabel: String, placeHolder: String, type: ProfileItemEnum) {
        self.titleLabel = titleLabel
        self.placeHolder = placeHolder
        self.type = type
    }
}

class ProfileGenderItem {
    var titleLabel: String
    var maleTitle: String
    var femaleTile: String
    var isEditting: Bool = false
    var type: ProfileItemEnum
    
    init(titleLabel: String, maleTitle: String, femaleTile: String, type: ProfileItemEnum) {
        self.titleLabel = titleLabel
        self.maleTitle = maleTitle
        self.femaleTile = femaleTile
        self.type = type
    }
}

class ProfilePasswordItem {
    var titleLabel: String
    var placeHolderOldPassword: String
    var placeHolderNewPassword: String
    var placeHolderReNewPassword: String
    var isEditting: Bool = false
    var type: ProfileItemEnum
    
    init(titleLabel: String, placeHolderOldPassword: String,
         placeHolderNewPassword: String, placeHolderReNewPassword: String, type: ProfileItemEnum) {
        self.titleLabel = titleLabel
        self.placeHolderOldPassword = placeHolderOldPassword
        self.placeHolderNewPassword = placeHolderNewPassword
        self.placeHolderReNewPassword = placeHolderReNewPassword
        self.type = type
    }
}

class ProfileAddressItem {
    var titleLabel: String
    var placeHolderAddress: String
    var placeHolderCity: String
    var placeHolderCountry: String
    var isEditting: Bool = false
    var type: ProfileItemEnum
    
    init(titleLabel: String, placeHolderAddress: String,
         placeHolderCity: String, placeHolderCountry: String, type: ProfileItemEnum) {
        self.titleLabel = titleLabel
        self.placeHolderAddress = placeHolderAddress
        self.placeHolderCity = placeHolderCity
        self.placeHolderCountry = placeHolderCountry
        self.type = type
    }
}

class ProfileListBoxItem {
    var titleLabel: String
    var value: String
    
    var titleENLabel: String
    var titleARLabel: String
    
    init(titleLabel: String, value: String) {
        self.titleLabel = titleLabel
        self.value = value
        self.titleENLabel = ""
        self.titleARLabel = ""
    }
    
    init(titleENLabel: String, titleARLabel: String, value: String) {
        self.titleLabel = ""
        self.value = value
        self.titleENLabel = titleENLabel
        self.titleARLabel = titleARLabel
    }
}
