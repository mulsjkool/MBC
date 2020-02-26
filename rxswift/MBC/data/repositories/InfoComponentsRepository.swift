//
//  InfoComponentsRepository.swift
//  MBC
//
//  Created by Dung Nguyen on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol InfoComponentsRepository {
    func saveInfoComponent(pageId: String, component: [InfoComponent])
    func getCachedInfoComponent(pageId: String) -> [InfoComponent]?
    func clearInfoComponentCache(pageId: String)
    func clearInfoComponentCache()
}
