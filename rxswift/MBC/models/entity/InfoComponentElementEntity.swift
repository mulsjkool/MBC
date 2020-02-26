//
//  InfoComponentElementEntity.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class InfoComponentElementEntity {
    
    var entityId: String
    var linkedPageSubType: String
    var linkedPageEntityId: String
    var linkedPage: PageEntity
    var linkedPageDisplayName: String
    var linkedType: String
    var linkedValue: LinkedValueEntity?
    var linkedCharacterPageEntityId: String
    var linkedCharacterPage: LinkedCharacterPageEntity?
    var linkedCharacterPageDisplayName: String
    var reverseLinkedType: String
    var reverseLinkedValue: LinkedValueEntity?
    var reverseLinkedPageEntityId: String
    var reverseLinkedPage: LinkedCharacterPageEntity?
    var reverseLinkedPageDisplayName: String
    
    init(entityId: String, linkedPageSubType: String, linkedPageEntityId: String, linkedPage: PageEntity,
         linkedPageDisplayName: String, linkedType: String, linkedValue: LinkedValueEntity?,
         linkedCharacterPageEntityId: String, linkedCharacterPage: LinkedCharacterPageEntity?,
         linkedCharacterPageDisplayName: String, reverseLinkedType: String,
         reverseLinkedValue: LinkedValueEntity?, reverseLinkedPageEntityId: String,
         reverseLinkedPage: LinkedCharacterPageEntity?, reverseLinkedPageDisplayName: String) {
        
        self.entityId = entityId
        self.linkedPageSubType = linkedPageSubType
        self.linkedPageEntityId = linkedPageEntityId
        self.linkedPage = linkedPage
        self.linkedPageDisplayName = linkedPageDisplayName
        self.linkedType = linkedType
        self.linkedValue = linkedValue
        self.linkedCharacterPageEntityId = linkedCharacterPageEntityId
        self.linkedCharacterPage = linkedCharacterPage
        self.linkedCharacterPageDisplayName = linkedCharacterPageDisplayName
        self.reverseLinkedType = reverseLinkedType
        self.reverseLinkedValue = reverseLinkedValue
        self.reverseLinkedPageEntityId = reverseLinkedPageEntityId
        self.reverseLinkedPage = reverseLinkedPage
        self.reverseLinkedPageDisplayName = reverseLinkedPageDisplayName
    }
}
