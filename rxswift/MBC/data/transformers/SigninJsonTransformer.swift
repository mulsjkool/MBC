//
//  SigninJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import SwiftyJSON

class SigninJsonTransformer: JsonTransformer {
    private static let fields = (
        value : "value",
        username : "username"
    )
    
    func transform(json: JSON) -> SigninEntity {
        let fields = SigninJsonTransformer.fields
        
        let value = json[fields.value].string ?? ""
        let username = json[fields.username].string ?? ""

        return SigninEntity(value: value, username: username)
    }
}
