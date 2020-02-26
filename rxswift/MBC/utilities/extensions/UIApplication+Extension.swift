//
//  UIApplication+Extension.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

extension UIApplication {
    
    // swiftlint:disable:next cyclomatic_complexity
    func openSocialApp(socialNetwork: SocialNetwork) {
        var url: URL? = nil
        guard let accountId = socialNetwork.accountId else { return }
        
        var newUrlStr = accountId.replacingOccurrences(of: "https", with: "")
        newUrlStr = newUrlStr.replacingOccurrences(of: "http", with: "")
        newUrlStr = newUrlStr.replacingOccurrences(of: "\\", with: "")
        
        switch socialNetwork.socialNetworkName {
        case .facebook:
            url = URL(string: "fb://profile/\(newUrlStr)")
        case .instagram:
            url = URL(string: "instagram://user?username=\(newUrlStr)")
        case .youtube:
            url = URL(string: "youtube://=\(newUrlStr)")
        case .twitter:
            url = URL(string: "twitter://user?screen_name=\(newUrlStr)")
        case .whatsapp:
            url = URL(string: "whatsapp://send?")
        case .googlePlus:
            url = URL(string: "gplus://\(newUrlStr)")
        case .snapchat:
            url = URL(string: "snapchat://add/snapchatUsername/\(newUrlStr)")
        case .linkedin:
            url = URL(string: "linkedin://#profile/\(newUrlStr)")
        case .pinterest:
            url = URL(string: "pinterest://user/\(newUrlStr)")
        case .vine:
            url = URL(string: "vine://user/\(newUrlStr)")
        case .vimeo:
            url = URL(string: "vimeo://\(newUrlStr)")
        default:
            return
        }
        
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else if let webUrl = URL(string: accountId), UIApplication.shared.canOpenURL(webUrl) {
            UIApplication.shared.openURL(webUrl)
        }
    }
}
