//
//  FilterContentEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class FilterContentEntity {
    var filterAuthors: [FilterAuthorEntity]?
    var filterSubTypes: [FilterSubTypeEntity]?
    
    var filterOccupations: [FilterOccupationEntity]?
    var filterMonthOfBirths: [FilterMonthOfBirthEntity]?
    
    var filterGenres: [FilterGenreEntity]?
    var filterShowSubTypes: [FilterShowSubTypeEntity]?
    
    init(filterAuthors: [FilterAuthorEntity]?, filterSubTypes: [FilterSubTypeEntity]?,
         filterOccupations: [FilterOccupationEntity]?, filterMonthOfBirths: [FilterMonthOfBirthEntity]?,
         filterGenres: [FilterGenreEntity]?, filterShowSubTypes: [FilterShowSubTypeEntity]?) {
        self.filterAuthors = filterAuthors
        self.filterSubTypes = filterSubTypes
        self.filterOccupations = filterOccupations
        self.filterMonthOfBirths = filterMonthOfBirths
        self.filterGenres = filterGenres
        self.filterShowSubTypes = filterShowSubTypes
    }
}
