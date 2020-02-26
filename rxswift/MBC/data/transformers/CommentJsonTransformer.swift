//
//  CommentJsonTransformer.swift
//  MBC
//
//  Created by Tri Vo on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentJsonTransformer: JsonTransformer {
    let authorJsonTransformer: AuthorJsonTransformer
    
    private static let fields = (
        commentId: "id",
        message: "message",
        contentId: "contentId",
        contentType: "contentType",
        pageId: "pageId",
        status: "status",
        sitename: "siteName",
        publishedDate: "createdDate",
        author: "user"
    )
    
    init(authorJsonTransformer: AuthorJsonTransformer) {
        self.authorJsonTransformer = authorJsonTransformer
    }
    
    func transform(json: JSON) -> CommentEntity {
        let fields = CommentJsonTransformer.fields
        
        let commentId = json[fields.commentId].stringValue
        let message = json[fields.message].string
        let contentId = json[fields.contentId].string
        let contentType = json[fields.contentType].string
        let pageId = json[fields.pageId].string
        let status = json[fields.status].string
        let sitename = json[fields.sitename].string
        let publishedDate = json[fields.publishedDate] == JSON.null ? nil :
            Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let author = self.authorJsonTransformer.transform(json: json[fields.author])
        
        return CommentEntity(commentId: commentId, message: message, contentId: contentId,
                              contentType: contentType, pageId: pageId, status: status,
                              sitename: sitename, publishedDate: publishedDate, author: author)
    }
}

class ListCommentJsonTransformer: JsonTransformer {
    let commentJsonTransformer: CommentJsonTransformer
    
    init(commentJsonTransformer: CommentJsonTransformer) {
        self.commentJsonTransformer = commentJsonTransformer
    }
    
    func transform(json: JSON) -> [CommentEntity] {
        return json.arrayValue.map { commentJsonTransformer.transform(json: $0) }
    }
}

class AuthorCommentJsonTransformer: JsonTransformer {
    private static let fields = (
        authorId: "id",
        active: "active",
        authorName: "name",
        thumbnailUrl: "thumbnailUrl",
        accentColor: "accentColor"
    )
    
    func transform(json: JSON) -> AuthorEntity {
        let fields = AuthorCommentJsonTransformer.fields
        let authorId = json[fields.authorId].string ?? ""
        let active = json[fields.active].bool ?? false
        let authorName = json[fields.authorName].string ?? ""
        let thumbnailUrl = json[fields.thumbnailUrl].string ?? ""
        let accentColor = json[fields.accentColor].string
        
        return AuthorEntity(authorId: authorId, name: authorName, avatarUrl: thumbnailUrl, universalUrl: "",
                            active: active, gender: nil, accentColor: accentColor)
    }
}
