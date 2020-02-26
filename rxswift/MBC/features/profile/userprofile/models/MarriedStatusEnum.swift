//
//  MarriedStatusEnum.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

enum MarriedStatusEnum {
    static let allItems = [
        ProfileListBoxItem(titleLabel: R.string.localizable.commonMarriedStatusSingle(),
                                 value: "single"),
        ProfileListBoxItem(titleLabel: R.string.localizable.commonMarriedStatusMarried(),
                                 value: "married"),
        ProfileListBoxItem(titleLabel: R.string.localizable.commonMarriedStatusDivorce(),
                                 value: "divorce"),
        ProfileListBoxItem(titleLabel: R.string.localizable.commonMarriedStatusWidow(),
                                 value: "widow")
    ]
}
