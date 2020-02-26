//
//  SocialNetworkEnum.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

enum SocialNetworkEnum: String, Codable {
	case apple = "Apple"
    case facebook = "Facebook"
    case twitter = "Twitter"
    case whatsapp = "Whatsapp"
    case instagram = "Instagram"
    case youtube = "Youtube"
    case googlePlus = "GooglePlus"
    case linkedin = "Linkedin"
    case pinterest = "Pinterest"
    case vine = "Vine"
    case vimeo = "Vimeo"
    case snapchat = "Snapchat"
    case unknown = "unknown"
    
    // swiftlint:disable:next cyclomatic_complexity
    func image() -> UIImage? {
        switch self {
        case .facebook:
            return R.image.iconInfortabFacebook()
        case .instagram:
            return R.image.iconInfortabInstagram()
        case .twitter:
            return R.image.iconInfortabTwitter()
        case .whatsapp:
            return R.image.iconInfortabWhatsapp()
        case .youtube:
            return R.image.iconInfortabYoutube()
        case .googlePlus:
            return R.image.iconInfortabGoogleplus()
        case .snapchat:
            return R.image.iconInfortabSnapchat()
        case .linkedin:
            return R.image.iconInfortabLinkedin()
        case .pinterest:
            return R.image.iconInfortabPinterest()
        case .vine:
            return R.image.iconInfortabVine()
        case .vimeo:
            return R.image.iconInfortabVimeo()
        case .apple, .unknown:
            return nil
        }
    }
	
	// swiftlint:disable:next cyclomatic_complexity
	func whiteLogo() -> UIImage? {
		switch self {
		case .apple:
			return R.image.iconRadioSocialApple()
		case .facebook:
			return R.image.iconRadioSocialFacebook()
		case .instagram:
			return R.image.iconRadioSocialInstagram()
		case .twitter:
			return R.image.iconRadioSocialTwitter()
		case .whatsapp:
			return R.image.iconRadioSocialWhatsapp()
		case .youtube:
			return R.image.iconRadioSocialYoutube()
		case .googlePlus:
			return R.image.iconRadioSocialGoogle()
		case .snapchat:
			return R.image.iconRadioSocialSnapchat()
		case .linkedin:
			return R.image.iconRadioSocialLinkedin()
		case .pinterest:
			return R.image.iconRadioSocialPinterest()
		case .vine:
			return R.image.iconRadioSocialVine()
		case .vimeo:
			return R.image.iconRadioSocialVimeo()
		case .unknown:
			return nil
		}
	}
}
