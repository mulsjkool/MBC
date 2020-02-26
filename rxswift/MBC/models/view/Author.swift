//
//  Author.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class Author: Codable {
    var authorId: String
    let active: Bool
    let name: String
    let avatarUrl: String
    let universalUrl: String
    let gender: String?
    let accentColor: String?
    
    init(pageDetail: PageDetail) {
        self.authorId = pageDetail.entityId
        self.active = true
        self.name = pageDetail.title
        self.avatarUrl = pageDetail.posterThumbnail
        self.universalUrl = pageDetail.universalUrl
        self.gender = nil
        self.accentColor = pageDetail.pageSettings.accentColor
    }
    
    init(pageEntity: PageEntity) {
        self.authorId = pageEntity.id
        self.active = true
        self.name = pageEntity.title
        self.avatarUrl = pageEntity.logo
        self.universalUrl = pageEntity.externalUrl
        self.gender = nil
        self.accentColor = pageEntity.accentColor
    }
    
    init(entity: AuthorEntity) {
        self.authorId = entity.authorId
        self.active = entity.active
        self.name = entity.name
        self.avatarUrl = entity.avatarUrl
        self.universalUrl = entity.universalUrl
        self.gender = entity.gender
        self.accentColor = entity.accentColor
    }
}
