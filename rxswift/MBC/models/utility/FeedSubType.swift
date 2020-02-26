//
//  FeedSubType.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/8/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum FeedSubType: String {
    case text
    case image
    case video
    case embed
    case episode
    
    func localizedContentType() -> String {
        switch self {
        case .text:
            return R.string.localizable.cardTypeTextPost()
        case .image:
            return R.string.localizable.cardTypeImage()
        case .video:
            return R.string.localizable.cardTypeVideo()
        case .embed:
            return R.string.localizable.cardTypeLink()
        case .episode:
            return R.string.localizable.cardTypeEpisodes()
        }
    }
}
