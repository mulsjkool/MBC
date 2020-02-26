//
//  ApiClient.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/12/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

enum HTTPMethod {
    case get
    case post
    case delete
    case put
}

protocol ApiClient {
    // swiftlint:disable:next function_parameter_count
    func request<T>(_ method: HTTPMethod, url: String, fullUrl: Bool,
                    parameters: [String: Any]?, isJsonParams: Bool,
                    errorHandler: ((_ statusCode: Int, _ error: Error) -> Error)?,
                    parse: @escaping (_ data: JSON) -> T) -> Observable<T>

    func get<T>(_ url: String, parameters: [String: Any]?,
                errorHandler: ((_ statusCode: Int, _ error: Error) -> Error)?,
                parse: @escaping (_ data: JSON) -> T) -> Observable<T>

    func post<T>(_ url: String, parameters: [String: Any]?, isJsonParams: Bool,
                 errorHandler:((_ statusCode: Int, _ error: Error) -> Error)?,
                 parse: @escaping (_ data: JSON) -> T) -> Observable<T>

    func post<T>(_ url: String, parameters: [String: Any]?,
                 errorHandler:((_ statusCode: Int, _ error: Error) -> Error)?,
                 parse: @escaping (_ data: JSON) -> T) -> Observable<T>

    func put<T>(_ url: String, parameters: [String: Any]?,
                errorHandler:((_ statusCode: Int, _ error: Error) -> Error)?,
                parse: @escaping (_ data: JSON) -> T) -> Observable<T>

    func delete<T>(_ url: String, parameters: [String: Any]?,
                   errorHandler:((_ statusCode: Int, _ error: Error) -> Error)?,
                   parse: @escaping (_ data: JSON) -> T) -> Observable<T>

    // swiftlint:disable:next function_parameter_count
    func upload<T>(_ url: String, file: Data, contentType: String, parameters: [String: Any]?,
                   progress: ((Float) -> Void)?, errorHandler:((_ statusCode: Int, _ error: Error) -> Error)?,
                   parse: @escaping (_ data: JSON) -> T) -> Observable<T>
}
