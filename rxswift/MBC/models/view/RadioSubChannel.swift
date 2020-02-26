//
//  RadioSubChannel.swift
//  MBC
//
//  Created by Tri Vo on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftSoup

class RadioSubChannel: Codable {
	var id: String
	var channelTitle: String
	var liveStream: String
	var metaData: String
	var isVideo: Bool
	var isDefault: Bool
	var feedChannel: [RadioFeed]?
	
	init(entity: RadioSubChannelEntity) {
		self.id = entity.id
		self.channelTitle = entity.channelTitle
		self.liveStream = entity.liveStream
		self.metaData = entity.metaData
		self.isVideo = entity.isVideo
		self.isDefault = entity.isDefault
		parseHtml(link: metaData)
	}
	
	private func parseHtml(link: String) {
		guard let url = URL(string: link), !link.isEmpty else { return }
		do {
			var document: Document = Document("")
			let html = try String(contentsOf: url)
			document = try SwiftSoup.parse(html)
			
			guard let elements = document.body()?.children().first()?.children() else { return }
			feedChannel = []
			for element in elements {
				var title: String?
				var imageUrl: String?
				var feedName: String?
				var feedDescription: String?
				var feedTime: String?
				
				if let videoTitle = try? element.select(Constants.RadioHtmlTagName.title).first()?.text() {
					title = videoTitle
				}
				
				if let videoImage = try? element.select(Constants.RadioHtmlTagName.image).first()?
												.attr(Constants.RadioHtmlTagName.src) { imageUrl = videoImage }
				
				if let videoData = try? element.select(Constants.RadioHtmlTagName.row) {
					if let name = try? videoData.first()?.text() { feedName = name }
					if videoData.size() >= 2, let description = try? videoData.get(1).text() {
                        feedDescription = description
                    }
					if let timestamp = try? videoData.last()?.text() { feedTime = timestamp }
				}
				feedChannel?.append(RadioFeed(title: title, imageUrl: imageUrl, name: feedName,
											  description: feedDescription, timestamp: feedTime))
			}
		} catch let error { print("Error: \(error)") }
	}
}
