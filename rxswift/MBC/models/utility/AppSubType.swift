//
//  AppType.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum AppSubType: String {
	case game = "Game"
	case voting = "Voting"
	case other = "Other"
	case mobileApp = "MobileApp"
	case competition = "Competition"
	case casting = "Casting"
	case trivia = "Trivia"
    case live = "Live"
    case app = "app"
    
    func localizedContentType() -> String {
        switch self {
        case .game:
            return R.string.localizable.appTypeGame()
        case .voting:
            return R.string.localizable.appTypeVoting()
        case .other:
            return R.string.localizable.appTypeOther()
        case .mobileApp:
            return R.string.localizable.appTypeMobileApp()
        case .competition:
            return R.string.localizable.appTypeCompetition()
        case .casting:
            return R.string.localizable.appTypeCasting()
        case .trivia:
            return R.string.localizable.appTypeTrivia()
        case .live:
            return R.string.localizable.appTypeLivePost()
        case .app:
            return R.string.localizable.cardTypeApp()
        }
    }
    
    func localizedForCTAButton() -> String {
        switch self {
        case .game:
            return R.string.localizable.appCtaButtonGame()
        case .voting:
            return R.string.localizable.appCtaButtonVoting()
        case .other:
            return R.string.localizable.appCtaButtonOther()
        case .mobileApp:
            return R.string.localizable.appCtaButtonMobileApp()
        case .competition:
            return R.string.localizable.appCtaButtonCompetition()
        case .casting:
            return R.string.localizable.appCtaButtonCasting()
        case .trivia:
            return R.string.localizable.appCtaButtonTrivia()
        case .live:
            return R.string.localizable.appCtaButtonLivePost()
        case .app:
            return R.string.localizable.cardTypeApp()
        }
    }
}
