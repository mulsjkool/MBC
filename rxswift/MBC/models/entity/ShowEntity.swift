//
//  ShowEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class ShowEntity {
    var id: String
    var title: String
    var logo: String
    var gender: String?
    var season: String?
    var sequenceNumber: String?
    var about: String
    var poster: String
    var label: String?
    var genre: GenreShowEntity
    
    init(id: String, title: String, gender: String?, logo: String, season: String?, sequenceNumber: String?,
         about: String, poster: String, label: String?, genre: GenreShowEntity) {
        self.id = id
        self.title = title
        self.logo = logo
        self.gender = gender
        self.season = season
        self.sequenceNumber = sequenceNumber
        self.about = about
        self.poster = poster
        self.label = label
        self.genre = genre
    }
}
