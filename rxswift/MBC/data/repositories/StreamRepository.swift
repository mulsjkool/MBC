//
//  StreamRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

protocol StreamRepository {
    func savePageStream(pageId: String, itemList: ItemList, dataIndex: (index: Int, totalLoaded: Int)?)
    func getCachedPageStream(pageId: String) -> (itemList: ItemList?, index: Int, totalLoaded: Int)
    func clearPageStreamCache()
    func clearPageStreamCache(pageId: String)
    
    func saveCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)
    func getCachedCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)
    func clearCampaignsCache()
    
    func saveVideoCampaigns(_ campaigns: [Campaign], dataIndex: (index: Int, totalLoaded: Int)?)
    func getCachedVideoCampaigns() -> (list: [Campaign]?, index: Int, totalLoaded: Int)
    func clearVideoCampaignsCache()
}
