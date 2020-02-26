//
//  MenuInteractor.swift
//  F8
//
//  Created by Dao Le Quang on 11/9/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift

protocol MenuInteractor {
    func getFeaturePagesBy(siteName: String) -> Observable<[MenuPage]>
    func signout()
    
    var onDidSignoutError: Observable<Error> { get }
    var onDidSignoutSuccess: Observable<Void> { get }
}
