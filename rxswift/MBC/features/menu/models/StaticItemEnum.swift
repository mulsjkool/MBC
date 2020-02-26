//
//  StaticItemEnum.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/1/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum StaticItemEnum {
    //case stream
    //case tv
    case appsAndGames
    //case interests
    //case networks
    case favorites
    //case schedules
    //case videos
    case channels

    static let allItems = [
        /*StaticMenuItem(icon: R.image.iconSidemenuStream(),
                       name: R.string.localizable.sidemenuStaticPageTitleStream().localized(),
                       type: .stream),
        StaticMenuItem(icon: R.image.iconSidemenuTv(),
                       name: R.string.localizable.sidemenuStaticPageTitleTv().localized(),
                       type: .tv),*/
        StaticMenuItem(icon: R.image.iconSidemenuFavorites(),
                       name: R.string.localizable.sidemenuStaticPageTitleFavorite().localized(),
                       type: .favorites),
        StaticMenuItem(icon: R.image.iconSidemenuGamesApps(),
                       name: R.string.localizable.sidemenuStaticPageTitleAppsGames().localized(),
                       type: .appsAndGames),
        /*StaticMenuItem(icon: R.image.iconSidemenuInterest(),
                       name: R.string.localizable.sidemenuStaticPageTitleInterest().localized(),
                       type: .interests),
        StaticMenuItem(icon: R.image.iconSidemenuNetworks(),
                       name: R.string.localizable.sidemenuStaticPageTitleNetworks().localized(),
                       type: .networks),
        StaticMenuItem(icon: R.image.iconSidemenuSchedule(),
                       name: R.string.localizable.sidemenuStaticPageTitleSchedule().localized(),
                       type: .schedules),
        StaticMenuItem(icon: R.image.iconSidemenuEpisodes(),
                       name: R.string.localizable.sidemenuStaticPageTitleEpisode().localized(),
                       type: .videos),*/
        StaticMenuItem(icon: R.image.iconSidemenuChannels(),
                       name: R.string.localizable.sidemenuStaticPageTitleChannel().localized(),
                       type: .channels)
    ]
}
