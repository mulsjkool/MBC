//
//  DayOfWeeks.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum DayOfWeeks: String {
    case mon = "Mon"
    case tue = "Tue"
    case web = "Wed"
    case thu = "Thu"
    case fri = "Fri"
    case sat = "Sat"
    case sun = "Sun"
    
    func localizedContentType() -> String {
        switch self {
        case .mon:
            return R.string.localizable.dayOfWeekMon()
        case .tue:
            return R.string.localizable.dayOfWeekTue()
        case .web:
            return R.string.localizable.dayOfWeekWed()
        case .thu:
            return R.string.localizable.dayOfWeekThu()
        case .fri:
            return R.string.localizable.dayOfWeekFri()
        case .sat:
            return R.string.localizable.dayOfWeekSat()
        case .sun:
            return R.string.localizable.dayOfWeekSun()
        }
    }
    
    func idContent() -> Int {
        switch self {
        case .mon:
            return 1
        case .tue:
            return 2
        case .web:
            return 3
        case .thu:
            return 4
        case .fri:
            return 5
        case .sat:
            return 6
        case .sun:
            return 7
        }
    }
}
