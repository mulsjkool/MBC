//
//  StreamEntity.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class StreamEntity {
    var items: [FeedEntity]?
    var total: Int?
    
    init(items: [FeedEntity]?, total: Int?) {
        self.items = items
        self.total = total
    }
}
