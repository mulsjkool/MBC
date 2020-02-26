//
//  PageInforJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import SwiftyJSON
import UIKit

class PageInforJsonTransformer: JsonTransformer {
    private let paragraphImageTransformer: ParagraphImageTransformer
    private let videoJsonTransformer: VideoJsonTransformer
    
    init(paragraphImageTransformer: ParagraphImageTransformer, videoJsonTransformer: VideoJsonTransformer) {
        self.paragraphImageTransformer = paragraphImageTransformer
        self.videoJsonTransformer = videoJsonTransformer
    }
    
    private static let fields = (
        type: "type",
        language: "language",
        customURL: "customURL",
        posterThumbnail: "posterThumbnail",
        website: "website",
        coverThumbnail: "coverThumbnail",
        internalUniquePageName: "internalUniquePageName",
        title: "title",
        logoThumbnail: "logoThumbnail",
        posterURL: "posterURL",
        coverURL: "coverURL",
        logoURL: "logoURL",
        geoTargeting: "geoTargeting",
        geoSuggestions: "geoSuggestions",
        
        promoVideo: "promoVideo",
        universalUrl: "universalUrl",
        video: "video"
    )

    private func getThumbnailUrl(from json: JSON, resolution: ImageResolution = .original) -> String {
        let decoder = JSONDecoder()
        do {
            let media = try decoder.decode(MediaEntity.self, from: json.rawData())
            if resolution == .original {
                return media.link
            }
            return ImageHelper.shared.thumbnailImageURL(from: Media(entity: media),
                                                        resolution)?.absoluteString ?? media.link
        } catch {
            //print("error trying to convert data to JSON")
            //print(error)
        }

        return ""
    }

    func transform(json: JSON) -> PageInforEntity {
        let fields = PageInforJsonTransformer.fields

        let type = json[fields.type].stringValue
        let language = json[fields.language].stringValue
        let customURL = json[fields.customURL].stringValue
        let posterThumbnail = json[fields.posterThumbnail].string ?? getThumbnailUrl(from: json[fields.posterURL])
        let website = json[fields.website].stringValue
        let coverThumbnail = json[fields.coverThumbnail].string ?? getThumbnailUrl(from: json[fields.coverURL])
        let internalUniquePageName = json[fields.internalUniquePageName].stringValue
        let title = json[fields.title].stringValue
        let logoThumbnail = json[fields.logoThumbnail].string ?? getThumbnailUrl(from: json[fields.logoURL])
        let geoTargeting = json[fields.geoTargeting].string ?? ""
        
        var geoSuggestions = [String]()
        if let geoSuggestionsJSON = json[fields.geoSuggestions].array {
            geoSuggestions = geoSuggestionsJSON.map({ $0.string ?? "" })
        }
        
        let poster = json[fields.posterURL] == JSON.null ? nil :
            paragraphImageTransformer.transform(json: json[fields.posterURL])
        
        let promoVideo = json[fields.promoVideo][fields.video] == JSON.null ? nil :
            videoJsonTransformer.transform(json: json[fields.promoVideo][fields.video])
        promoVideo?.universalUrl = json[fields.universalUrl].string ?? ""
        
        return PageInforEntity(type: type, language: language, customURL: customURL, posterThumbnail: posterThumbnail,
                               website: website, coverThumbnail: coverThumbnail,
                               internalUniquePageName: internalUniquePageName, title: title,
                               logoThumbnail: logoThumbnail, poster: poster, promoVideo: promoVideo,
                               geoTargeting: geoTargeting, geoSuggestions: geoSuggestions)
    }
}
