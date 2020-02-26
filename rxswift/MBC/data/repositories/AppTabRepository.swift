//
//  AppTabRepository.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol AppTabRepository {
    func saveAppsListFor(pageId: String, appList: [App], grandTotal: Int?)
    func getCachedAppsListFor(pageId: String) -> (list: [App]?, grandTotal: Int)
    func clearCachedAppsListFor(pageId: String)
    
    func saveInStreamApps(appList: [App])
    func saveRemainingApps(appList: [App])
    func getInStreamApps() -> [App]?
    func getRemainingApps() -> [App]?
    func clearCachedInStreamApps()
    func clearCachedRemainingApps()
}
