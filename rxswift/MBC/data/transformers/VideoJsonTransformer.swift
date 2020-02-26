//
//  VideoJsonTransformer.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoJsonTransformer: MediaJsonTransformer {
    let authorJsonTranformer: AuthorJsonTransformer
    private static let fields = (
        title : "title",
        rawFile : "rawFile",
        duration : "duration",
        url : "url",
        destinationUrl: "destinationUrl",
        videoThumbnail : "videoThumbnail",
        author: "author",
        contentId: "contentId",
        contentType: "contentType",
		adsUrl: "adsUrl"
    )
    
     init(authorJsonTranformer: AuthorJsonTransformer) {
        self.authorJsonTranformer = authorJsonTranformer
    }
    
    override func transform(json: JSON) -> VideoEntity {
        let fields = VideoJsonTransformer.fields
        let title = json[fields.title].string
        let rawFile = json[fields.rawFile].string
		let adsUrl = json[fields.adsUrl].string
        let destinationUrl = json[fields.destinationUrl].string
        let url = json[fields.url].string
        let videoThumbnail = json[fields.videoThumbnail].string
        var contentId: String?
        if json[fields.contentId] != JSON.null {
            contentId = json[fields.contentId].string
        }
        let author = authorJsonTranformer.transform(json: json[fields.author])
        var contentType: String?
        if json[fields.contentType] != JSON.null {
            contentType = json[fields.contentType].string
        }
		
		let duration = Common.convertDurationToSeconds(data: json[fields.duration].string)
        
        let mediaEntity = super.transform(json: json)
        let videoEntity = VideoEntity(id: mediaEntity.id, uuid: mediaEntity.uuid, description: mediaEntity.description,
                           sourceLink: mediaEntity.sourceLink, sourceLabel: mediaEntity.sourceLabel,
                           universalUrl: mediaEntity.universalUrl, label: mediaEntity.label,
                           interests: mediaEntity.interests, hasTag2Page: mediaEntity.hasTag2Page,
                           publishedDate: mediaEntity.publishedDate, tags: mediaEntity.tags, link: mediaEntity.link,
                           originalLink: mediaEntity.originalLink, numberOfLikes: mediaEntity.numberOfLikes,
                           numberOfComments: mediaEntity.numberOfComments, liked: mediaEntity.liked)
        videoEntity.title = title
        videoEntity.rawFile = rawFile
        videoEntity.duration = duration
        videoEntity.url = url ?? destinationUrl
        videoEntity.videoThumbnail = videoThumbnail
        videoEntity.author = author
        videoEntity.contentId = contentId
        videoEntity.contentType = contentType
		videoEntity.adsUrl = adsUrl
        return videoEntity
    }
}

class VideoPlaylistTransformer: JsonTransformer {
    
    let videoJsonTransformer: VideoJsonTransformer
    let listInterestJsonTransformer: ListInterestJsonTransformer
    
    init(videoJsonTransformer: VideoJsonTransformer, listInterestJsonTransformer: ListInterestJsonTransformer) {
        self.videoJsonTransformer = videoJsonTransformer
        self.listInterestJsonTransformer = listInterestJsonTransformer
    }
    
    private static let fields = (
        id : "id",
        publishedDate : "publishedDate",
        type : "type",
        hasTag2Page : "hasTag2Page",
        interests : "interests",
        title : "title",
        description : "description",
        label : "label",
        thumbnailUrl : "thumbnailUrl",
        videoList : "videoList",
        defaultVideo : "defaultVideo",
        numberOfLikes: "numberOfLikes",
        numberOfComments : "numberOfComments",
        total : "total"
        
    )
    
    func transform(json: JSON) -> VideoPlaylistEntity {
        let fields = VideoPlaylistTransformer.fields
        let id = json[fields.id].string
        let publishedDate = json[fields.publishedDate] == JSON.null ? nil :
            Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let type = json[fields.type].string
        let hasTag2Page = json[fields.hasTag2Page].bool
        let interests = json[fields.interests] == JSON.null ? nil :
            self.listInterestJsonTransformer.transform(json: json)
        let title = json[fields.title].string
        let description = json[fields.description].string
        let label = json[fields.label].string
        let thumbnailUrl = json[fields.thumbnailUrl].string
        var arrayVideo = [VideoEntity]()
        if let videoJsonArray = json[fields.videoList].array {
            for itemjson in videoJsonArray {
                arrayVideo.append(self.videoJsonTransformer.transform(json: itemjson))
            }
        }
        let defaultVideo = json[fields.defaultVideo] == JSON.null ? nil :
            self.videoJsonTransformer.transform(json: json[fields.defaultVideo])
        let total = json[fields.total].intValue
        let numberOfLikes = json[fields.numberOfLikes].intValue
        let numberOfComments = json[fields.numberOfComments].intValue
        
        let videoPlaylistEntity = VideoPlaylistEntity(id: id, publishedDate: publishedDate, type: type,
                                                      hasTag2Page: hasTag2Page, interests: interests,
                                                      title: title, description: description,
                                                      label: label, thumbnailUrl: thumbnailUrl,
                                                      videoList: arrayVideo, defaultVideo: defaultVideo, total: total,
                                                      numberOfComments: numberOfComments, numberOfLikes: numberOfLikes)
        return videoPlaylistEntity
    }
}

class ListVideoPlaylistTransformer: JsonTransformer {
    let videoPlaylistTransformer: VideoPlaylistTransformer
    
    init(videoPlaylistTransformer: VideoPlaylistTransformer) {
        self.videoPlaylistTransformer = videoPlaylistTransformer
    }
    
    func transform(json: JSON) -> [VideoPlaylistEntity] {
        return json.arrayValue.map { videoPlaylistTransformer.transform(json: $0) }
    }
}
