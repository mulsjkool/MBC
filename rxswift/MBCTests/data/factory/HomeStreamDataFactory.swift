//
//  HomeStreamDataFactory.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
@testable import MBC

class HomeStreamDataFactory {
    static func getNextItems(ids: [String]) -> [Campaign] {
        var camps = [Campaign]()
        for id in ids {
            camps.append(Campaign(id: id))
        }
        return camps
    }
}
