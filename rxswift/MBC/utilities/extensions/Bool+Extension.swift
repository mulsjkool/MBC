//
//  Bool+Extension.swift
//  MBC
//
//  Created by Tram Nguyen on 3/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

extension Bool {
    var intValue: Int {
        if self {
            return 1
        }
        return 0
    }

    var audioMode: VideoAudioMode {
        if self {
            return .audioOff
        }
        return .audioOn
    }
}
