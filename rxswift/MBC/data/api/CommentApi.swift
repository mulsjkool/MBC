//
//  CommentApi.swift
//  MBC
//
//  Created by Tri Vo on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

protocol CommentApi {
    func getCommentsFrom(data: CommentSocial) -> Observable<[CommentEntity]>
    func sendComment(data: CommentData) -> Observable<CommentEntity>
    func removeComment(data: Comment) -> Observable<Void>
}
