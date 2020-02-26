//
//  MenuInteractorImpl.swift
//  F8
//
//  Created by Dao Le Quang on 11/9/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift

class MenuInteractorImpl: MenuInteractor {
    private let pageApi: PageApi

    private let authenticationService: AuthenticationService
    
    init(pageApi: PageApi, authenticationService: AuthenticationService) {
        self.pageApi = pageApi
        self.authenticationService = authenticationService
    }

    func getFeaturePagesBy(siteName: String) -> Observable<[MenuPage]> {
        return pageApi.getFeaturePagesBy(siteName: siteName).map {
            var pages = [MenuPage]()
            for pEntity in $0 {
                pages.append(MenuPage(entity: pEntity))
            }
            return pages
        }
    }
    
    func signout() {
        authenticationService.signout()
    }
    
    var onDidSignoutSuccess: Observable<Void> {
        return authenticationService.onDidSignoutSuccess
    }
    
    var onDidSignoutError: Observable<Error> {
        return authenticationService.onDidSignoutError
    }
}
