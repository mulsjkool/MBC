//
//  NetworkingService.swift
//  MBC
//
//  Created by Dao Le Quang on 11/23/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkingService {
    var isConnected: Bool { get }
    var connected: Observable<Bool> { get }
}
