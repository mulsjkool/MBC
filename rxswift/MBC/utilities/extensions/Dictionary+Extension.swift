//
//  Dictionary+Extension.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

extension Dictionary {

    static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }
}
