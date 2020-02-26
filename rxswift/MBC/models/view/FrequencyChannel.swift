//
//  FrequencyChannel.swift
//  MBC
//
//  Created by Tri Vo on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FrequencyChannel: Codable {
	var frequencyChannel: String
	
	init(entity: FrequencyChannelEntity) {
		self.frequencyChannel = entity.frequencyChannel
	}
}
