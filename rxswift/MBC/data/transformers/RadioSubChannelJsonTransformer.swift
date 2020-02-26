//
//  SubChannelJsonTransformer.swift
//  MBC
//
//  Created by Tri Vo on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class ListRadioSubChannelJsonTransformer: JsonTransformer {
	
	let radioSubChannelJsonTransformer: RadioSubChannelJsonTransformer
	
	init(radioSubChannelJsonTransformer: RadioSubChannelJsonTransformer) {
		self.radioSubChannelJsonTransformer = radioSubChannelJsonTransformer
	}
	
	func transform(json: JSON) -> [RadioSubChannelEntity] {
		return json.arrayValue.map { radioSubChannelJsonTransformer.transform(json: $0) }
	}
}

class RadioSubChannelJsonTransformer: JsonTransformer {

	private static let fields = (
		id : "id",
		channelTitle : "channelTitle",
		liveStream : "liveStream",
		metaData : "metaData",
		isVideo : "isVideo",
		isDefault : "isDefaultRelationship"
	)
	
	func transform(json: JSON) -> RadioSubChannelEntity {
		let fields = RadioSubChannelJsonTransformer.fields
		
		let id = json[fields.id].string ?? ""
		let channelTitle = json[fields.channelTitle].string ?? ""
		let liveStream = json[fields.liveStream].string ?? ""
		let metaData = json[fields.metaData].string ?? ""
		let isVideo = json[fields.isVideo].bool ?? false
		let isDefault = json[fields.isDefault].bool ?? false
		return RadioSubChannelEntity(id: id, channelTitle: channelTitle, liveStream: liveStream, metaData: metaData,
									 isVideo: isVideo, isDefault: isDefault)
	}
}
