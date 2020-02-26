//
//  JsonParamSerializer.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/26/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import SwiftHTTP

class JsonParamSerializer: HTTPSerializeProtocol {
    func serialize(_ request: inout URLRequest, parameters: HTTPParameterProtocol) -> Error? {
        if request.isURIParam() {
            request.appendParametersAsQueryString(parameters)
        } else {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters as AnyObject,
                                                              options: JSONSerialization.WritingOptions())
            } catch let error {
                return error
            }
        }

        return nil
    }
}
