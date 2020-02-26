//
//  ChannelEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class SchedulerChannelEntity: PageEntity {
    var publishedDate: Date?
    
    init(pageEntity: PageEntity) {
        super.init(id: pageEntity.id, title: pageEntity.title, logo: pageEntity.logo,
                   externalUrl: pageEntity.externalUrl, gender: pageEntity.gender,
                   accentColor: pageEntity.accentColor, posterUrl: pageEntity.posterUrl)
    }
}
