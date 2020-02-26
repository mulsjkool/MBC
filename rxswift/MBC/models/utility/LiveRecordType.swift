//
//  LiveRecordType.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 2/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum LiveRecordType: String {
    case live
    case record
    case recorded
    
    func getArabicText() -> String {
        switch self {
        case .live:
            return R.string.localizable.abouttabLive()
        case .record:
            return R.string.localizable.abouttabRecorded()
        case .recorded:
            return R.string.localizable.abouttabRecorded()
        }
    }
}
