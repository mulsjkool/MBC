//
//  SubChannelEntity.swift
//  MBC
//
//  Created by Tri Vo on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class RadioSubChannelEntity {
	var id: String
	var channelTitle: String
	var liveStream: String
	var metaData: String
	var isVideo: Bool
	var isDefault: Bool
	
	init(id: String, channelTitle: String, liveStream: String, metaData: String, isVideo: Bool = false,
		 isDefault: Bool = false) {
		self.id = id
		self.channelTitle = channelTitle
		self.liveStream = liveStream
		self.metaData = metaData
		self.isVideo = isVideo
		self.isDefault = isDefault
	}
}
