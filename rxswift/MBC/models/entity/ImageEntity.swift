//
//  ImageEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class ImageEntity {
    var id: String
    var uuid: String
    var url: String
    var universalUrl: String
    var hasTag2Page: Bool
    
    var description: String?
    var sourceLink: String?
    var sourceLabel: String?
    var label: String?
    var interests: [InterestEntity]?
    var publishedDate: Date
    var tags: String?
    var link: String
    var originalLink: String
    
    init(id: String, uuid: String, url: String, universalUrl: String, hasTag2Page: Bool,
         description: String?, sourceLink: String?, sourceLabel: String?,
         label: String?, interests: [InterestEntity]?, publishedDate: Date,
         tags: String?, link: String, originalLink: String) {
        self.id = id
        self.uuid = uuid
        self.url = url.isEmpty ? originalLink : url
        self.universalUrl = universalUrl
        self.hasTag2Page = hasTag2Page
        
        // Media
        self.description = description
        self.sourceLink = sourceLink
        self.sourceLabel = sourceLabel
        self.label = label
        self.interests = interests
        self.publishedDate = publishedDate
        self.tags = tags
        self.link = link
        self.originalLink = originalLink
    }
    
    func getResourceVersion() -> String {
        guard let range = url.range(of: Components.config.apiImageUrl) else {
            return Components.config.apiImageVersion
        }
        
        let path = url[range.upperBound...]
        guard let index = path.index(of: "/") else {
            return Components.config.apiImageVersion
        }
        return String(path[..<index])
    }
    
    func tryToGetMediaIdFromUrl() -> String {
        guard !url.isEmpty else { return "" }
    
        guard let range = url.range(of: Components.config.apiImageUrl) else {
            return ""
        }
    
        let path = url[range.upperBound...]
        guard let index = path.index(of: "/") else {
            return ""
        }
        let last = path[index...]
        guard let dot = last.index(of: ".") else {
            return ""
        }
        
        return String(last[..<dot])
    }
}
