//
//  ChannelRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

protocol ChannelRepository {
    func saveChannelList(channelList: [PageDetail])
    func getCachedChannelList() -> [PageDetail]?
    func clearCachedChannelList()
}
