//
//  CommentApiImpl.swift
//  MBC
//
//  Created by Tri Vo on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class CommentApiImpl: BaseApiClient<[CommentEntity]>, CommentApi {
    
    let commentsTransformer: (JSON) -> [CommentEntity]
    let sendCommentTransformer: (JSON) -> CommentEntity
    
    init(apiClient: ApiClient, commentsTransformer: @escaping (JSON) -> [CommentEntity],
         sendCommentTransformer: @escaping (JSON) -> CommentEntity) {
        self.commentsTransformer = commentsTransformer
        self.sendCommentTransformer = sendCommentTransformer
        super.init(apiClient: apiClient, jsonTransformer: commentsTransformer)
    }
    
    private static let getCommentsPath = "/social-activities/comments/%@"
    
    func getCommentsFrom(data: CommentSocial) -> Observable<[CommentEntity]> {
        return apiClient.get(String(format: CommentApiImpl.getCommentsPath, data.contentId),
							 parameters: ["userId": data.userId, "siteName": data.siteName,
										  "fromIndex": data.fromIndex, "size": data.size],
                             errorHandler: { _, error -> Error in return error },
                             parse: commentsTransformer)
    }
    
    private static let createCommentPath = "/social-activities/comments"
    private static let commentFields = (
        data: "data",
        user: "user",
        id: "id",
        name: "name",
        thumbnailURL: "thumbnailURL",
        contentId: "contentId",
        contentType: "contentType",
        message: "message",
        pageId: "pageId"
    )
    
    func sendComment(data: CommentData) -> Observable<CommentEntity> {
        let fields = CommentApiImpl.commentFields
        let user: [String: Any] = [
            fields.id: data.userId,
            fields.name: data.userName,
            fields.thumbnailURL: data.thumbnailURL
        ]
        let data: [String: Any] = [
            fields.contentId: data.contentId,
            fields.contentType: data.contentType,
            fields.message: data.message,
            fields.pageId: data.pageId,
            fields.user: user
        ]
        let params: [String: Any] = [
            fields.data: data
        ]
        return apiClient.post(CommentApiImpl.createCommentPath,
                              parameters: params,
                              errorHandler: { _, error -> Error in return error },
                              parse: sendCommentTransformer)
    }
    
    private static let deleteCommentPath = "/social-activities/comments/%@/%@/%@/%@"
    
    func removeComment(data: Comment) -> Observable<Void> {
        return apiClient.delete(String(format: CommentApiImpl.deleteCommentPath,
                                       data.commentId, data.contentId!, data.author!.authorId, data.contentType!),
                                parameters: nil,
                                errorHandler: { _, error -> Error in return error },
                                parse: { _ -> Void in })
    }
}
