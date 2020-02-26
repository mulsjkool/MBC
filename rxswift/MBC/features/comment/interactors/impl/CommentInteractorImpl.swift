//
//  CommentInteractorImpl.swift
//  MBC
//
//  Created by Tri Vo on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class CommentInteractorImpl: CommentInteractor {
    
    private let socialService = Components.userSocialService
    private let sessionRepository = Components.sessionRepository
    
    func getComments(data: CommentSocial) -> Observable<[Comment]> {
        return self.socialService.getComments(data: data)
    }
    
    func getCurrentUser() -> UserProfile? {
        return sessionRepository.currentSession?.user
    }
}
