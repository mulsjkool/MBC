//
//  StarListingFilter.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class StarListingFilter {
    private var filterMonthOfBirths = [FilterMonthOfBirth]()
    private var filterOccupations = [FilterOccupation]()
    private var selectedMonthOfBirth: FilterMonthOfBirth?
    private var selectedOccupation: FilterOccupation?
    private var currentSortingOption: SortingOption = .defaultSorting
    private var sortingData: [String] = [R.string.localizable.commonSortingAscending(),
                                 R.string.localizable.commonSortingDescending()]
    private var selectedMonthOfBirthIndex = -1
    private var selectedOccupationIndex = -1
    
    init(filterMonthOfBirths: [FilterMonthOfBirth], filterOccupations: [FilterOccupation]) {
        self.filterMonthOfBirths = filterMonthOfBirths
        self.filterOccupations = filterOccupations
    }
    
    private var filteredMonthOfBirths: [FilterMonthOfBirth] {
        guard let occupation = selectedOccupation else {
            return filterMonthOfBirths
        }
        guard let monthOfBirthArray = occupation.monthOfBirthArray else {
            return [FilterMonthOfBirth]()
        }
        var arrayTemp = [FilterMonthOfBirth]()
        for item in monthOfBirthArray {
            for monthOfBirth in filterMonthOfBirths where item == monthOfBirth.name {
                arrayTemp.append(monthOfBirth)
            }
        }
        return arrayTemp
    }
    
    private var filteredOccupations: [FilterOccupation] {
        guard let monthOfBirth = selectedMonthOfBirth else {
            return filterOccupations
        }
        guard let occupationArray = monthOfBirth.occupationArray else {
            return [FilterOccupation]()
        }
        var arrayTemp = [FilterOccupation]()
        for item in occupationArray {
            for occupation in filterOccupations where item == occupation.name {
                arrayTemp.append(occupation)
            }
        }
        return arrayTemp
    }
    
    func paramsForListingApi() -> [String: Any] {
        var params = [String: Any]()
        if let selectedMonthOfBirth = selectedMonthOfBirth {
            params[FilterStarMode.filterByMonthOfBirth.paramString()] = selectedMonthOfBirth.name
        }
        if let selectedOccupation = selectedOccupation {
            params[FilterStarMode.filterByOccupation.paramString()] = selectedOccupation.name
        }
        params[FilterStarMode.sorting.paramString()] = currentSortingOption.sortParamValueForStarListingApi()
        return params
    }
    
    func getItemsForFilterMode(_ filterMode: FilterMode) -> [String] {
        let starFilterMode = FilterStarMode(rawValue: filterMode.rawValue) ?? FilterStarMode.none
        switch starFilterMode {
        case .filterByMonthOfBirth:
            var items = filteredMonthOfBirths.map({ filterMonthOfBirth -> String in
                return filterMonthOfBirth.title
            })
            items.insert(R.string.localizable.commonFilterAllTitle(), at: 0) // All text
            return items
        case .filterByOccupation:
            var items = filteredOccupations.map({ filterOccupation -> String in
                return filterOccupation.title
            })
            items.insert(R.string.localizable.commonFilterAllTitle(), at: 0) // All text
            return items
        case .sorting:
            return sortingData
        case .none:
            break
        }
        return []
    }
    
    func selectRow(index: Int, filterMode: FilterMode) {
        let starFilterMode = FilterStarMode(rawValue: filterMode.rawValue) ?? FilterStarMode.none
        switch starFilterMode {
        case .filterByMonthOfBirth:
            selectedMonthOfBirthIndex = index
            selectedMonthOfBirth = (index == 0) ? nil : filteredMonthOfBirths[index - 1]
        case .filterByOccupation:
            selectedOccupationIndex = index
            selectedOccupation = (index == 0) ? nil : filteredOccupations[index - 1]
        case .sorting:
            currentSortingOption = SortingOption(rawValue: index) ?? SortingOption.titleAsc
        case .none:
            break
        }
    }
    
    func getSelectedItemTextForFilter(index: Int) -> (selectedItem: String?, defaultItem: String?) {
        let starFilterMode = FilterStarMode(rawValue: index) ?? FilterStarMode.none
        switch starFilterMode {
        case .filterByMonthOfBirth:
            let defaultItem = (selectedMonthOfBirthIndex == -1) ?
                R.string.localizable.starPageListingFilterByMonthOfBirth() :
                R.string.localizable.commonFilterAllTitle()
            return (selectedMonthOfBirth?.title, defaultItem)
        case .filterByOccupation:
            let defaultItem = (selectedOccupationIndex == -1) ?
                R.string.localizable.starPageListingFilterByOccupation() :
                R.string.localizable.commonFilterAllTitle()
            return (selectedOccupation?.title, defaultItem)
        case .sorting:
            return ((currentSortingOption == .defaultSorting) ? nil : currentSortingOption.localizedString(),
                    R.string.localizable.commonSortingTitle())
        case .none:
            break
        }
        return (nil, nil)
    }
    
    func getSelectedItemIndexForFilter(index: Int) -> Int {
        let starFilterMode = FilterStarMode(rawValue: index) ?? FilterStarMode.none
        switch starFilterMode {
        case .filterByMonthOfBirth:
            if let selectedMonthOfBirth = selectedMonthOfBirth {
                if let index = filteredMonthOfBirths.index(where: { filteredMonthOfBirth -> Bool in
                    return selectedMonthOfBirth.name == filteredMonthOfBirth.name
                }) {
                    return index + 1
                }
            }
        case .filterByOccupation:
            if let selectedOccupation = selectedOccupation {
                if let index = filteredOccupations.index(where: { filteredOccupation -> Bool in
                    return selectedOccupation.name == filteredOccupation.name
                }) {
                    return index + 1
                }
            }
        case .sorting:
            return currentSortingOption.rawValue
        case .none:
            break
        }
        return -1
    }
}
