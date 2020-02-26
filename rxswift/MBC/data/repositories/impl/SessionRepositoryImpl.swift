//
//  SessionRepositoryImpl.swift
//  F8
//
//  Created by Dao Le Quang on 10/28/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

class SessionRepositoryImpl: SessionRepository {
    private var userDefaults: UserDefaults
    
    private var storedSession: Session?
    
    private let sessionKey = "key.user_defaults.session"
    private let encodedDataKey = "key.user_defaults.encodedData"
    private let lastStoredTimeKey = "key.user_defaults.lastStoredTime"
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        if let dictionary = userDefaults.dictionary(forKey: sessionKey) {
            if let encodedData = dictionary[encodedDataKey] as? Data {
                let session = try? JSONDecoder().decode(Session.self, from: encodedData)
                storedSession = session
            }
        }
    }
    
    var currentSession: Session? {
        return storedSession
    }
    
    func updateSession(session: Session) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(session) {
            let dictionary = [encodedDataKey: encodedData,
                              lastStoredTimeKey: Date().timeIntervalSince1970] as [String: Any]
            userDefaults.set(dictionary, forKey: sessionKey)
            userDefaults.synchronize()
        }
        storedSession = session
    }
    
    func clear() {
        userDefaults.set(nil, forKey: sessionKey)
        userDefaults.synchronize()
        
        storedSession = nil
    }
}
