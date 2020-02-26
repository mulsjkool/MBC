//
//  AboutItemEnum.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/1/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum StaticPageEnum: Int {
    
    case shahid
    case goboz
    case mbc3
    case aboutsite
    case corporate
    case mbccsr
    case irec
    case freequency
    case contactus
    case advertise
    case phd
    case gobx
    case tos
    case privacy
    case signout
    case copyRight
    
    case none
    
    static let allItems = [
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleShahid().localized(),
                       type: .shahid,
                       url: R.string.localizable.sidemenuStaticPageUrlShahid()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleGoboz().localized(),
                       type: .goboz,
                       url: R.string.localizable.sidemenuStaticPageUrlGoboz()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleMbc3().localized(),
                       type: .mbc3,
                       url: R.string.localizable.sidemenuStaticPageUrlMbc3()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleAboutsite().localized(),
                       type: .aboutsite,
                       url: R.file.aboutHtml()?.absoluteString),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleAboutcorporate().localized(), type: .corporate,
                       url: R.string.localizable.sidemenuStaticPageUrlAboutcorporate()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleMbccsr().localized(),
                       type: .mbccsr,
                       url: R.string.localizable.sidemenuStaticPageUrlMbccsr()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleIrecruitment().localized(),
                       type: .irec,
                       url: R.string.localizable.sidemenuStaticPageUrlIrecruitment()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleFreequency().localized(),
                       type: .freequency,
                       url: R.string.localizable.sidemenuStaticPageUrlFreequency()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleContactus().localized(),
                       type: .contactus,
                       url: nil),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleAdvertise().localized(),
                       type: .advertise,
                       url: nil),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleHd().localized(),
                       type: .phd,
                       url: R.string.localizable.sidemenuStaticPageUrlHd()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleGobx().localized(),
                       type: .gobx,
                       url: R.string.localizable.sidemenuStaticPageUrlGobx()),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleTos().localized(),
                       type: .tos,
                       url: R.file.tosHtml()?.absoluteString),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitlePrivacy().localized(),
                       type: .privacy,
                       url: R.file.privacyHtml()?.absoluteString),
        StaticPageItem(name: R.string.localizable.sidemenuStaticPageTitleSignout().localized(),
                       type: .signout,
                       url: nil),
        StaticPageItem(name: R.string.localizable.sidemenuCopyrightTitle().localized(),
                       type: .copyRight,
                       url: nil)
    ]
}
