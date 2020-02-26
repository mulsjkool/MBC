//
//  SearchResultEntity.swift
//  MBC
//
//  Created by Tri Vo on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class SearchResultEntity {
	var pages: [CampaignEntity]?
	var contents: [CampaignEntity]?
	var statistic: SearchStatisticEntity
	
	init(pages: [CampaignEntity]?, contents: [CampaignEntity]?, statistic: SearchStatisticEntity) {
		self.pages = pages
		self.contents = contents
		self.statistic = statistic
	}
}
