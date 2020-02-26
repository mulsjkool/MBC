//
//  Matchable+Extension.swift
//  MBCTests
//
//  Created by Dao Le Quang on 12/21/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
@testable import MBC
import Cuckoo
import RxSwift
import RxBlocking
import XCTest

extension PageMenuEnum: Matchable {
    public var matcher: ParameterMatcher<PageMenuEnum> {
        return ParameterMatcher { $0.rawValue == self.rawValue }
    }
}

extension PageDetail: Matchable {
    public var matcher: ParameterMatcher<PageDetail> {
        return ParameterMatcher { $0.entityId == self.entityId }
    }
}

extension Array: Matchable {
    public var matcher: ParameterMatcher<Array> {
        return ParameterMatcher { $0.count == self.count }
    }
}

extension Optional: Matchable {
    public var matcher: ParameterMatcher<Optional> {
        return ParameterMatcher<Optional> { (($0 == nil && self == nil) || ($0 != nil && self != nil)) }
    }
}
