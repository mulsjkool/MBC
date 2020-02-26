//
//  FeedEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class FeedEntity {
    var uuid: String?
    var publishedDate: Date?
    var type: String
    var subType: String?
    var numOfLikes: Int?
    var numOfComments: Int?
    var paragraphs: [ParagraphEntity]?
    var interests: [InterestEntity]?
    var title: String?
    var label: String?
    var universalUrl: String?
    var author: AuthorEntity?
    var page: PageEntity?
    var liked: Bool = false
    var hasTag2Page: Bool = false
    var numberOfImages: Int?
    
    /// addition for campaign (StreamPage)
    var name: String?
    var avatarUrl: String?
    var poster: ImageEntity?
    var cover: ImageEntity?
    var header: HeaderEntity?
    var accentColor: String?
    var headerColor: String?
    var pageType: String?
    var pageSubType: String?
    var featureOnStream: Bool
    /// end addition for campaign (StreamPage)
    
    /// addition for campaign (Article)
    var photo: ImageEntity?
    var description: String?
    var paragraphViewOption: Int?
    var tags: [PageEntity]?
    /// end addition for campaign (Article)
	
    /// addition for campaign (App)
	var whitePageUrl: String?
    var link: String
    var code: String
    var id: String
    var mapCampaign: [CampaignEntity]?
    var appPhoto: String?
	/// end addition for campaign (App)
    
    /// addition for video (Content page)
    var video: VideoEntity?
    /// end addition for video (Content page)
    
    /// addition for related content
    var relatedContent: RelatedContentEntity?
    /// end addition for related content
    
    /// addition for Bundle
    var bundleItems: [FeedEntity]?
    var thumbnail: String?
    var numOfContent: Int?
    var bundleItemIds: [BundleItemEntity]?
    var bundleTitle: String?
    /// end addition for Bundle
    
    /// addition for Episode
    var episodeTitle: String?
    var episodeCodeSnippet: String?
    var episodeDescription: String?
    var appStore: String?
    var episodeThumbnail: String?
    /// end addition for Episode
    
    /// addition for Activity Card
    var activityCard: ActivityCardEntity?
    /// end addition for Activity Card
    
    /// addition for Search Page
    var metadata: [String: Any?]?
    /// end addition for Search Page
    
    init(type: String) {
        self.type = type
        self.link = ""
        self.code = ""
        self.id = ""
        self.featureOnStream = false
    }
    
    init(uuid: String?, publishedDate: Date?, type: String, subType: String?,
         numberOfLikes: Int?, numberOfComments: Int?, paragraphs: [ParagraphEntity]?,
         interests: [InterestEntity]?, title: String?, label: String?, universalUrl: String?,
         author: AuthorEntity?, photo: ImageEntity?, description: String?,
         liked: Bool?, hasTag2Page: Bool, tags: [PageEntity]?, numberOfImages: Int?,
         relatedContent: RelatedContentEntity?, whitePageUrl: String?, link: String, code: String, id: String,
         mapCampaign: [CampaignEntity]?, appPhoto: String?, paragraphViewOption: Int?, bundleItems: [FeedEntity]?,
         thumbnail: String?, featureOnStream: Bool, numOfContent: Int?, bundleItemIds: [BundleItemEntity]?,
         bundleTitle: String?, episodeTitle: String?, episodeCodeSnippet: String?, episodeDescription: String?,
         appStore: String?, activityCard: ActivityCardEntity?, episodeThumbnail: String?, metadata: [String: Any?]?) {
        self.uuid = uuid
        self.publishedDate = publishedDate
        self.type = type
        self.subType = subType
        self.numOfLikes = numberOfLikes
        self.numOfComments = numberOfComments
        self.paragraphs = paragraphs
        self.interests = interests
        self.title = title
        self.label = label
        self.universalUrl = universalUrl
        self.author = author
		self.photo = photo
		self.description = description
        self.whitePageUrl = whitePageUrl
        self.liked = liked ?? false
        self.hasTag2Page = hasTag2Page
        self.tags = tags
        self.numberOfImages = numberOfImages
        self.relatedContent = relatedContent
        self.link = link
        self.code = code
        self.id = id
        self.mapCampaign = mapCampaign
        self.appPhoto = appPhoto
        self.paragraphViewOption = paragraphViewOption
        self.bundleItems = bundleItems
        self.thumbnail = thumbnail
        self.featureOnStream = featureOnStream
        self.numOfContent = numOfContent
        self.bundleItemIds = bundleItemIds
        self.bundleTitle = bundleTitle
        self.episodeTitle = episodeTitle
        self.episodeCodeSnippet = episodeCodeSnippet
        self.episodeDescription = episodeDescription
        self.appStore = appStore
        self.activityCard = activityCard
        self.episodeThumbnail = episodeThumbnail
        self.metadata = metadata
    }
}
