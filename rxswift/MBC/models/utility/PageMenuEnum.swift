//
//  PageMenuEnum.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/5/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import UIKit

enum PageMenuEnum: Int {
    case newsfeed = 0
    case videos
    case photos
    case about
    case episodes
    case music
    case apps
    case schedule
    case other
    case undefine
    
    static func convertFrom(stringValue: String) -> PageMenuEnum? {
        for item in allItems where item.type.description == stringValue {
            return item.type
        }
        
        return nil
    }
    
    var description: String {
        switch self {
        case .about:
            return "about"
        case .newsfeed:
            return "newsfeed"
        case .videos:
            return "videos"
        case .photos:
            return "photos"
        case .episodes:
            return "episodes"
        case .music:
            return "music"
        case .apps:
            return "apps"
        case .schedule:
            return "schedule"
        case .other:
            return "other"
        default:
            return "undefine"
        }
    }
    
    static let allItems = [
        PageMenuItem(icon: nil,
                     name: R.string.localizable.pagemenuOtherTitle().localized(),
                     type: .other),
        PageMenuItem(icon: R.image.iconPageMenuScheduler(),
                     name: R.string.localizable.pagemenuScheduleTitle().localized(),
                     type: .schedule),
        PageMenuItem(icon: R.image.iconPageMenuApps(),
                     name: R.string.localizable.pagemenuAppsTitle().localized(),
                     type: .apps),
        PageMenuItem(icon: nil,
                     name: R.string.localizable.pagemenuMusicTitle().localized(),
                     type: .music),
        PageMenuItem(icon: R.image.iconPageMenuEpisodes(),
                     name: R.string.localizable.pagemenuEpisodesTitle().localized(),
                     type: .episodes),
        PageMenuItem(icon: R.image.iconPageMenuAbout(),
                     name: R.string.localizable.pagemenuAboutTitle().localized(),
                     type: .about),
        PageMenuItem(icon: R.image.iconPageMenuPhotoes(),
                     name: R.string.localizable.pagemenuPhotosTitle().localized(),
                     type: .photos),
        PageMenuItem(icon: R.image.iconPageMenuVideos(),
                     name: R.string.localizable.pagemenuVideosTitle().localized(),
                     type: .videos),
        PageMenuItem(icon: R.image.iconPageMenuNewsfeed(),
                     name: R.string.localizable.pagemenuNewsfeedTitle().localized(),
                     type: .newsfeed)
    ]
}
