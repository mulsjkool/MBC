//
//  StarPageMonthOfBirth.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum StarPageMonthOfBirth: String {
    case jan = "1"
    case feb = "2"
    case mar = "3"
    case apr = "4"
    case may = "5"
    case jun = "6"
    case jul = "7"
    case aug = "8"
    case sep = "9"
    case oct = "10"
    case nov = "11"
    case dec = "12"
    
    // swiftlint:disable:next cyclomatic_complexity
    func localizedMonthOfBirth() -> String {
        switch self {
        case .jan:
            return R.string.localizable.monthOfBirthJan()
        case .feb:
            return R.string.localizable.monthOfBirthFeb()
        case .mar:
            return R.string.localizable.monthOfBirthMar()
        case .apr:
            return R.string.localizable.monthOfBirthApr()
        case .may:
            return R.string.localizable.monthOfBirthMay()
        case .jun:
            return R.string.localizable.monthOfBirthJun()
        case .jul:
            return R.string.localizable.monthOfBirthJul()
        case .aug:
            return R.string.localizable.monthOfBirthAug()
        case .sep:
            return R.string.localizable.monthOfBirthSep()
        case .oct:
            return R.string.localizable.monthOfBirthOct()
        case .nov:
            return R.string.localizable.monthOfBirthNov()
        case .dec:
            return R.string.localizable.monthOfBirthDec()
        }
    }
}
