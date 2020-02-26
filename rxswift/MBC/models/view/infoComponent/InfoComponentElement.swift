//
//  InfoComponentElement.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class InfoComponentElement: Codable {
    
    var entityId: String
    var linkedPageSubType: String
    var linkedPageEntityId: String
    var linkedPage: Page
    var linkedPageDisplayName: String
    var linkedType: String // Enum
    var linkedValue: LinkedValue?
    var linkedCharacterPageEntityId: String
    var linkedCharacterPage: LinkedCharacterPage?
    var linkedCharacterPageDisplayName: String
    
    init(entity: InfoComponentElementEntity) {
        self.entityId = entity.entityId
        self.linkedPageSubType = entity.linkedPageSubType
        self.linkedPageEntityId = entity.linkedPageEntityId
        
        let pageEntity = FeedEntity(type: FeedType.page.rawValue)
        pageEntity.id = entity.linkedPage.id
        pageEntity.universalUrl = entity.linkedPage.externalUrl
        pageEntity.name = entity.linkedPage.title
        linkedPage = Page(entity: pageEntity)
        linkedPage.gender = Gender(rawValue: entity.linkedPage.gender)
        linkedPage.pageSubType = entity.linkedPageSubType
        linkedPage.poster = Media(withImageUrl: entity.linkedPage.posterUrl)
        
        self.linkedPageDisplayName = entity.linkedPageDisplayName
        self.linkedType = entity.linkedType
        self.linkedValue = entity.linkedValue == nil ? nil : LinkedValue(entity: entity.linkedValue!)
        self.linkedCharacterPageEntityId = entity.linkedCharacterPageEntityId
        self.linkedCharacterPage = entity.linkedCharacterPage == nil ? nil :
            LinkedCharacterPage(entity: entity.linkedCharacterPage!)
        self.linkedCharacterPageDisplayName = entity.linkedCharacterPageDisplayName
    }
    
}
