//
//  ListingEnum.swift
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
    
    func sortParamValueForShowListingApi() -> String {
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

enum ListingType: Int {
    case appAndGame = 0
    case star = 1
    case showAndProgram = 2
}

enum FilterAppMode: Int {
    case filterByType = 0
    case filterByAuthor = 1
    case sorting = 2
    case none = -1
    
    func paramString() -> String {
        switch self {
        case .filterByType:
            return "contentSubtype"
        case .filterByAuthor:
            return "authorId"
        case .sorting:
            return "sort"
        case .none:
            return ""
        }
    }
}

enum FilterStarMode: Int {
    case filterByMonthOfBirth = 0
    case filterByOccupation = 1
    case sorting = 2
    case none = -1
    
    func paramString() -> String {
        switch self {
        case .filterByMonthOfBirth:
            return "monthOfBirth"
        case .filterByOccupation:
            return "occupation"
        case .sorting:
            return "sort"
        case .none:
            return ""
        }
    }
}

enum FilterShowMode: Int {
    case filterBySubType = 0
    case filterByGenre = 1
    case sorting = 2
    case none = -1
    
    func paramString() -> String {
        switch self {
        case .filterBySubType:
            return "subTypes"
        case .filterByGenre:
            return "genre"
        case .sorting:
            return "sort"
        case .none:
            return ""
        }
    }
}

enum FilterMode: Int {
    case filter1 = 0
    case filter2 = 1
    case filter3 = 2
    case none = -1
    
    func paramString(listingType: ListingType) -> String {
        switch listingType {
        case .appAndGame:
            if let filter = FilterAppMode(rawValue: self.rawValue) {
                return filter.paramString()
            }
        case .star:
            if let filter = FilterStarMode(rawValue: self.rawValue) {
                return filter.paramString()
            }
        case .showAndProgram:
            if let filter = FilterShowMode(rawValue: self.rawValue) {
                return filter.paramString()
            }
        }
        return ""
    }
}
