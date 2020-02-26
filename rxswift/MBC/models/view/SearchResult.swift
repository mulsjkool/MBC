//
//  SearchResult.swift
//  MBC
//
//  Created by Tri Vo on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class SearchResult {
	var items: [Campaign]
	var total: Int
	var statistic: SearchStatistic
	
	init(items: [Campaign], total: Int, statistic: SearchStatistic) {
		self.items = items
		self.total = total
		self.statistic = statistic
	}
}
