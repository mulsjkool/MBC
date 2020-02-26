//
//  EpisodeRepository.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

protocol EpisodeRepository {
    func saveEpisodeListFor(pageId: String, list: [Post], grandTotal: Int?)
    func getEpisodeListFor(pageId: String) -> (list: [Post]?, grandTotal: Int)
    func clearCachedEpisodeListFor(pageId: String)
}
