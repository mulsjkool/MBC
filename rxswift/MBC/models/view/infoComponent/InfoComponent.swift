//
//  InfoComponent.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class InfoComponent: Codable {
    var entityId: String
    var type: StreamPageType
    var aboveMetadata: Bool
    var title: String
    var showDataOnStream: Bool
    var showSubtypeOnFO: Bool
    var showCurrentPageMetadata: Bool
    var infoComponentElements: [InfoComponentElement]?
    
    init(entity: InfoComponentEntity) {
        self.entityId = entity.entityId
        self.type = StreamPageType(rawValue: entity.type) ?? .profile
        self.title = entity.title
        self.aboveMetadata = entity.aboveMetadata
        self.showDataOnStream = entity.showDataOnStream
        self.showSubtypeOnFO = entity.showSubtypeOnFO
        self.showCurrentPageMetadata = entity.showCurrentPageMetadata
        if let components = entity.infoComponentElements {
            self.infoComponentElements = components.map { InfoComponentElement(entity: $0) }
        }
    }
    
}
