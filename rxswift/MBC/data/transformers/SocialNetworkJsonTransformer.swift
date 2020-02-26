//
//  SocialNetworkJsonTransformer.swift
//  MBC
//
//  Created by Tri Vo on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class ListSocialNetworkJsonTransformer: JsonTransformer {
	
	let socialNetworkJsonTransformer: SocialNetworkJsonTransformer
	
	init(socialNetworkJsonTransformer: SocialNetworkJsonTransformer) {
		self.socialNetworkJsonTransformer = socialNetworkJsonTransformer
	}
	
	func transform(json: JSON) -> [SocialNetworkEntity] {
		return json.arrayValue.map { socialNetworkJsonTransformer.transform(json: $0) }
	}
}

class SocialNetworkJsonTransformer: JsonTransformer {

	private static let fields = (
		accountId : "accountId",
		socialNetworkName : "socialNetworkName"
	)
	
	func transform(json: JSON) -> SocialNetworkEntity {
		
		let fields = SocialNetworkJsonTransformer.fields
		
		let accountId = json[fields.accountId].string ?? ""
		let socialNetworkName = json[fields.socialNetworkName].string ?? ""
		return SocialNetworkEntity(accountId: accountId, socialNetworkName: socialNetworkName)
	}
}
