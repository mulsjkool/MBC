//
//  SortingType.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum SortingOption: Int {
    case titleAsc = 0
    case titleDesc = 1
    case publishedDateDesc = 2
    case defaultSorting = 3
    
    func sortParamValueForAppListingApi() -> String {
        switch self {
        case .titleAsc:
            return "properties.title:asc"
        case .titleDesc:
            return "properties.title:desc"
        case .publishedDateDesc:
            return "publishedDate:desc"
        case .defaultSorting:
            return "properties.title:asc"
        }
    }
    
    func sortParamValueForStarListingApi() -> String {
        switch self {
        case .titleAsc:
            return "properties.info.title:asc"
        case .titleDesc:
            return "properties.info.title:desc"
        case .publishedDateDesc:
            return "publishedDate:desc"
        case .defaultSorting:
            return "properties.info.title:asc"
        }
    }
    
    func localizedString() -> String {
        switch self {
        case .titleAsc:
            return R.string.localizable.commonSortingAscending()
        case .titleDesc:
            return R.string.localizable.commonSortingDescending()
        case .publishedDateDesc:
            return R.string.localizable.commonSortingRecency()
        case .defaultSorting:
            return R.string.localizable.commonSortingTitle()
        }
    }
}

enum FilterAppSortingMode: Int {
    case filterByType = 0
    case filterByAuthor = 1
    case sorting = 2
    case none = 3
}

enum FilterStarSortingMode: Int {
    case filterByMonthOfBirth = 0
    case filterByOccupation = 1
    case sorting = 2
    case none = 3
}
