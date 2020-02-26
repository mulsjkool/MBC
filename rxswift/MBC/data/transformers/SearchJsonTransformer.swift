//
//  SearchResultJsonTransformer.swift
//  MBC
//
//  Created by Tri Vo on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class SearchResultJsonTransformer: JsonTransformer {
	
	let campainJsonTransformer: CampaignJsonTransformer
	let statisticJsonTransformer: StatisticJsonTransformer
	
	private static let fields = (
		pages: "pages",
		contents: "contents",
		statistic: "statistic"
	)
	
	init(campainJsonTransformer: CampaignJsonTransformer, statisticJsonTransformer: StatisticJsonTransformer) {
		self.campainJsonTransformer = campainJsonTransformer
		self.statisticJsonTransformer = statisticJsonTransformer
	}
	
	func transform(json: JSON) -> SearchResultEntity {
		let fields = SearchResultJsonTransformer.fields
		
		let pages = json[fields.pages].arrayValue.map { campainJsonTransformer.transform(json: $0) }
		let contents = json[fields.contents].arrayValue.map { campainJsonTransformer.transform(json: $0) }
		let statistic = statisticJsonTransformer.transform(json: json[fields.statistic])
		
		return SearchResultEntity(pages: pages, contents: contents, statistic: statistic)
	}
}

class StatisticJsonTransformer: JsonTransformer {
	
	private static let fields = (
		numberOfGeneralContents: "numberOfGeneralContents",
		numberOfPages: "numberOfPages",
		numberOfVideos: "numberOfVideos",
		numberOfNews: "numberOfNews",
		numberOfPhotos: "numberOfPhotos",
		numberOfApps: "numberOfApps",
		numberOfPlaylist: "numberOfPlaylist",
		numberOfBundles: "numberOfBundles"
	)
	
	func transform(json: JSON) -> SearchStatisticEntity {
		let fields = StatisticJsonTransformer.fields
		
		let generalContents = json[fields.numberOfGeneralContents].intValue
		let pages = json[fields.numberOfPages].intValue
		let videos = json[fields.numberOfVideos].intValue
		let news = json[fields.numberOfNews].intValue
		let photos = json[fields.numberOfPhotos].intValue
		let apps = json[fields.numberOfApps].intValue
		let playlist = json[fields.numberOfPlaylist].intValue
		let bundles = json[fields.numberOfBundles].intValue
		
		return SearchStatisticEntity(numberOfGeneralContents: generalContents, numberOfPages: pages,
									 numberOfVideos: videos, numberOfNews: news,
									 numberOfPhotos: photos, numberOfApps: apps,
									 numberOfPlaylist: playlist, numberOfBundles: bundles)
	}
}

class SearchSuggestionJsonTransformer: JsonTransformer {
    
    private static let fields = (
        contentId: "contentId",
        title: "title",
        thumbnail: "thumbnail",
        metadata: "metadata",
        universalUrl: "universalUrl",
        contentType: "contentType",
        descriptionTitle: "descriptionTitle",
        metadataMap: "metadataMap"
    )
    
    func transform(json: JSON) -> SearchSuggestionEntity {
        let fields = SearchSuggestionJsonTransformer.fields
        
        let contentId = json[fields.contentId].string ?? ""
        let title = json[fields.title].string ?? ""
        let thumbnail = json[fields.thumbnail].string ?? ""
        let metadata = json[fields.metadata].string ?? ""
        let universalUrl = json[fields.universalUrl].string ?? ""
        let contentType = json[fields.contentType].string ?? ""
        let metadataMap = json[fields.metadataMap].dictionaryObject ?? [:]
        let descriptionTitle = json[fields.descriptionTitle].bool ?? false
        
        return SearchSuggestionEntity(contentId: contentId, title: title, thumbnail: thumbnail, metadata: metadata,
                                      universalUrl: universalUrl, contentType: contentType,
                                      isDescriptionTitle: descriptionTitle, metadataMap: metadataMap)
    }
}

class ListSearchSuggestionJsonTransformer: JsonTransformer {
    
    let searchSuggestionJsonTransformer: SearchSuggestionJsonTransformer
    
    init(searchSuggestionJsonTransformer: SearchSuggestionJsonTransformer) {
        self.searchSuggestionJsonTransformer = searchSuggestionJsonTransformer
    }
    
    func transform(json: JSON) -> [SearchSuggestionEntity] {
        let listItem = json.arrayValue.map { searchSuggestionJsonTransformer.transform(json: $0) }
        return listItem
    }
}
