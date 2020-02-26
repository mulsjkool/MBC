//
//  UserSocialService.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserSocialService {
    var onLikedFeed: Observable<String> { get }
    var onUnlikedFeed: Observable<Void> { get }
    
    func like(data: UserSocial) -> Observable<String>
    func unlike(data: UserSocial) -> Observable<Void>
    func getLikeStatus(ids: [String]) -> Observable<[(id: String?, liked: Bool?)]>
    
    func getComments(data: CommentSocial) -> Observable<[Comment]>
    func sendComments(data: CommentData) -> Observable<Comment>
    func removeComment(data: Comment) -> Observable<Void>
}
