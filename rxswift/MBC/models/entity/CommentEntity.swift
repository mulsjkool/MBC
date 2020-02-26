//
//  CommentEntity.swift
//  MBC
//
//  Created by Tri Vo on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class CommentEntity {
    var commentId: String
    var message: String?
    var contentId: String?
    var contentType: String?
    var pageId: String?
    var status: String?
    var sitename: String?
    var publishedDate: Date?
    var author: AuthorEntity?
    
    init(commentId: String, message: String?, contentId: String?, contentType: String?,
         pageId: String?, status: String?, sitename: String?, publishedDate: Date?, author: AuthorEntity?) {
        self.commentId = commentId
        self.message = message
        self.contentId = contentId
        self.contentType = contentType
        self.pageId = pageId
        self.status = status
        self.sitename = sitename
        self.publishedDate = publishedDate
        self.author = author
    }
}
