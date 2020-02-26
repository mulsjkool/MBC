//
//  SearchCondition.swift
//  MBC
//
//  Created by Tri Vo on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

struct SearchCondition {
	var keyword: String
	var type: SearchItemEnum
	var fromIndex: Int
	var numberOfItems: Int
	var hasStatistic: Bool
}
