//
//  BinaryParamSerializer.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 11/14/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import SwiftHTTP

class BinaryParamSerializer: HTTPSerializeProtocol {
    func serialize(_ request: inout URLRequest, parameters: HTTPParameterProtocol) -> Error? {
        if let params = parameters as? [String: Data], let file = params["file"] {
            request.httpBody = file
        }

        return nil
    }
}
