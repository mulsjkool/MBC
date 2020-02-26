//
//  FilterContent.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class FilterContent {
    var filterAuthors = [FilterAuthor]()
    var filterSubTypes = [FilterSubType]()
    
    var filterOccupations = [FilterOccupation]()
    var filterMonthOfBirths = [FilterMonthOfBirth]()
    
    var filterGenres = [FilterGenre]()
    var filterShowSubtypes = [FilterShowSubType]()
    
    init(filterAuthors: [FilterAuthor], filterSubTypes: [FilterSubType]) {
        self.filterAuthors = filterAuthors
        self.filterAuthors.sort {
            $0.title < $1.title
        }
        self.filterSubTypes = filterSubTypes
    }
    
    init(filterOccupations: [FilterOccupation], filterMonthOfBirths: [FilterMonthOfBirth]) {
        self.filterOccupations = filterOccupations
        self.filterOccupations.sort {
            $0.title < $1.title
        }
        self.filterMonthOfBirths = filterMonthOfBirths
    }
    
    init(filterGenres: [FilterGenre], filterShowSubtypes: [FilterShowSubType]) {
        self.filterGenres = filterGenres
        self.filterGenres.sort {
            $0.name < $1.name
        }
        self.filterShowSubtypes = filterShowSubtypes
    }
}
