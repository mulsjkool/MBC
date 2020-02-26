//
//  Session.swift
//  F8
//
//  Created by Dao Le Quang on 10/28/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

class Session: Codable {
    let loginByFacebook: Bool
    var user: UserProfile
    var accessToken: String?
    var regionCode: String?
    
    init(entity: UserProfileEntity, loginByFacebook: Bool) {
        self.loginByFacebook = loginByFacebook
        self.user = UserProfile(entity: entity)
        self.accessToken = Components.sessionService.accessToken
    }
    
    init(user: UserProfile, loginByFacebook: Bool) {
        self.loginByFacebook = loginByFacebook
        self.user = user
        self.accessToken = Components.sessionService.accessToken
    }
    
    init(accessToken: String) {
        // init temp user
        // When we login in, we must do
        //  - login gigya
        //  - login MBC
        //  - get account info from MBC API, need accessToken after login MBC,
        //  this step will save the accessToken to run this API, if it had faild when running this API,
        //  we'd remove the local session.
        self.loginByFacebook = false
        self.user = UserProfile()
        self.accessToken = accessToken
    }
}
