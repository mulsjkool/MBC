//
//  Array+Extension.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/14/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

extension Array {
    func removeDuplicates<T: Hashable> (map: ((Element) -> (T))) -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
