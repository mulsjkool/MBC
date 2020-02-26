//
//  ApiError.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/12/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case badRequest(description: String) // 400
    case authenticationFailure(description: String) // 401
    case forbidden(description: String) // 403
    case internalServerError(description: String) // 500
    case other(code: Int, description: String)
    case dataNotAvailable(description: String)

    var description: String {
        switch self {
        case .badRequest(let description):
            return description
        case .authenticationFailure(let description):
            return description
        case .forbidden(let description):
            return description
        case .internalServerError(let description):
            return description
        case .other(_, let description):
            return description
        case .dataNotAvailable(let description):
            return description
        }
    }

    var errorCode: Int {
        switch self {
        case .badRequest:
            return 400
        case .authenticationFailure:
            return 401
        case .forbidden:
            return 403
        case .internalServerError:
            return 500
        case .other(let code, _):
            return code
        case .dataNotAvailable:
            return -1000
        }
    }
}
