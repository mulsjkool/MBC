//
//  SocialNetworkEntity.swift
//  MBC
//
//  Created by Tri Vo on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class SocialNetworkEntity {
	var accountId: String
	var socialNetworkName: String
	
	init(accountId: String, socialNetworkName: String) {
		self.accountId = accountId
		self.socialNetworkName = socialNetworkName
	}
}
