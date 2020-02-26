//
//  TagGTMService.swift
//  MBC
//
//  Created by Tri Vo on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import GoogleTagManager

@objc(TagGTMService)
final class TagGTMService: NSObject, TAGCustomFunction {

	func execute(withParameters parameters: [AnyHashable: Any]!) -> NSObject! {
//		if Constants.Singleton.lotemaParams.isEmpty {
		Constants.Singleton.lotemaParams = parameters
//	}
		return nil
	}
}
