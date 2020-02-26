//
//  CommonUT.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/1/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
@testable import MBC

class CommonUT {
    static let wsTimeout = 10.0
    
    static let configurations: Configurations = {
        let path = Bundle.main.path(forResource: "configuration", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: path)!
        return Configurations(dictionary: dictionary)
    }()

    static var apiBaseUrl: String {
        return CommonUT.configurations.apiBaseUrl
    }

    static var host: String {
        return CommonUT.apiBaseUrl.replacingOccurrences(of: "http://", with: "")
    }
}
