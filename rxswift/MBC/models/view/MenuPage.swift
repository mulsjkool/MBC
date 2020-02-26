//
//  Page.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/1/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class MenuPage: Codable {
    let id: String
    let title: String
    let logo: String
    let posterUrl: String
    let externalUrl: String

    init(entity: PageEntity) {
        self.id = entity.id
        self.title = entity.title
        self.logo = entity.logo
        self.externalUrl = entity.externalUrl
        self.posterUrl = entity.posterUrl
    }
    
    init(pageDetail: PageDetail) {
        self.id = pageDetail.entityId
        self.title = pageDetail.title
        self.logo = pageDetail.logoThumbnail
        self.posterUrl = pageDetail.posterThumbnail
        self.externalUrl = pageDetail.universalUrl
    }
}
