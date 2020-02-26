//
//  SearchSuggestionEntity.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class SearchSuggestionEntity: NSObject {
    var contentId: String
    var title: String
    var thumbnail: String?
    var metadata: String
    var universalUrl: String?
    var contentType: String
    var descriptionTitle: Bool
    var metadataMap: [String: Any]
    
    init(contentId: String, title: String, thumbnail: String?, metadata: String, universalUrl: String?,
         contentType: String, isDescriptionTitle: Bool, metadataMap: [String: Any]) {
        self.contentId = contentId
        self.title = title
        self.thumbnail = thumbnail
        self.metadata = metadata
        self.universalUrl = universalUrl
        self.contentType = contentType
        self.descriptionTitle = isDescriptionTitle
        self.metadataMap = metadataMap
    }
}
