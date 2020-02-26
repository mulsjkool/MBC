//
//  JsonTransformer.swift
//  F8
//
//  Created by Tuyen Nguyen Thanh on 10/13/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonTransformer {
    associatedtype Model
    func transform(json: JSON) -> Model
}
