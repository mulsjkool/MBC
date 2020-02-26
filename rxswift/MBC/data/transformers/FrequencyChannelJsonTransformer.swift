//
//  ChannelFrequencyJsonTransformer.swift
//  MBC
//
//  Created by Tri Vo on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class ListFrequencyChannelJsonTransformer: JsonTransformer {
	
	let frequencyChannelJsonTransformer: FrequencyChannelJsonTransformer
	
	init(frequencyChannelJsonTransformer: FrequencyChannelJsonTransformer) {
		self.frequencyChannelJsonTransformer = frequencyChannelJsonTransformer
	}
	
	func transform(json: JSON) -> [FrequencyChannelEntity] {
		return json.arrayValue.map { frequencyChannelJsonTransformer.transform(json: $0) }
	}
}

class FrequencyChannelJsonTransformer: JsonTransformer {

	private static let fields = "channelFrequency"
	
	func transform(json: JSON) -> FrequencyChannelEntity {
		let fields = FrequencyChannelJsonTransformer.fields
		
		let frequencyChannel = json[fields].string ?? ""
		return FrequencyChannelEntity(frequencyChannel: frequencyChannel)
	}
}
