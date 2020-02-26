//
//  FeedType.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum FeedType: String, Decodable {
    case post
    case article
    case app
    case page
    case campaign
	case bundle
	case playlist
    
    func localizedContentType(subType: String) -> String? {
        switch self {
        case .post:
            if let subType = FeedSubType(rawValue: subType) {
                let localizedSubType = subType.localizedContentType()
                return (localizedSubType.isEmpty) ? self.rawValue : localizedSubType
            }
            return self.rawValue
        case .article:
            return R.string.localizable.cardTypeArticle()
        case .app:
            return R.string.localizable.cardTypeApp()
        default:
			return self.rawValue
        }
    }
    
    func contentTypeForFilterContentApi() -> String {
        switch self {
        case .app:
            return "app"
        default:
            return ""
        }
    }
}
