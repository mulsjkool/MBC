//
//  SessionServiceImpl.swift
//  F8
//
//  Created by Dao Le Quang on 10/25/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift

class SessionServiceImpl: SessionService {
    
    var deviceToken: String?
    
    var headerContryCode: String?

    var currentUser = Variable<UserProfile?>(nil)

    private let sessionRepository: SessionRepository
    
    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
        
        if let session = self.sessionRepository.currentSession {
            currentUser.value = session.user
        }
    }
    
    func isSessionValid() -> Bool {
        return sessionRepository.currentSession != nil
    }
    
    func isLoginByFacebook() -> Bool {
        guard isSessionValid() else { return false }
        
        return sessionRepository.currentSession!.loginByFacebook
    }
    
    func currentSession() -> Session? {
        return sessionRepository.currentSession
    }
    
    func updateSession(session: Session) {
        sessionRepository.updateSession(session: session)
        currentUser.value = session.user
    }
    
    func updateUser(user: UserProfile) {
        currentUser.value = user
    }
    
    func clear() {
        sessionRepository.clear()
        currentUser.value = nil
    }
    
    var accessToken: String? {
        guard isSessionValid() else { return nil }
        
        return sessionRepository.currentSession!.accessToken
    }
    
    var countryCode: String {
        // 1. Get country code from user profile
        if let userCountry = Components.sessionRepository.currentSession?.user.country, !userCountry.isEmpty {
            return userCountry
        }
        
        // When country code can not get from (1)
        // 2. Get country code from header of API
        if let headerContryCode = Components.sessionService.headerContryCode,
            !headerContryCode.isEmpty { return headerContryCode }
        
        // When country code can not get from (2)
        // 3. Get country code from current locale of device
        guard let deviceRegion = NSLocale.current.regionCode else { return Constants.DefaultValue.defaultRegion }
        return IsoCountryCodes.find(key: deviceRegion).alpha3
    }
}
