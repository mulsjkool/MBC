//
//  AppPageJsonTransformer.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class PageAppJsonTransformer: JsonTransformer {
	
	let listAppPageJsonTransformer: ListAppPageJsonTransformer
	
	init(listAppPageJsonTransformer: ListAppPageJsonTransformer) {
		self.listAppPageJsonTransformer = listAppPageJsonTransformer
	}
	
	private static let fields = ( items: "entities", total: "total", title: "title" )
	
	func transform(json: JSON) -> PageAppEntity {
		let fields = PageAppJsonTransformer.fields
		let items = self.listAppPageJsonTransformer.transform(json: json)
		let total = json[fields.total].intValue
		let title = json[fields.title].stringValue
		return PageAppEntity(title: title, total: total, entities: items)
	}
}

class PropertiesJsonTransformer: JsonTransformer {
	private static let fields = (
        link: "link",
        code: "code",
        photo: "photo",
        whitePageUrl: "whitePageUrl",
        episodeTitle : "episodeTitle",
        codeSnippet: "codeSnippet",
        description: "description",
        appStore: "appStore",
        thumbnailImage: "thumbnailImage"
    )
	
	func transform(json: JSON) -> FeedPropertyEntity {
		let code = json[PropertiesJsonTransformer.fields.code].stringValue
		let link = json[PropertiesJsonTransformer.fields.link].stringValue
		let photo = json[PropertiesJsonTransformer.fields.photo].stringValue
		let whitePageUrl = json[PropertiesJsonTransformer.fields.whitePageUrl].stringValue
        let episodeTitle = json[PropertiesJsonTransformer.fields.episodeTitle].string
        let episodeCodeSnippet = json[PropertiesJsonTransformer.fields.codeSnippet].string
        let episodeDescription = json[PropertiesJsonTransformer.fields.description].string
        let appStore = json[PropertiesJsonTransformer.fields.appStore].string
        let episodeThumbnail = json[PropertiesJsonTransformer.fields.thumbnailImage].string
		return FeedPropertyEntity(id: "", description: "", title: "", interests: [], publishedDatetime: nil,
								 status: "", type: "", code: code, link: link, photo: photo, whitePageUrl: whitePageUrl,
                                 episodeTitle: episodeTitle, episodeCodeSnippet: episodeCodeSnippet,
                                 episodeDescription: episodeDescription, appStore: appStore,
                                 episodeThumbnail: episodeThumbnail)
	}
}

class ListAppPageJsonTransformer: JsonTransformer {
	let feedJsonTransformer: FeedJsonTransformer
	
	init(feedJsonTransformer: FeedJsonTransformer) {
		self.feedJsonTransformer = feedJsonTransformer
	}
	
	func transform(json: JSON) -> [FeedEntity] {
        return json["entities"].arrayValue.map { feedJsonTransformer.transform(json: $0) }
	}
}
