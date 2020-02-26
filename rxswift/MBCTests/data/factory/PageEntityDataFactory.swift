//
//  PageDataFactory.swift
//  MBCTests
//
//  Created by Dao Le Quang on 12/8/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
@testable import MBC

class PageEntityDataFactory {
    static func getListPageEntity(ids: [String]) -> [PageEntity] {
        var pageEntities = [PageEntity]()
        for id in ids {
            pageEntities.append(PageEntity(id: id))
        }
        return pageEntities
    }
}
