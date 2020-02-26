//
//  PageDetailRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

protocol PageDetailRepository {
    func savePageDetail(pageDetail: PageDetail)
    func getCachedPageDetail(pageId: String) -> PageDetail?
    func clearPageDetailCache(pageId: String)
    func clearPageDetailCache()
}
