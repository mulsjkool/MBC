//
//  ShowListingRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

protocol ShowListingRepository {
    func saveInCampaignList(list: [Show])
    func saveRemainingList(list: [Show])
    func getInCampaignList() -> [Show]?
    func getRemainingList() -> [Show]?
    func clearCachedInCampaignList()
    func clearCachedRemainingList()
}
