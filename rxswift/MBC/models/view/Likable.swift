//
//  Likable.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/12/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class Likable: Codable {
    var liked: Bool = false
    var contentId: String?
    var contentType: String
    
    // to exclude other fields from Codable
    private enum CodingKeys: String, CodingKey {
        case liked
        case contentId
        case contentType
    }
    
    var onToggleLikeSubject = PublishSubject<Likable>()
    var didReceiveLikeStatus = PublishSubject<Bool>()
    private let delay = RxTimeInterval(Components.instance.configurations.likeDelay)
    private let bag = DisposeBag()
    private let socialService = Components.userSocialService
    private let sessionRepository = Components.sessionRepository
    
    init(liked: Bool, contentId: String?, contentType: String) {
        self.liked = liked
        self.contentId = contentId
        self.contentType = contentType
        
        guard let contId = contentId, let user = sessionRepository.currentSession?.user else { return }
        let userId = user.uid
        
        onToggleLikeSubject.debounce(delay, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] likable in
                let data = UserSocial(userId: userId, contentId: contId, contentType: contentType)
                if likable.liked {
                    self.socialService.like(data: data).subscribe().disposed(by: self.bag)
                } else {
                    self.socialService.unlike(data: data).subscribe().disposed(by: self.bag)
                }
            }).disposed(by: bag)
    }
    
    func updateLikeStatus() {
        onToggleLikeSubject.onNext(self)
    }
}
