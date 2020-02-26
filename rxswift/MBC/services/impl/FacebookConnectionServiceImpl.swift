//
//  FacebookConnectionServiceImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import FBSDKCoreKit

import RxSwift

class FacebookConnectionServiceImpl: FacebookConnectionService {
    private let readPermissions = ["public_profile", "email", "user_birthday"]

    private var accessToken: FBSDKAccessToken?

    func loginToFacebook(viewController: UIViewController) -> Observable<(fbId: String, fbToken: String)> {
        return Observable.create { observer in
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: self.readPermissions, from: viewController,
                               handler: { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
                guard error == nil, let result = result else {
                    observer.onError(FacebookError.failed)
                    return
                }
                if result.isCancelled {
                    observer.onError(FacebookError.cancelled)
                } else {
                    self.accessToken = result.token
                    observer.onNext((fbId: self.accessToken!.userID, fbToken: self.accessToken!.tokenString))
                    observer.onCompleted()
                }
            })
            return Disposables.create {}
        }
            .share(replay: 1)
    }

    func logOut() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    var currentToken: FBSDKAccessToken? {
        return accessToken
    }

    func getFacebookUserProfile(fbId: String, fbToken: String) -> Observable<FacebookProfile> {
        return Observable.create { observer in
            let request = FBSDKGraphRequest(graphPath: "me",
                                            parameters: ["fields": "email,name,birthday,gender"],
                                            tokenString: fbToken,
                                            version: nil,
                                            httpMethod: "GET")!

            request.start { _, result, error in
                guard error == nil else { return observer.onError(FacebookError.invalidAuthentication) }

                if let dic = result as? NSDictionary {
                    print("DIC = \(dic)")
                    let name = dic["name"] as? String
                    var birthday: Date?
                    if let birth = dic["birthday"] as? String {
                        birthday = Date.dateFromString(string: birth, format: "MM/dd/yyyy")
                    }
                    var gender: String?
                    if let gen = dic["gender"] as? String {
                        gender = gen
                    }
                    var email = ""
                    if let profileEmail = dic["email"] as? String {
                        email = profileEmail
                    }

                    observer.onNext(FacebookProfile(fbId: fbId,
                                                    fbToken: fbToken,
                                                    name: name,
                                                    email: email,
                                                    gender: gender,
                                                    birthday: birthday))
                    observer.onCompleted()
                }
            }

            return Disposables.create {}
        }
            .share(replay: 1)
    }
}
