//
//  HomeStreamJsonTransformer.swift
//  MBC
//
//  Created by azuniMac on 12/16/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeStreamJsonTransformer: JsonTransformer {
    let listCampaignJsonTransformer: ListCampaignJsonTransformer
    
    init(listCampaignJsonTransformer: ListCampaignJsonTransformer) {
        self.listCampaignJsonTransformer = listCampaignJsonTransformer
    }
    
    private static let fields = ( items: "items", total: "total" )
    
    func transform(json: JSON) -> HomeStreamEntity {
        let fields = HomeStreamJsonTransformer.fields
        
        let items = listCampaignJsonTransformer.transform(json: json)
        let total = json[fields.total].intValue
        
        return HomeStreamEntity(items: items, total: total)
    }
}

class ListCampaignJsonTransformer: JsonTransformer {
    let campaignJsonTransformer: CampaignJsonTransformer
    
    init(campaignJsonTransformer: CampaignJsonTransformer) {
        self.campaignJsonTransformer = campaignJsonTransformer
    }
    
    func transform(json: JSON) -> [CampaignEntity] {
        return json["items"].arrayValue.map { campaignJsonTransformer.transform(json: $0) }
    }
}

class GenreJsonTransformer: JsonTransformer {
    private static let fields = (
        id: "id",
        names: "names"
    )
    
    func transform(json: JSON) -> GenreEntity {
        let fields = GenreJsonTransformer.fields
        let id = json[fields.id].stringValue
        let names = json[fields.names].stringValue
        return GenreEntity(id: id, names: names)
    }
    
}

class HeaderJsonTransformer: JsonTransformer {
    let genreJsonTransformer: GenreJsonTransformer
    private static let fields = (
        liveRecord: "liveRecord",
        genre: "genre"
    )
    
    init(genreJsonTransformer: GenreJsonTransformer) {
        self.genreJsonTransformer = genreJsonTransformer
    }
    
     func transform(json: JSON) -> HeaderEntity {
        let fields = HeaderJsonTransformer.fields
        let liveRecord = json[fields.liveRecord].stringValue
        let genre = genreJsonTransformer.transform(json: json[fields.genre])
        return HeaderEntity(liveRecord: liveRecord, genre: genre)
    }
}

class CampaignJsonTransformer: FeedJsonTransformer {
    let headerJsonTransformer: HeaderJsonTransformer
    private static let fields = (
        placementMode: "placementMode",
        segmentSize: "segmentSize",
        campaignType: "campaignType",
        campaignMode: "campaignMode",
        contentResult: "contentResult",
        publishedDate: "publishedDate",
        title: "title",
        items: "items",
        name : "name",
        avatarUrl : "avatarUrl",
        poster : "poster",
        cover : "cover",
        header : "header",
        pageType: "pageType",
        pageSubType: "pageSubType",
        headerColor : "headerColor",
        accentColor : "accentColor",
        liked: "liked",
        
        photo: "photo",             // article
        description: "description",  // article
		whitePageUrl: "whitePageUrl" // type app
    )
    
    init(headerJsonTransformer: HeaderJsonTransformer,
         listParagraphJsonTransformer: ListParagraphJsonTransformer,
        listInterestJsonTransformer: ListInterestJsonTransformer,
        authorJsonTransformer: AuthorJsonTransformer, pageJsonTransformer: PageJsonTransformer,
        relatedContentJsonTransformer: RelatedContentJsonTransformer,
        propertiesJsonTransformer: PropertiesJsonTransformer,
        activityCardJsonTransformer: ActivityCardJsonTransformer,
        bundleItemJsonTransformer: BundleItemJsonTransformer,
        videoJsonTransformer: VideoJsonTransformer) {
        self.headerJsonTransformer = headerJsonTransformer
        super.init(listParagraphJsonTransformer: listParagraphJsonTransformer,
                   listInterestJsonTransformer: listInterestJsonTransformer,
                   authorJsonTransformer: authorJsonTransformer, pageJsonTransformer: pageJsonTransformer,
                   relatedContentJsonTransformer: relatedContentJsonTransformer,
                   propertiesJsonTransformer: propertiesJsonTransformer,
                   activityCardJsonTransformer: activityCardJsonTransformer,
                   bundleItemJsonTransformer: bundleItemJsonTransformer,
                   videoJsonTransformer: videoJsonTransformer)
    }
    
    override func transform(json: JSON) -> CampaignEntity {
        let imageTransformer = listParagraphJsonTransformer.paragraphTransformer.paragraphImageTransformer
        let fields = CampaignJsonTransformer.fields
        
        let name = json[fields.name].string
        let avatarUrl = json[fields.avatarUrl].string
        let poster = json[fields.poster] == JSON.null ? nil :
            imageTransformer.transform(json: json[fields.poster])
        
        let cover = json[fields.cover] == JSON.null ? nil :
            imageTransformer.transform(json: json[fields.cover])
        
        let headerEntity = headerJsonTransformer.transform(json: json[fields.header])
        let pageType = json[fields.pageType].string
        let pageSubType = json[fields.pageSubType].string
        
        let headerColor = json[fields.headerColor].string
        let accentColor = json[fields.accentColor].string
        let liked = json[fields.liked].bool ?? false
        
        let photo = json[fields.photo] == JSON.null ? nil : imageTransformer.transform(json: json[fields.photo])
        let description = json[fields.description].string
		let whitePageUrl = json[fields.whitePageUrl] == JSON.null ? nil : json[fields.whitePageUrl].string
        
        let entity = super.transform(json: json)
        let camEntity = CampaignEntity(uuid: entity.uuid, publishedDate: entity.publishedDate, type: entity.type,
                                       subType: entity.subType, numberOfLikes: entity.numOfLikes,
                                       numberOfComments: entity.numOfComments, paragraphs: entity.paragraphs,
                                       interests: entity.interests, title: entity.title, label: entity.label,
									   universalUrl: entity.universalUrl, author: entity.author, photo: photo,
                                       description: description, liked: liked, hasTag2Page: entity.hasTag2Page,
                                       tags: entity.tags, numberOfImages: entity.numberOfImages,
                                       relatedContent: entity.relatedContent, whitePageUrl: whitePageUrl,
                                       link: entity.link, code: entity.code, id: entity.id,
                                       mapCampaign: entity.mapCampaign, appPhoto: entity.appPhoto,
                                       paragraphViewOption: entity.paragraphViewOption, bundleItems: entity.bundleItems,
                                       thumbnail: entity.thumbnail, featureOnStream: entity.featureOnStream,
                                       numOfContent: entity.numOfContent, bundleItemIds: entity.bundleItemIds,
                                       bundleTitle: entity.bundleTitle, episodeTitle: entity.episodeTitle,
                                       episodeCodeSnippet: entity.episodeCodeSnippet,
                                       episodeDescription: entity.episodeDescription, appStore: entity.appStore,
                                       activityCard: entity.activityCard, episodeThumbnail: entity.episodeThumbnail,
                                       metadata: entity.metadata)

        camEntity.name = name
        camEntity.avatarUrl = avatarUrl
        camEntity.poster = poster
        camEntity.cover = cover
        camEntity.header = headerEntity
        camEntity.headerColor = headerColor
        camEntity.pageType = pageType
        camEntity.pageSubType = pageSubType
        camEntity.accentColor = accentColor
		camEntity.whitePageUrl = whitePageUrl
        
        camEntity.placementMode = json[fields.placementMode].stringValue
        camEntity.segmentSize = json[fields.segmentSize].intValue
        camEntity.campaignType = json[fields.campaignType].stringValue
        camEntity.campaignMode = json[fields.campaignMode].stringValue
        camEntity.contentResult = json[fields.contentResult].intValue
        
        let items = ListCampaignJsonTransformer(campaignJsonTransformer: self).transform(json: json) as [FeedEntity]
        camEntity.items = items
        
        return camEntity
    }
}
