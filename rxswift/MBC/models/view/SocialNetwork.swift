//
//  SocialNetwork.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class SocialNetwork: Codable {
    var accountId: String?
    var socialNetworkName = SocialNetworkEnum.unknown
    
    private let fields = (
        accountId: "accountId",
        socialNetworkName: "socialNetworkName"
    )
    
    init(dictionary: [String: String?]) {
        self.accountId = dictionary[fields.accountId] as? String
        guard let socialNetworkName = dictionary[fields.socialNetworkName] as? String else {
            return
        }
        self.socialNetworkName = SocialNetworkEnum(rawValue: socialNetworkName) ?? SocialNetworkEnum.unknown
    }
	
	init(entity: SocialNetworkEntity) {
		self.accountId = entity.accountId
		self.socialNetworkName = SocialNetworkEnum(rawValue: entity.socialNetworkName) ?? SocialNetworkEnum.unknown
	}
	
	private enum CodingKeys: String, CodingKey {
		case accountId
		case socialNetworkName
	}
}
