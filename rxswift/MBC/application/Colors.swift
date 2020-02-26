303034//
//  Colors.swift
//  F8
//
//  Created by Dao Le Quang on 11/2/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import UIKit

enum Colors: Int {

    case white = 0xFFFFFF
    case green = 0x64EF04
    case dark = 0x263238
    case darkBorder = 0x403F3F
    case black = 0x202020
    case blackBackGround = 0x0B0B0B
    case bunting = 0x273142
    case lightBlack = 0x2C2C2C
    case gray = 0x909094
    case lightGray = 0xDADADA
    case lightGray1 = 0xD0D0D0
    case orange = 0xF5A623
    case lightOrange = 0xf3a536
    case lightRed = 0xda2536
    case blue = 0x2297e8
    case darkRed = 0xDC2130
    
    case lightGrayStatusbar = 0xF8F8F8
    
    case facebookButton = 0x4e6dac
    
    case userProfileTabButton = 0x78909C
    
    case redActiveTabbarItem = 0xE35050
    case unselectedTabbarItem = 0xCFD8DC
    case cardText = 0x385056
    case defaultBg = 0xECEFF1
    case defaultText = 0x607D8B
    
    case defaultAccentColor = 0xEF5350
    case badgeColorRed = 0xEF5351
    case activeFilterSortingTab = 0xEF5349
    
    //Use for Sign up, Sign in, Forgot password
    case disabledButtonGrayColor = 0xCFD8DD
    case enabledButtonGrayColor = 0x607D8C
    
    case normalTextFieldBorderColor = 0xCFD8DE
    case errorTextFieldBorderColor = 0xEF5352
    
    case defaultPageCarouselHeaderColor = 0x6d608b
    
    case filterTextColor = 0x4A4A4A
	case highlightedColor = 0xF5C24F
	case radioDefaultColor = 0xD8D8D8
    case channelTabBackgroundColor = 0x304550
    case highlightedTextColor = 0x78909d
	case playlistMenuContent = 0x181f23
	case playlistRelated = 0xf7f9f9
    case singleItemAccentColor = 0xCFD8DB

    func color(alpha: CGFloat = 1) -> UIColor {
        return UIColor(netHex: self.rawValue, alpha: alpha)
    }
}
