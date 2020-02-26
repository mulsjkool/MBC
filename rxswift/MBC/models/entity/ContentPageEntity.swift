//
//  ContentPageEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ContentPageEntity {
    var redirectUrl: String?
    var type: String
    var pageDetail: PageDetailEntity?
    var content: FeedEntity?
    
    init(redirectUrl: String?, type: String, pageDetail: PageDetailEntity?, content: FeedEntity?) {
        self.redirectUrl = redirectUrl
        self.type = type
        self.pageDetail = pageDetail
        self.content = content
    }
}
