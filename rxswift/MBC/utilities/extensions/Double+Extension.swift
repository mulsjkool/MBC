//
//  Double+Extension.swift
//  MBC
//
//  Created by Tram Nguyen on 3/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

extension Double {

    func toDate() -> Date {
        return Date(timeIntervalSince1970: self / 1000)
    }

}
