//
//  HeaderEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/17/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class HeaderEntity {
    var liveRecord: String
    var genre: GenreEntity
    
    init(liveRecord: String, genre: GenreEntity) {
        self.liveRecord = liveRecord
        self.genre = genre
    }
}
