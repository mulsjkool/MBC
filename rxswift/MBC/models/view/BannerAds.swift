//
//  BannerAds.swift
//  MBC
//
//  Created by Tri Vo on 3/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class BannerAds: Codable {

	var size: CGSize
	
	init(size: CGSize = .zero) {
		self.size = size
	}
}
