//
//  PageHeaderEnumw.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

enum PageType: String {
    case show
    case profile
    case channel
    case award
    case business
    case section
    case events
    case other
}

enum PageSubType: String {
    case movie
    case series
    case program
    case news
    case match
    case play
    case star
    case sportPlayer
    case talent
    case guest
    case sportTeam
    case band
	case radioChannel
    case other
}

enum PageProfileSubType: String {
    case star
    case sportPlayer
    case guest
    case talent
    case sportTeam
    case band
    case other
}

enum PageShowSubType: String {
    case movie
    case series
    case program
    case news
    case play
    case match
    case other
}

enum PageAwardSubType: String {
    case beautyPageant
    case sport
    case music
    case film
    case television
    case other
}

enum Gender: String, Codable {
    case male
    case female
    
    func genderCode() -> String {
        switch self {
        case .male:
            return "m"
        case .female:
            return "f"
        }
    }
}

enum PreferredContactMethod: String, Codable {
    case byPhone
    case byEmail
    
    func preferredContactMethodCode() -> String {
        switch self {
        case .byPhone:
            return R.string.localizable.formPreferContactMethodByPhone.key
        case .byEmail:
            return R.string.localizable.formPreferContactMethodByEmail.key
        }
    }
}

enum SportTeamTypeEnum: String {
    case nationalTeam
    case clubTeam
}
