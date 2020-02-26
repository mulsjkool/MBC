//
//  SearchSuggestion.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class SearchSuggestion {
    let contentId: String
    let title: String
    let thumbnail: String?
    let metadata: String
    let universalUrl: String?
    let descriptionTitle: Bool
    let contentType: SearchSuggestionContentType?
    let metadataMap: [String: Any]
    
    init(entity: SearchSuggestionEntity) {
        self.contentId = entity.contentId
        self.title = entity.title
        self.thumbnail = entity.thumbnail
        self.metadata = entity.metadata
        self.universalUrl = entity.universalUrl
        self.descriptionTitle = entity.descriptionTitle
        self.contentType = SearchSuggestionContentType(rawValue: entity.contentType)
        self.metadataMap = entity.metadataMap
    }
}
