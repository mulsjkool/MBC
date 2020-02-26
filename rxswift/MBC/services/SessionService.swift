//
//  SessionService.swift
//  F8
//
//  Created by Dao Le Quang on 10/25/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift

protocol SessionService {
    var currentUser: Variable<UserProfile?> { get }
    
    var accessToken: String? { get }
    
    var deviceToken: String? { get set }
    
    var countryCode: String { get }
    
    var headerContryCode: String? { get set }
    
    func currentSession() -> Session?
    
    func isSessionValid() -> Bool
    
    func isLoginByFacebook() -> Bool
    
    func updateSession(session: Session)
    
    func updateUser(user: UserProfile)
    
    func clear()
}
