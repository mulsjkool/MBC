//
//  ActivityCardEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ActivityCardEntity {
    var activityCardMessagePackage: ActivityCardMessagePackageEntity?
    var authorPage: AuthorEntity?
    var taggedPageList: [AuthorEntity]?
    var firstTimePublish: Bool = false
    
    init(activityCardMessagePackage: ActivityCardMessagePackageEntity?, authorPage: AuthorEntity?,
         taggedPageList: [AuthorEntity]?, firstTimePublish: Bool) {
        self.activityCardMessagePackage = activityCardMessagePackage
        self.authorPage = authorPage
        self.taggedPageList = taggedPageList
        self.firstTimePublish = firstTimePublish
    }
}
