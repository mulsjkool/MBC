//
//  ActivityCard.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ActivityCard: Codable {
    var activityCardMessagePackage: ActivityCardMessagePackage?
    var authorPage: Author?
    var taggedPageList: [Author]?
    var firstTimePublish: Bool = false
    
    init(entity: ActivityCardEntity) {
        if let activityCardMessagePackageEntity = entity.activityCardMessagePackage {
            self.activityCardMessagePackage = ActivityCardMessagePackage(entity: activityCardMessagePackageEntity)
        }
        if let authorPageEntity = entity.authorPage {
            self.authorPage = Author(entity: authorPageEntity)
        }
        if let taggedPageEntityList = entity.taggedPageList {
            self.taggedPageList = taggedPageEntityList.map({ authorEntity -> Author in
                return Author(entity: authorEntity)
            })
        }
        self.firstTimePublish = entity.firstTimePublish
    }
}
