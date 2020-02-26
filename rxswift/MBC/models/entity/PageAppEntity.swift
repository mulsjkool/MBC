//
//  AppTabEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class PageAppEntity {
	var title: String?
	var total: Int
	var entities: [FeedEntity]
	
	init(title: String?, total: Int, entities: [FeedEntity]) {
		self.title = title
		self.total = total
		self.entities = entities
	}
}
