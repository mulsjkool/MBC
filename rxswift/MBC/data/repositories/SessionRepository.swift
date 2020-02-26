//
//  SessionRepository.swift
//  F8
//
//  Created by Dao Le Quang on 10/28/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

protocol SessionRepository {
    
    var currentSession: Session? { get }
    
    func updateSession(session: Session)

    func clear()
}
