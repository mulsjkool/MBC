//
//  ListingFilter.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ListingFilter {
    var filterData: Any?
    var activeFilterMode: FilterMode = .none
    
    init(filterContent: FilterContent, listingType: ListingType) {
        switch listingType {
        case .appAndGame:
            self.filterData = AppListingFilter(filterAuthors: filterContent.filterAuthors,
                                               filterSubTypes: filterContent.filterSubTypes)
        case .star:
            self.filterData = StarListingFilter(filterMonthOfBirths: filterContent.filterMonthOfBirths,
                                                filterOccupations: filterContent.filterOccupations)
        case .showAndProgram:
            self.filterData = ShowListingFilter(filterGenres: filterContent.filterGenres,
                                                filterSubTypes: filterContent.filterShowSubtypes)
        }
    }

    func paramsForListingApi() -> [String: Any]? {
        guard let filterData = filterData else { return nil }
        if let appFilterData = filterData as? AppListingFilter {
            return appFilterData.paramsForListingApi()
        }
        if let starFilterData = filterData as? StarListingFilter {
            return starFilterData.paramsForListingApi()
        }
        if let showFilterData = filterData as? ShowListingFilter {
            return showFilterData.paramsForListingApi()
        }
        return nil
    }
    
    func selectRow(index: Int) {
        guard let filterData = filterData else { return }
        if let appFilterData = filterData as? AppListingFilter {
            return appFilterData.selectRow(index: index, filterMode: activeFilterMode)
        }
        if let starFilterData = filterData as? StarListingFilter {
            return starFilterData.selectRow(index: index, filterMode: activeFilterMode)
        }
        if let showFilterData = filterData as? ShowListingFilter {
            return showFilterData.selectRow(index: index, filterMode: activeFilterMode)
        }
    }
    
    func getItemsForCurrentFilter() -> [String] {
        guard let filterData = filterData else { return [] }
        if let appFilterData = filterData as? AppListingFilter {
            return appFilterData.getItemsForFilterMode(activeFilterMode)
        }
        if let starFilterData = filterData as? StarListingFilter {
            return starFilterData.getItemsForFilterMode(activeFilterMode)
        }
        if let showFilterData = filterData as? ShowListingFilter {
            return showFilterData.getItemsForFilterMode(activeFilterMode)
        }
        return []
    }
    
    func getSelectedItemTextForFilter(index: Int) -> (selectedItem: String?, defaultItem: String?) {
        guard let filterData = filterData else { return (nil, nil) }
        if let appFilterData = filterData as? AppListingFilter {
            return appFilterData.getSelectedItemTextForFilter(index: index)
        }
        if let starFilterData = filterData as? StarListingFilter {
            return starFilterData.getSelectedItemTextForFilter(index: index)
        }
        if let showFilterData = filterData as? ShowListingFilter {
            return showFilterData.getSelectedItemTextForFilter(index: index)
        }
        return (nil, nil)
    }
    
    func resetData() {
        filterData = nil
    }
    
    func getSelectedItemIndexForFilter(index: Int) -> Int {
        guard let filterData = filterData else { return -1 }
        if let appFilterData = filterData as? AppListingFilter {
            return appFilterData.getSelectedItemIndexForFilter(index: index)
        }
        if let starFilterData = filterData as? StarListingFilter {
            return starFilterData.getSelectedItemIndexForFilter(index: index)
        }
        if let showFilterData = filterData as? ShowListingFilter {
            return showFilterData.getSelectedItemIndexForFilter(index: index)
        }
        return -1
    }
}
