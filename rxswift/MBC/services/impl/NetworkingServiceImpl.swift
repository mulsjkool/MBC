//
//  NetworkingServiceImpl.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/12/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import Reachability
import RxSwift

class NetworkingServiceImpl: NetworkingService {
    fileprivate let reachability: Reachability
    fileprivate let networkStatusSubject = BehaviorSubject(value: false)

    var connected: Observable<Bool> {
        return networkStatusSubject.asObservable()
    }

    var isConnected: Bool = false

    init() {
        reachability = Reachability()!

        reachability.whenReachable = { reachability in
            self.networkStatusSubject.onNext(true)
            self.isConnected = true
        }
        reachability.whenUnreachable = { reachability in
            self.networkStatusSubject.onNext(false)
            self.isConnected = false
        }

        try? reachability.startNotifier()
    }
}
