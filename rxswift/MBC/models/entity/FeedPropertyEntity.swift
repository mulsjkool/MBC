//
//  FeedPropertyEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FeedPropertyEntity {
	var id: String
	var description: String
	var title: String
	var interests: [String]
	var publishedDatetime: Date?
	var status: String
	var type: String
	var code: String
	var link: String
	var photo: String
	var whitePageUrl: String
    
    /// addition for Episode
    var episodeTitle: String?
    var episodeCodeSnippet: String?
    var episodeDescription: String?
    var appStore: String?
    var episodeThumbnail: String?
    /// end addition for Episode
	
	init(id: String, description: String, title: String, interests: [String], publishedDatetime: Date?,
		 status: String, type: String, code: String, link: String, photo: String, whitePageUrl: String,
         episodeTitle: String?, episodeCodeSnippet: String?, episodeDescription: String?, appStore: String?,
         episodeThumbnail: String?) {
		self.id = id
		self.description = description
		self.title = title
		self.interests = interests
		self.publishedDatetime = publishedDatetime
		self.status = status
		self.type = type
		self.code = code
		self.link = link
		self.photo = photo
		self.whitePageUrl = whitePageUrl
        self.episodeTitle = episodeTitle
        self.episodeCodeSnippet = episodeCodeSnippet
        self.episodeDescription = episodeDescription
        self.appStore = appStore
        self.episodeThumbnail = episodeThumbnail
	}
	
}
