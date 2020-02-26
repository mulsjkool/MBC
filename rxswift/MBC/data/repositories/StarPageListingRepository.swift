//
//  StarPageListingRepository.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol StarPageListingRepository {
    func saveInCampaignList(list: [Star])
    func saveRemainingList(list: [Star])
    func getInCampaignList() -> [Star]?
    func getRemainingList() -> [Star]?
    func clearCachedInCampaignList()
    func clearCachedRemainingList()
}
