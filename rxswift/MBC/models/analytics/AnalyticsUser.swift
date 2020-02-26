//
//  AnalyticsUser.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum AnalyticsUserActivity {
    case login, logout, register
}

class AnalyticsUser: BaseAnalyticsTracking {

    private let userID: String
    private let userGigyaID: String
    private let userGender: Gender
    private let userAge: Int
    private let lastLoginDate: String
    private let authenticationProvider: String
    private let userActivity: AnalyticsUserActivity

    init?(response: GSResponse, userActivity: AnalyticsUserActivity) {
        guard let newUser = response["newUser"] as? Int, newUser == 1 else { return nil }
        guard let profile = response["profile"] as? NSDictionary else { return nil }

        self.userID = response["UID"] as? String ?? ""
        self.userGigyaID = response["UID"] as? String ?? ""
        self.userGender = (profile["gender"] as? String ?? "") == "f" ? Gender.female : Gender.male
        self.userAge = profile["age"] as? Int ?? 0
        self.lastLoginDate = ""
        self.authenticationProvider = response["socialProviders"] as? String ?? ""
        self.userActivity = userActivity
    }

    init(user: UserProfile, userActivity: AnalyticsUserActivity) {
        self.userID = user.uid
        self.userGigyaID = user.uid
        self.userGender = user.gender
        self.userAge = user.birthday?.age ?? 0
        self.lastLoginDate = user.lastLoginTimestamp
        self.authenticationProvider = user.loginProvider
        self.userActivity = userActivity
    }

    var genderString: String {
        return userGender == .female ? "F" : "M"
    }

}

extension AnalyticsUser: IAnalyticsTrackingObject {

    var contendID: String? {
        return nil
    }

    var eventName: String {
        return AnalyticsEventName.eventTracking.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.userActivity.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsUserVariable.userGigyaID.rawValue: userGigyaID,
                       AnalyticsUserVariable.userMbcID.rawValue: userID,
                       AnalyticsUserVariable.userGender.rawValue: genderString,
                       AnalyticsUserVariable.userAge.rawValue: userAge,
                       AnalyticsUserVariable.userType.rawValue: "registered",
                       AnalyticsUserVariable.lastLoginDate.rawValue: lastLoginDate,
                       AnalyticsUserVariable.loginProvider.rawValue: authenticationProvider
        ]

        if userActivity == .login {
            parameters += [AnalyticsOtherVariable.eventAction.rawValue: AnalyticsEventAction.clickOnLogin.rawValue,
                           AnalyticsOtherVariable.eventLabel.rawValue: AnalyticsEventLabel.login.rawValue
            ]
        } else if userActivity == .logout {
            parameters += [AnalyticsOtherVariable.eventAction.rawValue: AnalyticsEventAction.clickOnLogout.rawValue,
                           AnalyticsOtherVariable.eventLabel.rawValue: AnalyticsEventLabel.logout.rawValue
            ]
        } else if userActivity == .register {
            parameters += [AnalyticsOtherVariable.eventAction.rawValue:
                AnalyticsEventAction.clickOnRegistraton.rawValue,
                           AnalyticsOtherVariable.eventLabel.rawValue: AnalyticsEventLabel.register.rawValue
            ]
        }

        return parameters
    }

    var customTargeting: [String: String] {
        return ["usr_gender": genderString,
                "usr_age": "\(userAge)",
                "usr_type": "registered"
        ]
    }

}
