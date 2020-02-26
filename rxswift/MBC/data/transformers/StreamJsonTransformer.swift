//
//  StreamJsonTransformer.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class StreamJsonTransformer: JsonTransformer {
    let listFeedJsonTransformer: ListFeedJsonTransformer
    
    init(listFeedJsonTransformer: ListFeedJsonTransformer) {
        self.listFeedJsonTransformer = listFeedJsonTransformer
    }
    
    private static let fields = ( items: "items", total: "total" )
    
    func transform(json: JSON) -> StreamEntity {
        let fields = StreamJsonTransformer.fields
        
        let items = (json[fields.items] != JSON.null) ? listFeedJsonTransformer.transform(json: json[fields.items])
            : nil
        let total = json[fields.total].int
        
        return StreamEntity(items: items, total: total)
    }
}

class ListFeedJsonTransformer: JsonTransformer {
    let feedJsonTransformer: FeedJsonTransformer
    
    init(feedJsonTransformer: FeedJsonTransformer) {
        self.feedJsonTransformer = feedJsonTransformer
    }
    
    func transform(json: JSON) -> [FeedEntity] {
        return json.arrayValue.map { feedJsonTransformer.transform(json: $0) }
    }
}

class FeedJsonTransformer: JsonTransformer {
    let listParagraphJsonTransformer: ListParagraphJsonTransformer
    let listInterestJsonTransformer: ListInterestJsonTransformer
    let authorJsonTransformer: AuthorJsonTransformer
    let pageJsonTransformer: PageJsonTransformer
    let relatedContentJsonTransformer: RelatedContentJsonTransformer
    let propertiesJsonTransformer: PropertiesJsonTransformer
    let activityCardJsonTransformer: ActivityCardJsonTransformer
    let bundleItemJsonTransformer: BundleItemJsonTransformer
    let videoJsonTransformer: VideoJsonTransformer
    
    init(listParagraphJsonTransformer: ListParagraphJsonTransformer,
         listInterestJsonTransformer: ListInterestJsonTransformer,
         authorJsonTransformer: AuthorJsonTransformer, pageJsonTransformer: PageJsonTransformer,
         relatedContentJsonTransformer: RelatedContentJsonTransformer,
         propertiesJsonTransformer: PropertiesJsonTransformer,
         activityCardJsonTransformer: ActivityCardJsonTransformer,
         bundleItemJsonTransformer: BundleItemJsonTransformer,
         videoJsonTransformer: VideoJsonTransformer) {
        self.listInterestJsonTransformer = listInterestJsonTransformer
        self.listParagraphJsonTransformer = listParagraphJsonTransformer
        self.authorJsonTransformer = authorJsonTransformer
        self.pageJsonTransformer = pageJsonTransformer
        self.relatedContentJsonTransformer = relatedContentJsonTransformer
        self.propertiesJsonTransformer = propertiesJsonTransformer
        self.activityCardJsonTransformer = activityCardJsonTransformer
        self.bundleItemJsonTransformer = bundleItemJsonTransformer
        self.videoJsonTransformer = videoJsonTransformer
    }
    
    private static let fields = (
        publishedDate: "publishedDate",
        uuid: "uuid",
        type: "type",
        numOfLike: "numberOfLikes",
        numOfComment: "numberOfComments",
        subType: "subType",
        paragraphs: "paragraphs",
        interests: "interests",
        title: "title",
        label: "label",
        numberOfImages: "numberOfImages",
        universalUrl: "universalUrl", //app
        whitePageUrl: "whitePageUrl", // app
        link: "link", // app
        code: "code", // app
        photoUrl: "photoUrl", // app
        author: "author",
        liked: "liked",
		
		photo: "photo",             // article
		description: "description",  // article
        id: "id",  // article
        paragraphViewOption: "paragraphViewOption", // article
        hasTag2Page: "hasTag2Page",
        tags: "tags",
        properties: "properties",
        items: "items",
        thumbnail: "thumbnail",
        featureOnStream: "featureOnStream",
        numOfContent: "numOfContent",
        itemIds: "itemIds",
        activityCard: "activityCard",
        bundleItems: "bundleItems",
        video: "video", // video post content page
        header: "header"
    )
    
    func transform(json: JSON) -> FeedEntity {
		let imageTransformer = listParagraphJsonTransformer.paragraphTransformer.paragraphImageTransformer
		
        let fields = FeedJsonTransformer.fields
        
        let publishedDate = json[fields.publishedDate] == JSON.null ? nil :
            Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let uuid = json[fields.uuid] == JSON.null ? json[fields.id].string : json[fields.uuid].string
        let type = json[fields.type].stringValue
        let numOfLike = json[fields.numOfLike].int
        let numOfComment = json[fields.numOfComment].int
        let subType = json[fields.subType].string
        let title = json[fields.title].string
        let label = json[fields.label].string
        let universalUrl = json[fields.universalUrl].string
        let numberOfImages = json[fields.numberOfImages].int
        
        let paragraphs = listParagraphJsonTransformer.transform(json: json)
        let interests = listInterestJsonTransformer.transform(json: json)
        let author = authorJsonTransformer.transform(json: json[fields.author])
        let liked = json[fields.liked].bool ?? false
		
		let photo = json[fields.photo] == JSON.null ? nil : imageTransformer.transform(json: json[fields.photo])
		let description = json[fields.description].string
        let hasTag2Page = json[fields.hasTag2Page].bool ?? false
        let tags = json[fields.tags] == JSON.null ? nil :
            json[fields.tags].arrayValue.map { pageJsonTransformer.transform(json: $0) }
        let relatedContentPage = json[fields.properties] == JSON.null ? nil :
            relatedContentJsonTransformer.transform(json: json[fields.properties])
        let id = json[fields.id].stringValue
        
        var whitePageUrl = ""
        var link = ""
        var code = ""
        var appPhoto: String? = nil
        var episodeTitle: String? = nil
        var episodeCodeSnippet: String? = nil
        var episodeDescription: String? = nil
        var episodeThumbnail: String? = nil
        var appStore: String? = nil
        if  json[fields.properties] == JSON.null {
            whitePageUrl = json[fields.whitePageUrl].stringValue
            link = json[fields.link].stringValue
            code = json[fields.code].stringValue
            appPhoto = json[fields.photoUrl].string
        } else {
            let properties = propertiesJsonTransformer.transform(json: json[fields.properties])
            whitePageUrl = properties.whitePageUrl
            link = properties.link
            code = properties.code
            appPhoto = properties.photo
            episodeTitle = properties.episodeTitle
            episodeCodeSnippet = properties.episodeCodeSnippet
            episodeDescription = properties.episodeDescription
            episodeThumbnail = properties.episodeThumbnail
            appStore = properties.appStore
        }
        let paragraphViewOption = json[fields.paragraphViewOption].int
        let bundleItems = json[fields.items] == JSON.null ? nil :
            json[fields.items].arrayValue.map { self.transform(json: $0) }
        let thumbnail = json[fields.thumbnail].string
        let featureOnStream = json[fields.featureOnStream].boolValue
        let numOfContent = json[fields.numOfContent].int
        let bundleTitle = json[fields.properties][fields.title].string
        
        let activityCard = json[fields.activityCard] == JSON.null ? nil
            : activityCardJsonTransformer.transform(json: json[fields.activityCard])
        
        var bundleItemIds: [BundleItemEntity]? = nil
        if let bundleItemIdsJSON = json[fields.bundleItems].array {
            bundleItemIds = bundleItemIdsJSON.map({ bundleItemJsonTransformer.transform(json: $0) })
        }
        let metadata = json[fields.header].dictionaryObject
        
        let feed = FeedEntity(uuid: uuid, publishedDate: publishedDate, type: type,
                          subType: subType, numberOfLikes: numOfLike, numberOfComments: numOfComment,
                          paragraphs: paragraphs, interests: interests, title: title,
                          label: label, universalUrl: universalUrl, author: author, photo: photo,
                          description: description, liked: liked, hasTag2Page: hasTag2Page,
                          tags: tags, numberOfImages: numberOfImages, relatedContent: relatedContentPage,
                          whitePageUrl: whitePageUrl, link: link, code: code, id: id, mapCampaign: nil,
                          appPhoto: appPhoto, paragraphViewOption: paragraphViewOption, bundleItems: bundleItems,
                          thumbnail: thumbnail, featureOnStream: featureOnStream, numOfContent: numOfContent,
                          bundleItemIds: bundleItemIds, bundleTitle: bundleTitle, episodeTitle: episodeTitle,
                          episodeCodeSnippet: episodeCodeSnippet, episodeDescription: episodeDescription,
                          appStore: appStore, activityCard: activityCard, episodeThumbnail: episodeThumbnail,
                          metadata: metadata)
        
        feed.video = json[fields.video] == JSON.null ? nil : videoJsonTransformer.transform(json: json[fields.video])
        
        return feed
    }
}

class ListParagraphJsonTransformer: JsonTransformer {
    let paragraphTransformer: ParagraphTransformer
    
    init(paragraphTransformer: ParagraphTransformer) {
        self.paragraphTransformer = paragraphTransformer
    }
    
    func transform(json: JSON) -> [ParagraphEntity] {
        return json["paragraphs"].arrayValue.map { paragraphTransformer.transform(json: $0) }
    }
}

class ParagraphTransformer: JsonTransformer {
    let paragraphImageTransformer: ParagraphImageTransformer
    let mediaJsonTransformer: MediaJsonTransformer
    let videoJsonTransformer: VideoJsonTransformer
    
    init(paragraphImageTransformer: ParagraphImageTransformer,
         mediaJsonTransformer: MediaJsonTransformer, videoJsonTransformer: VideoJsonTransformer) {
        self.paragraphImageTransformer = paragraphImageTransformer
        self.mediaJsonTransformer = mediaJsonTransformer
        self.videoJsonTransformer = videoJsonTransformer
    }

    private static let fields = (
        type: "type",
        description: "description",
        images: "images",
        defaultImageId: "defaultImageId",
        total: "total",
        title: "title",
        media: "media",
        codeSnippet: "codeSnippet",
        mediaList: "mediaList",
        sourceLink: "sourceLink",
        sourceLabel: "sourceLabel",
        rawFile: "rawFile",
        duration: "duration",
        url: "url",
        videoThumbnail: "videoThumbnail",
        destinationUrl: "destinationUrl",
        id: "id",
        episodeTitle: "episodeTitle",
        episodeDescription: "episodeDescription",
        appStore: "appStore",
        video: "video",
        videoId: "videoId",
        thumbnail: "thumbnail",
        label: "label",
        thumbnailImage: "thumbnailImage"
    )
    
    func transform(json: JSON) -> ParagraphEntity {
        let fields = ParagraphTransformer.fields
        
        let type = json[fields.type].string
        let description = json[fields.description].string
        var defaultImageId = json[fields.defaultImageId].string
        let total = json[fields.total].int
        let title = json[fields.title].string
        
        var images = json[fields.images] == JSON.null ? nil :
            json[fields.images].arrayValue.map { paragraphImageTransformer.transform(json: $0) }
        if images == nil {
            images = json[fields.mediaList] == JSON.null ? nil :
                json[fields.mediaList].arrayValue.map { paragraphImageTransformer.transform(json: $0) }
            defaultImageId = json[fields.media][fields.id].string
        }
        let media = json[fields.media] == JSON.null ? nil : mediaJsonTransformer.transform(json: json[fields.media])
        let video = json[fields.video] == JSON.null ? nil : videoJsonTransformer.transform(json: json[fields.video])
        let codeSnippet = json[fields.codeSnippet].string
        let label = json[fields.label].string
        
        let sourceLink = json[fields.sourceLink].string
        let sourceLabel = json[fields.sourceLabel].string
        let rawFile = json[fields.rawFile].string
        let duration = json[fields.duration].string
        let url = json[fields.url].string
        let videoThumbnail = json[fields.videoThumbnail].string
        
        let episodeTitle = json[fields.episodeTitle].string
        let episodeDescription = json[fields.episodeDescription].string
        var episodeThumbnail = json[fields.thumbnail].string
        if episodeThumbnail == nil {
            episodeThumbnail = json[fields.thumbnailImage].string
        }
        let appStore = json[fields.appStore].string
        let videoId = json[fields.videoId] == JSON.null ? nil : json[fields.videoId].string
        
        return ParagraphEntity(type: type, description: description, title: title,
                               images: images, defaultImage: defaultImageId, total: total, media: media,
                               codeSnippet: codeSnippet, sourceLink: sourceLink, sourceLabel: sourceLabel,
                               rawFile: rawFile, duration: duration, url: url, videoThumbnail: videoThumbnail,
                               episodeTitle: episodeTitle, episodeDescription: episodeDescription, appStore: appStore,
                               video: video, videoId: videoId, episodeThumbnail: episodeThumbnail, label: label)
    }
}

class ParagraphImageTransformer: JsonTransformer {
    private static let fields = (
        id: "id",
        uuid: "uuid",
        url: "url",
        universalUrl: "universalUrl",
        hasTag2Page: "hasTag2Page",
        
        description: "description",
        sourceLink: "sourceLink",
        sourceLabel: "sourceLabel",
        label: "label",
        interests: "interests",
        publishedDate: "publishedDate",
        tags: "tags",
        link: "link",
        originalLink: "originalLink"
    )
    
    func transform(json: JSON) -> ImageEntity {
        let fields = ParagraphImageTransformer.fields
        
        let id = json[fields.id].string ?? ""
        let uuid = json[fields.uuid].stringValue
        let url = json[fields.url].stringValue
        let universalUrl = json[fields.universalUrl].stringValue
        let hasTag2Page = json[fields.hasTag2Page].boolValue
        
        let description = json[fields.description].string
        let sourceLink = json[fields.sourceLink].string
        let sourceLabel = json[fields.sourceLabel].string
        let label = json[fields.label].string
        // swiftlint:disable force_cast
        let interests = json[fields.interests].arrayObject?.map { InterestEntity(uuid: "", name: $0 as! String) }
        let publishedDate = Date(timeIntervalSince1970: json[fields.publishedDate].doubleValue / 1000)
        let tags = json[fields.tags].string
        let link = json[fields.link].stringValue
        let originalLink = json[fields.originalLink].stringValue
        
        return ImageEntity(id: id, uuid: uuid, url: url, universalUrl: universalUrl,
                           hasTag2Page: hasTag2Page, description: description, sourceLink: sourceLink,
                           sourceLabel: sourceLabel, label: label, interests: interests, publishedDate: publishedDate,
                           tags: tags, link: link, originalLink: originalLink)
    }
}

class ListInterestJsonTransformer: JsonTransformer {
    let interestJsonTransformer: InterestJsonTransformer
    
    init(interestJsonTransformer: InterestJsonTransformer) {
        self.interestJsonTransformer = interestJsonTransformer
    }
    
    func transform(json: JSON) -> [InterestEntity] {
        return json["interests"].arrayValue.map { interestJsonTransformer.transform(json: $0) }
    }
}

class InterestJsonTransformer: JsonTransformer {
    private static let fields = (
        name: "name",
        uuid: "uuid"
    )
    
    func transform(json: JSON) -> InterestEntity {
        let fiels = InterestJsonTransformer.fields
        let uuid = json[fiels.uuid].stringValue
        let name = json[fiels.name].stringValue
        
        return InterestEntity(uuid: uuid, name: name)
    }
}

class AuthorJsonTransformer: JsonTransformer {
    private static let fields = (
        name: "name",
        authorId: "id",
        avatarUrl: "avatarUrl",
        universalUrl: "universalUrl",
        title: "title",
        logo: "logo",
        externalUrl: "externalUrl",
        gender: "gender",
        accentColor: "accentColor"
    )
    
    func transform(json: JSON) -> AuthorEntity {
        let fields = AuthorJsonTransformer.fields
        let authorId = json[fields.authorId].stringValue
        var name = ""
        if let nameValue = json[fields.name].string {
            name = nameValue
        } else if let titleValue = json[fields.title].string {
            name = titleValue
        }
        var avatarUrl = ""
        if let avatarUrlValue = json[fields.avatarUrl].string {
            avatarUrl = avatarUrlValue
        } else if let logoValue = json[fields.logo].string {
            avatarUrl = logoValue
        }
        var universalUrl = ""
        if let universalUrlValue = json[fields.universalUrl].string {
            universalUrl = universalUrlValue
        } else if let externalUrlValue = json[fields.externalUrl].string {
            universalUrl = externalUrlValue
        }
        var gender: String?
        if let value = json[fields.gender].string {
            gender = value
        }
        let accentColor = json[fields.accentColor].string
        
        return AuthorEntity(authorId: authorId, name: name, avatarUrl: avatarUrl, universalUrl: universalUrl,
                            gender: gender, accentColor: accentColor)
    }
}

class BundleItemJsonTransformer: JsonTransformer {
    private static let fields = (
        type: "type",
        order: "order",
        entityId: "entityId"
    )
    
    func transform(json: JSON) -> BundleItemEntity {
        let fields = BundleItemJsonTransformer.fields
        let type = json[fields.type].string ?? ""
        let order = json[fields.type].int ?? 0
        let entityId = json[fields.entityId].string ?? ""
        
        return BundleItemEntity(type: type, order: order, entityId: entityId)
    }
}
