//
//  Comment.swift
//  MBC
//
//  Created by Tri Vo on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class Comment: Codable {
    var commentId: String
    var message: String?
    var contentId: String?
    var contentType: String?
    var pageId: String?
    var status: String?
    var sitename: String?
    var publishedDate: Date?
    var author: Author?
    
    var isTextExpanded = false
    
    init(entity: CommentEntity) {
        self.commentId = entity.commentId
        self.message = entity.message
        self.contentId = entity.contentId
        self.contentType = entity.contentType
        self.pageId = entity.pageId
        self.status = entity.status
        self.sitename = entity.sitename
        self.publishedDate = entity.publishedDate
        
        if let author = entity.author { self.author = Author(entity: author) }
    }
}
