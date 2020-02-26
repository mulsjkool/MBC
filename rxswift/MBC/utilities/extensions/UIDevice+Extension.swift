//
//  UIDevice+Extension.swift
//  MBC
//
//  Created by Tram Nguyen on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

extension UIDevice {
    var isSimulator: Bool {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }
}
