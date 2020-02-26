//
//  DataApi.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 5/4/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol ExternalApi {
    func shortenURLFrom(longURL: String, completion: @escaping (_ result: String?, _ error: Error?) -> Void)
}
