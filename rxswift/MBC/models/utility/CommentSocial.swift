//
//  CommentSocial.swift
//  MBC
//
//  Created by Tri Vo on 2/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

struct CommentSocial {
    var userId: String
    var contentId: String
    var siteName: String
	var fromIndex: Double
	var size: Int
	
	mutating func setFromIndex(_ data: Double) {
		self.fromIndex = data
	}
	
	mutating func setSize(_ data: Int) {
		self.size = data
	}
}
