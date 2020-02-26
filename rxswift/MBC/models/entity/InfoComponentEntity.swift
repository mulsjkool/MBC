//
//  InfoComponentEntity.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class InfoComponentEntity {
    
    var entityId: String
    var type: String
    var aboveMetadata: Bool
    var title: String
    var showDataOnStream: Bool
    var showSubtypeOnFO: Bool
    var showCurrentPageMetadata: Bool
    var infoComponentElements: [InfoComponentElementEntity]?
    
    init(entityId: String, type: String, aboveMetadata: Bool, title: String, showDataOnStream: Bool,
         showSubtypeOnFO: Bool, showCurrentPageMetadata: Bool, infoComponentElements: [InfoComponentElementEntity]?) {
        self.entityId = entityId
        self.type = type
        self.title = title
        self.aboveMetadata = aboveMetadata
        self.showDataOnStream = showDataOnStream
        self.showSubtypeOnFO = showSubtypeOnFO
        self.showCurrentPageMetadata = showCurrentPageMetadata
        self.infoComponentElements = infoComponentElements
    }
}
