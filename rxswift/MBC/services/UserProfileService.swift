//
//  UserProfileService.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

protocol UserProfileService {
    func updateUserProfile(user: UserProfile?, type: ProfileItemEnum)
    func updateUserAvatar(user: UserProfile?, image: UIImage)
    func refreshAccountInfo()
    
    var onUpdateUserProfileSuccess: Observable<UserProfile?> { get }
    var onUpdateUserProfileError: Observable<Error> { get }
    
    var onUpdateUserAvatarSuccess: Observable<UserProfile?> { get }
    var onUpdateUserAvatarError: Observable<Error> { get }
    
    var onGetUserProfileSuccess: Observable<UserProfile?> { get }
    var onGetUserProfileError: Observable<Error> { get }
}
