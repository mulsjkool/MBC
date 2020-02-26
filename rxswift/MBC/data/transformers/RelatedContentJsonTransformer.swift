//
//  RelatedContentJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class RelatedContentJsonTransformer: JsonTransformer {
    let pageJsonTransformer: PageJsonTransformer
    let mediaJsonTransformer: MediaJsonTransformer
    let videoJsonTransformer: VideoJsonTransformer
    
    init(pageJsonTransformer: PageJsonTransformer, mediaJsonTransformer: MediaJsonTransformer,
         videoJsonTransformer: VideoJsonTransformer) {
        self.pageJsonTransformer = pageJsonTransformer
        self.mediaJsonTransformer = mediaJsonTransformer
        self.videoJsonTransformer = videoJsonTransformer
    }
    
    private static let fields = (
        description : "description",
        page : "page",
        image : "image",
        articlePhoto: "articlePhoto",
        label : "label",
        photo: "photo",
        video: "video",
        whitePageUrl: "whitePageUrl"
    )
    
    func transform(json: JSON) -> RelatedContentEntity {
        let fields = RelatedContentJsonTransformer.fields
        let description = json[fields.description].string
        let page = (json[fields.page] != JSON.null) ? pageJsonTransformer.transform(json: json[fields.page]) : nil
        var photo = (json[fields.image] != JSON.null) ? mediaJsonTransformer.transform(json: json[fields.image]) : nil
        if photo == nil {
            photo = (json[fields.articlePhoto] != JSON.null)
                ? mediaJsonTransformer.transform(json: json[fields.articlePhoto]) : nil
        }
        let label = json[fields.label].string
        let appPhotoUrl = json[fields.photo].string
        let video = (json[fields.video] != JSON.null) ? videoJsonTransformer.transform(json: json[fields.video]) : nil
        let whitePageUrl = json[fields.whitePageUrl].string

        return RelatedContentEntity(description: description, page: page, photo: photo, label: label,
                                    appPhotoUrl: appPhotoUrl, video: video, whitePageUrl: whitePageUrl)
    }
}
