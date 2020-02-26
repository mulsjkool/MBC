//
//  FeedChannel.swift
//  MBC
//
//  Created by Tri Vo on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

enum RadioFeedType: String, Codable {
	case normal, ads
}

class RadioFeed: Codable {
	var title: String
	var imageUrl: String
	var name: String
	var description: String
	var timestamp: String
	var type: RadioFeedType = .normal

	init(title: String?, imageUrl: String?, name: String?, description: String?, timestamp: String?) {
		self.title = title ?? ""
		self.imageUrl = imageUrl ?? ""
		self.name = name ?? ""
		self.description = description ?? ""
		self.timestamp = timestamp ?? ""
	}
	
	convenience init(type: RadioFeedType) {
		self.init(title: nil, imageUrl: nil, name: nil, description: nil, timestamp: nil)
		self.type = .ads
	}
}
