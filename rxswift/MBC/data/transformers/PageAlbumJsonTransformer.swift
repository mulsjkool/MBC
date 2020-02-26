//
//  PageAlbumJsonTransformer.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class PageAlbumJsonTransformer: JsonTransformer {
    let listMediaJsonTransformer: ListMediaJsonTransformer
    let mediaJsonTransformer: MediaJsonTransformer
    
    init(listMediaJsonTransformer: ListMediaJsonTransformer,
         mediaJsonTransformer: MediaJsonTransformer) {
        self.listMediaJsonTransformer = listMediaJsonTransformer
        self.mediaJsonTransformer = mediaJsonTransformer
    }
    
    private static let fields = (
        id: "id",
        mediaList: "mediaList",
        title: "title",
        description: "description",
        cover: "cover",
        publishedDate: "publishedDate",
        contentId: "contentId",
        total: "total",
        currentPosition: "currentPosition"
    )
    
    func transform(json: JSON) -> AlbumEntity {
        let fields = PageAlbumJsonTransformer.fields
        
        let id = json[fields.id].stringValue
        let mediaList = listMediaJsonTransformer.transform(json: json)
        let title = json[fields.title].string
        let description = json[fields.description].string
        let cover = json[fields.cover] == JSON.null ? nil : mediaJsonTransformer.transform(json: json[fields.cover])
        let publishedDate = Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let contentId = json[fields.contentId].string
        let total = json[fields.total].intValue
        let currentPosition = json[fields.currentPosition].intValue
        
        return AlbumEntity(id: id, mediaList: mediaList, title: title,
                           description: description, cover: cover, publishedDate: publishedDate,
                           contentId: contentId, total: total, currentPosition: currentPosition)
    }
}

class ListMediaJsonTransformer: JsonTransformer {
    let mediaJsonTransformer: MediaJsonTransformer
    
    init(mediaJsonTransformer: MediaJsonTransformer) {
        self.mediaJsonTransformer = mediaJsonTransformer
    }
    
    func transform(json: JSON) -> [MediaEntity] {
        return json["mediaList"].arrayValue.map { mediaJsonTransformer.transform(json: $0) }
    }
}

class MediaJsonTransformer: JsonTransformer {
    private static let fields = (
        id: "id",
        uuid: "uuid",
        description: "description",
        sourceLink: "sourceLink",
        sourceLabel: "sourceLabel",
        universalUrl: "universalUrl",
        label: "label",
        interests: "interests",
        hasTag2Page: "hasTag2Page",
        publishedDate: "publishedDate",
        tags: "tags",
        link: "link",
        originalLink: "originalLink",
        numberOfLikes: "numberOfLikes",
        numberOfComments: "numberOfComments",
        liked: "liked"
    )
    
    func transform(json: JSON) -> MediaEntity {
        let fields = MediaJsonTransformer.fields
        
        let id = json[fields.id].stringValue
        let uuid = json[fields.uuid].stringValue
        let description = json[fields.description].string
        let sourceLink = json[fields.sourceLink].string
        let sourceLabel = json[fields.sourceLabel].string
        let universalUrl = json[fields.universalUrl].stringValue
        let label = json[fields.label].string
        // swiftlint:disable force_cast
        let interests = json[fields.interests].arrayObject?.map { InterestEntity(uuid: "", name: $0 as! String) }
        let hasTag2Page = json[fields.hasTag2Page].boolValue
        let publishedDate = json[fields.publishedDate].doubleValue
        let tags = json[fields.tags].string
        let link = json[fields.link].stringValue
        let originalLink = json[fields.originalLink].stringValue
        let numberOfLikes = json[fields.numberOfLikes].intValue
        let numberOfComments = json[fields.numberOfComments].intValue
        let liked = json[fields.liked].boolValue
        
        return MediaEntity(id: id, uuid: uuid, description: description,
                           sourceLink: sourceLink, sourceLabel: sourceLabel, universalUrl: universalUrl,
                           label: label, interests: interests, hasTag2Page: hasTag2Page,
                           publishedDate: publishedDate, tags: tags, link: link, originalLink: originalLink,
                           numberOfLikes: numberOfLikes, numberOfComments: numberOfComments, liked: liked)
    }
}
