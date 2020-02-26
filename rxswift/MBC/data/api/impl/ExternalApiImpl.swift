//
//  SocialShareApiImpl.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 5/4/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class ExternalApiImpl: ExternalApi {

    static fileprivate let queue = DispatchQueue(label: "requests.queue", qos: .utility)
    static fileprivate let mainQueue = DispatchQueue.main
    
    fileprivate class func make(session: URLSession = URLSession.shared, request: URLRequest,
                                closure: @escaping (_ json: [String: Any]?, _ error: Error?) -> Void) {
        let task = session.dataTask(with: request) { data, _, error in
            queue.async {
                guard error == nil else { return }
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data,
                                                                   options: .mutableContainers) as? [String: Any] {
                        mainQueue.async { closure(json, nil) }
                    }
                } catch let error {
                    print(error.localizedDescription)
                    mainQueue.async { closure(nil, error) }
                }
            }
        }
        task.resume()
    }
    
    func requestMethod(request: URLRequest, closure: @escaping (_ json: [String: Any]?, _ error: Error?) -> Void) {
        ExternalApiImpl.make(request: request) { json, error in
            closure(json, error)
        }
    }
    
    func shortenURLFrom(longURL: String, completion: @escaping (_ result: String?, _ error: Error?) -> Void) {
        guard let url = URL(string: Constants.ExternalEndpoint.googleShortenerAPI) else {
            completion(nil, nil)
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["longUrl": longURL]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.requestMethod(request: request) { dict, error in
            print(dict as Any)
            completion(dict?["id"] as? String, error)
        }
    }
}
