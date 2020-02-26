//
//  FacebookConnectionService.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import FBSDKCoreKit

protocol FacebookConnectionService {
    var currentToken: FBSDKAccessToken? { get }
    
    func loginToFacebook(viewController: UIViewController) -> Observable<(fbId: String, fbToken: String)>
    func getFacebookUserProfile(fbId: String, fbToken: String) -> Observable<FacebookProfile>
    func logOut()
}
