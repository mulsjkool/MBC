//
//  ApiClientImpl.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/12/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift
import SwiftHTTP
import SwiftyJSON

class ApiClientImpl: ApiClient {
    private static let HeaderValueContentType = "application/vnd.mbc.v1+json;charset=UTF-8"
    private static let HeaderValueAuthorization = "Bearer %@"
    
    private static let HeaderKeyAccept = "Accept"
    private static let HeaderKeyContentType = "Content-Type"
    private static let HeaderKeyAuthorization = "Authorization"
    private static let HeaderKeyUserCountry = "userCountry"
    
    private static let BadCredentialsException = "org.springframework.security.authentication.BadCredentialsException"

    private let networkingService: NetworkingService
    private var sessionService: SessionService
    
    let baseUrl: String

    init(baseUrl: String, networkingService: NetworkingService, sessionService: SessionService) {
        self.networkingService = networkingService
        self.sessionService = sessionService

        self.baseUrl = baseUrl
    }

    func request<T>(_ method: HTTPMethod, url: String, fullUrl: Bool = false, parameters: [String: Any]?,
                    isJsonParams: Bool = true, errorHandler: ((Int, Error) -> Error)?,
                    parse: @escaping (JSON) -> T) -> Observable<T> {
        return request(method, url: url, fullUrl: fullUrl, parameters: parameters,
                       isJsonParams: isJsonParams, isBinary: false, contentType: nil,
                       errorHandler: errorHandler, parse: parse)
    }

    // swiftlint:disable:next cyclomatic_complexity function_parameter_count function_body_length
    private func request<T>(_ method: HTTPMethod, url: String, fullUrl: Bool = false,
                            parameters: [String: Any]?, isJsonParams: Bool = true,
                            isBinary: Bool, contentType: String?, progress: ((Float) -> Void)? = nil,
                            errorHandler: ((_ statusCode: Int, _ error: Error) -> Error)? = nil,
                            parse: @escaping (_ data: JSON) -> T) -> Observable<T> {

        return networkingService.connected.take(1).flatMapLatest { connected -> Observable<T> in

            if !connected { throw NetworkError.networkNotAvailable }

            var headers = [ApiClientImpl.HeaderKeyAccept: ApiClientImpl.HeaderValueContentType]

            if isJsonParams { headers[ApiClientImpl.HeaderKeyContentType] = ApiClientImpl.HeaderValueContentType }
            
            if self.sessionService.isSessionValid(), let token = self.sessionService.accessToken {
                headers[ApiClientImpl.HeaderKeyAuthorization] =
                    String(format: ApiClientImpl.HeaderValueAuthorization, token)
            }
            
            //debugPrint("accessToken: \(self.sessionService.accessToken ?? "")")
            let requestedUrl = fullUrl ? url : self.baseUrl + url
            print("\(Date())-DEBUG-begin-requestedUrl = \(requestedUrl) and params: \(parameters ?? [String: Any]())")
            
            func createHTTPRequest(urlString: String, method: HTTPMethod, param: [String: Any]?,
                                   isBinary: Bool) -> HTTP {
                var request: HTTP!
                switch method {
                case .get:
                    request = HTTP.New(requestedUrl, method: .GET,
                                       parameters: parameters, headers: headers,
                                       requestSerializer: JsonParamSerializer())
                case .post:
                    request = HTTP.New(requestedUrl, method: .POST,
                                       parameters: parameters, headers: headers,
                                       requestSerializer: JsonParamSerializer())
                case .delete:
                    request = HTTP.New(requestedUrl, method: .DELETE,
                                       parameters: parameters, headers: headers,
                                       requestSerializer: JsonParamSerializer())
                case .put:
                    if isBinary {
                        if contentType != nil {
                            headers = [ApiClientImpl.HeaderKeyContentType: contentType!]
                        }
                        request = HTTP.New(requestedUrl, method: .PUT,
                                           parameters: parameters, headers: headers,
                                           requestSerializer: BinaryParamSerializer())
                    } else {
                        request = HTTP.New(requestedUrl, method: .PUT,
                                           parameters: parameters, headers: headers,
                                           requestSerializer: JsonParamSerializer())
                    }
                }
                return request
            }

            return Observable.create { observer in

                let request = createHTTPRequest(urlString: requestedUrl, method: method,
                                                param: parameters, isBinary: isBinary)
                if let uploadProgress = progress { request.progress = uploadProgress }

                request.run { [unowned self] response in
                    // Error case
                    if let error = response.error {

                        if let errorHandler = errorHandler,
                            let statusCode = response.statusCode,
                            let responseText = response.text,
                            let data = responseText.data(using: .utf8, allowLossyConversion: false) {
                            if let json = try? JSON(data: data) {
                                print("\(Date())-DEBUG-done-requestedUrl=\(requestedUrl) and" +
                                    " params: \(parameters ?? [String: Any]())")
                                print("DEBUG statusCode = \(String(describing: response.statusCode))")
                                print("DEBUG ERROR JSON = \(String(describing: json))")
                                var error = self.parseError(statusCode: statusCode, json: json)
                                if statusCode == 403 { error = ApiError.forbidden(description: "") }
                                DispatchQueue.main.async { observer.onError(errorHandler(statusCode, error)) }
                                return
                            }
                        }

                        DispatchQueue.main.async { observer.onError(error) }
                        return
                    }

                    // Happy case
                    
                    self.storeGeoLocation(requestedUrl: requestedUrl, response: response)
                    
                    let data = response.text!.data(using: .utf8, allowLossyConversion: false)!
                    if let json = try? JSON(data: data) {
                        print("\(Date())-DEBUG-done-requestedUrl=\(requestedUrl) and" +
                            " params: \(parameters ?? [String: Any]())")
                        print("DEBUG statusCode = \(String(describing: response.statusCode))")
                        print("DEBUG DATA JSON = \(String(describing: json))")
                        if let statusCode = response.statusCode, statusCode != 200, statusCode != 201 {
                            let error = self.parseError(statusCode: statusCode, json: json)

                            if let errorHandler = errorHandler {
                                DispatchQueue.main.async { observer.onError(errorHandler(statusCode, error)) }
                                return
                            }
                            DispatchQueue.main.async { observer.onError(error) }
                            return
                        }

                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                            let result = parse(json)

                            DispatchQueue.main.async {
                                observer.on(Event.next(result))
                                observer.on(Event.completed)
                            }
                        }
                    }
                }

                return Disposables.create { request.cancel() }
            }
            .retryWhen { (err: Observable<Error>) -> Observable<Void> in
                return err.flatMap { error -> Observable<Void> in
                    print("DEBUG: Calling Api error: \((error as NSError).description) -- RETRYING...")
                    
                    if let error = error as? ApiError, error.errorCode == 403 {
                        print("DEBUG: retryWhen -- ERROR 403")

                        return Components.authenticationService.refreshToken()
                    }
                    return Observable.error(error)
                }
            }
        }
    }

    func get<T>(_ url: String, parameters: [String: Any]?,
                errorHandler: ((_ statusCode: Int, _ error: Error) -> Error)? = nil,
                parse: @escaping (_ data: JSON) -> T) -> Observable<T> {
        return request(.get, url: url, parameters: parameters, errorHandler: errorHandler, parse: parse)
    }

    func post<T>(_ url: String, parameters: [String: Any]?, isJsonParams: Bool,
                 errorHandler: ((_ statusCode: Int, _ error: Error) -> Error)? = nil,
                 parse: @escaping (_ data: JSON) -> T) -> Observable<T> {
        return request(.post, url: url, parameters: parameters, isJsonParams: isJsonParams,
                       errorHandler: errorHandler, parse: parse)
    }

    func post<T>(_ url: String, parameters: [String: Any]?,
                 errorHandler: ((_ statusCode: Int, _ error: Error) -> Error)? = nil,
                 parse: @escaping (_ data: JSON) -> T) -> Observable<T> {
        return post(url, parameters: parameters, isJsonParams: true, errorHandler: errorHandler, parse: parse)
    }

    func put<T>(_ url: String, parameters: [String: Any]?,
                errorHandler:((_ statusCode: Int, _ error: Error) -> Error)?,
                parse: @escaping (_ data: JSON) -> T) -> Observable<T> {
        return request(.put, url: url, parameters: parameters, errorHandler: errorHandler, parse: parse)
    }

    // swiftlint:disable:next function_parameter_count
    func upload<T>(_ url: String, file: Data, contentType: String, parameters: [String: Any]?,
                   progress: ((Float) -> Void)? = nil, errorHandler: ((Int, Error) -> Error)?,
                   parse: @escaping (JSON) -> T) -> Observable<T> {
        var params: [String: Any] = [:]
        params["file"] = file
        return request(.put, url: url, fullUrl: true, parameters: params, isJsonParams: false, isBinary: true,
                       contentType: contentType, progress: progress, errorHandler: errorHandler, parse: parse)
    }

    func delete<T>(_ url: String, parameters: [String: Any]?,
                   errorHandler: ((Int, Error) -> Error)?, parse: @escaping (JSON) -> T) -> Observable<T> {
        return request(.delete, url: url, parameters: parameters, errorHandler: errorHandler, parse: parse)
    }

    fileprivate func parseError(statusCode: Int, json: JSON) -> ApiError {
        let code = json["code"].string ?? json["status"].stringValue
        let description = json["message"].stringValue
        
        if json["exception"].stringValue == ApiClientImpl.BadCredentialsException {
            Components.analyticsService.logEvent(trackingObject: AnalyticsError(errorCode: 403,
                                                                                errorDescription: description))

            return ApiError.forbidden(description: description)
        }

        Components.analyticsService.logEvent(trackingObject: AnalyticsError(errorCode: statusCode,
                                                                            errorDescription: description))
        
        switch statusCode {
        case 400:
            return ApiError.badRequest(description: description)
        case 401:
            return ApiError.authenticationFailure(description: description)
        case 403:
            return ApiError.forbidden(description: description)
        /*case 500:
            return ApiError.internalServerError(description: description)*/
        default:
            return ApiError.other(code: Int(code) ?? 500, description: description)
        }
    }
    
    private func storeGeoLocation (requestedUrl: String, response: SwiftHTTP.Response) {
        guard requestedUrl.range(of: SigninApiImpl.signinPath) != nil,
            let headers = response.headers,
            let headerContryCode = headers[ApiClientImpl.HeaderKeyUserCountry] else { return }
            self.sessionService.headerContryCode = headerContryCode
    }
}
