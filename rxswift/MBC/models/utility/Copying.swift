//
//  Copying.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol Copying {
    init(original: Self)
}

extension Copying {
    
    func copy() -> Self {
        // swiftlint:disable explicit_init
        return Self.init(original: self)
    }
    
}
