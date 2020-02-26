//
//  AnalyticsContent.swift
//  MBC
//
//  Created by Tram Nguyen on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsContent: BaseAnalyticsTracking {

    private let contentUuid: String
    private let articlePublicationDate: Double
    private let articleSource: String
    private let contentType: String
    private let author: String
    private let interestTags: String
    private let universalAddress: String
    private let contentStream: String

    init(feed: Feed, index: Int = 0) {
        self.contentUuid = feed.uuid ?? ""
        self.articlePublicationDate = feed.publishedDate?.milliseconds ?? 0
        if let post = feed as? Post {
            let mediasSource = post.medias?.map { $0.sourceLabel ?? "" }.filter { !$0.isEmpty } ?? []
            self.articleSource = mediasSource.joined(separator: ",")
        } else if let article = feed as? Article {
            let sourceLabel = article.photo?.sourceLabel ?? ""
            let photoSource = sourceLabel.isEmpty ? [] : [sourceLabel]
            let mediasSource = article.paragraphs?.map { $0.media?.sourceLabel ?? "" }.filter { !$0.isEmpty } ?? []
            let videosSource = article.paragraphs?.map { $0.video?.sourceLabel ?? "" }.filter { !$0.isEmpty } ?? []
            self.articleSource = (photoSource + mediasSource + videosSource).joined(separator: ",")
        } else {
            self.articleSource = ""
        }
        self.contentType = feed.subType ?? feed.type
        self.author = feed.author?.name ?? ""
        self.interestTags = feed.interests?.map { $0.name }.joined(separator: ",") ?? ""
        self.universalAddress = feed.universalUrl ?? ""
        self.contentStream = index == 0 ? "" : "scroll\((index + 1))"
    }

    init(media: Media, author: String, index: Int) {
        self.contentUuid = media.uuid
        self.articlePublicationDate = media.publishedDate.milliseconds
        self.articleSource = media.sourceLabel ?? ""
        self.contentType = media.contentType
        self.author = author
        self.interestTags = media.interests?.map { $0.name }.joined(separator: ",") ?? ""
        self.universalAddress = media.universalUrl
        self.contentStream = index == 0 ? "" : "scroll\((index + 1))"
    }

}

extension AnalyticsContent: IAnalyticsTrackingObject {

    var contendID: String? {
        return contentUuid
    }

    var eventName: String {
        return AnalyticsEventName.pageView.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.content.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsOtherVariable.pageAddress.rawValue: universalAddress,
                       AnalyticsContentVariable.streamPageAddress.rawValue: contentStream,
                       AnalyticsContentVariable.articlePublicationDate.rawValue: articlePublicationDate,
                       AnalyticsContentVariable.articleSource.rawValue: articleSource,
                       AnalyticsContentVariable.articleType.rawValue: contentType,
                       AnalyticsContentVariable.author.rawValue: author,
                       AnalyticsContentVariable.interestTags.rawValue: interestTags,
                       AnalyticsContentVariable.contentID.rawValue: contentUuid
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [AnalyticsOtherVariable.screenPath.rawValue: universalAddress,
                AnalyticsOtherVariable.screenAddress.rawValue: universalAddress,
                "cnt_contentID": contentUuid,
                "cnt_contentType": contentType,
                "cnt_interest": interestTags,
                "cnt_author": author
        ]
    }

}
