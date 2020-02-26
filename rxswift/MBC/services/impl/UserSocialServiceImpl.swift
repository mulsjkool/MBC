//
//  UserSocialServiceImpl.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class UserSocialServiceImpl: UserSocialService {
    private let socialApi: UserSocialApi
    private let commentApi: CommentApi
    var onLikedFeed: Observable<String> { return onLikedFeedSubject.asObservable() }
    var onUnlikedFeed: Observable<Void> { return onUnlikedFeedSubject.asObservable() }
    var onDeletedFeed: Observable<String> { return onDeletedFeedSubject.asObservable() }
    var onActionDeletedFeed: Observable<String> { return onActionDeletedFeedSubject.asObservable() }
    
    // Subject
    private var onLikedFeedSubject = PublishSubject<String>()
    private var onUnlikedFeedSubject = PublishSubject<Void>()
    private var onDeletedFeedSubject = PublishSubject<String>()
    private var onActionDeletedFeedSubject = PublishSubject<String>()
    
    init(userSocialApi: UserSocialApi, commentApi: CommentApi) {
        self.socialApi = userSocialApi
        self.commentApi = commentApi
        setupRx()
    }
    
    func like(data: UserSocial) -> Observable<String> {
        return socialApi.like(data: data)
            .do(onNext: { [unowned self] contentId in
                // contentId should be equal to data.contentId
                self.onLikedFeedSubject.onNext(contentId)
                }, onError: { [unowned self] error in
                    if let error = error as? SocialError, error == .feedWasDeleted {
                        self.onDeletedFeedSubject.onNext(data.contentId)
                        self.onActionDeletedFeedSubject.onNext(data.contentId)
                    }
            })
    }
    
    func unlike(data: UserSocial) -> Observable<Void> {
        return socialApi.unlike(data: data)
            .do(onNext: { [unowned self] _ in
                // contentId should be equal to data.contentId
                self.onUnlikedFeedSubject.onNext(())
                }, onError: { [unowned self] error in
                    if let error = error as? SocialError, error == .feedWasDeleted {
                        self.onDeletedFeedSubject.onNext(data.contentId)
                        self.onActionDeletedFeedSubject.onNext(data.contentId)
                    }
            })
    }
    
    func getLikeStatus(ids: [String]) -> Observable<[(id: String?, liked: Bool?)]> {
        return socialApi.getLikeStatus(ids: ids)
    }
    
    private func setupRx() {
        // TO BE ADDED MORE
    }
    
    func getComments(data: CommentSocial) -> Observable<[Comment]> {
        return commentApi.getCommentsFrom(data: data)
            .map { $0.map { Comment(entity: $0) } }
            .map { $0.sorted { $0.publishedDate!.timeIntervalSinceNow > $1.publishedDate!.timeIntervalSinceNow } }
    }
        
    func sendComments(data: CommentData) -> Observable<Comment> {
        return commentApi.sendComment(data: data).map { Comment(entity: $0) }
    }
    
    func removeComment(data: Comment) -> Observable<Void> {
        return commentApi.removeComment(data: data)
    }
}
