//
//  PhysicalPage.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class PhysicalPage {
    var id: String
    var publishedDate: Date?
    var type: String?
    var hasTag2Page: Bool
    var numberOfLikes: Int?
    var numberOfComments: Int?
    var universalUrl: String?
    var liked: Bool
    var interests: [Interest]?
    var info: PageInfo
    var setting: PageSettings
    var content: App
    
    init(entity: PhysicalPageEntity) {
        self.id = entity.id
        self.publishedDate = entity.publishedDate
        self.type = entity.type
        self.numberOfLikes = entity.numberOfLikes
        self.numberOfComments = entity.numberOfComments
        self.universalUrl = entity.universalUrl
        self.liked = entity.liked
        self.info = PageInfo(entity: entity.info)
        self.setting = PageSettings(entity: entity.setting)
        self.content = App(entity: entity.content)
        self.interests = entity.interests.map {
            var ps = [Interest]()
            for p in $0 {
                ps.append(Interest(entity: p))
            }
            return ps
        }
        self.hasTag2Page = entity.hasTag2Page
    }
    
}
