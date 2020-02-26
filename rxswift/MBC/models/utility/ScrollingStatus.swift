//
//  ScrollingStatus.swift
//  MBC
//
//  Created by Tram Nguyen on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum ScrollingStatus {
    case didBeginDecelerating, autoScrolling, autoPlay

    func isAutoNext() -> Bool {
        return self == .autoScrolling
    }
}
