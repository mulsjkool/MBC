//
//  ShowListingFilter.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ShowListingFilter {
    private var filterGenres = [FilterGenre]()
    private var filterSubTypes = [FilterShowSubType]()
    
    private var selectedGenre: FilterGenre?
    private var selectedSubType: FilterShowSubType?
    private var currentSortingOption: SortingOption = .defaultSorting
    private var sortingData: [String] = [R.string.localizable.commonSortingAscending(),
                                         R.string.localizable.commonSortingDescending(),
                                         R.string.localizable.commonSortingRecency()]
    private var selectedGenreIndex = -1
    private var selectedSubTypeIndex = -1
    
    init(filterGenres: [FilterGenre], filterSubTypes: [FilterShowSubType]) {
        self.filterGenres = filterGenres
        self.filterSubTypes = filterSubTypes
    }
    
    private var filteredGenres: [FilterGenre] {
        guard let subType = selectedSubType else {
            return filterGenres
        }
        guard let genres = subType.genres else {
            return [FilterGenre]()
        }
        var listGenre = [FilterGenre]()
        for genre in genres {
            for genreObj in filterGenres where genreObj.name == genre {
                listGenre.append(genreObj)
            }
        }
        return listGenre
    }
    
    private var filteredSubTypes: [FilterShowSubType] {
        guard let genre = selectedGenre else {
            return filterSubTypes
        }
        guard let listSubType = genre.subtypes else {
            return [FilterShowSubType]()
        }
        var subTypes = [FilterShowSubType]()
        for subType in listSubType {
            for subTypeObj in filterSubTypes where subType == subTypeObj.name {
                subTypes.append(subTypeObj)
            }
        }
        return subTypes
    }
    
    func paramsForListingApi() -> [String: Any] {
        var params = [String: Any]()
        if let selectedGenre = selectedGenre {
            params[FilterShowMode.filterByGenre.paramString()] = selectedGenre.id
        }
        if let selectedSubType = selectedSubType {
            params[FilterShowMode.filterBySubType.paramString()] = selectedSubType.name
        }
        params[FilterShowMode.sorting.paramString()] = currentSortingOption.sortParamValueForShowListingApi()
        return params
    }
    
    func getItemsForFilterMode(_ filterMode: FilterMode) -> [String] {
        let showFilterMode = FilterShowMode(rawValue: filterMode.rawValue) ?? FilterShowMode.none
        switch showFilterMode {
        case .filterByGenre:
            var items = filteredGenres.map({ filterGenre -> String in
                return filterGenre.name
            })
            items.insert(R.string.localizable.commonFilterAllTitle(), at: 0) // All text
            return items
        case .filterBySubType:
            var items = filteredSubTypes.map({ filterSubtype -> String in
                return filterSubtype.name.capitalizingFirstLetter()
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
        let showFilterMode = FilterShowMode(rawValue: filterMode.rawValue) ?? FilterShowMode.none
        switch showFilterMode {
        case .filterByGenre:
            selectedGenreIndex = index
            selectedGenre = (index == 0) ? nil : filteredGenres[index - 1]
        case .filterBySubType:
            selectedSubTypeIndex = index
            selectedSubType = (index == 0) ? nil : filteredSubTypes[index - 1]
        case .sorting:
            currentSortingOption = SortingOption(rawValue: index) ?? SortingOption.titleAsc
        case .none:
            break
        }
    }
    
    func getSelectedItemTextForFilter(index: Int) -> (selectedItem: String?, defaultItem: String?) {
        let showFilterMode = FilterShowMode(rawValue: index) ?? FilterShowMode.none
        switch showFilterMode {
        case .filterByGenre:
            let defaultItem = (selectedGenreIndex == -1) ?
                R.string.localizable.showListingFilterByGenre() :
                R.string.localizable.commonFilterAllTitle()
            return (selectedGenre?.name, defaultItem)
        case .filterBySubType:
            let defaultItem = (selectedGenreIndex == -1) ?
                R.string.localizable.showListingFilterBySubType() :
                R.string.localizable.commonFilterAllTitle()
            return (selectedSubType?.name, defaultItem)
        case .sorting:
            return ((currentSortingOption == .defaultSorting) ? nil : currentSortingOption.localizedString(),
                    R.string.localizable.commonSortingTitle())
        case .none:
            break
        }
        return (nil, nil)
    }
    
    func getSelectedItemIndexForFilter(index: Int) -> Int {
        let showFilterMode = FilterShowMode(rawValue: index) ?? FilterShowMode.none
        switch showFilterMode {
        case .filterByGenre:
            if let selectedGenre = selectedGenre {
                if let index = filteredGenres.index(where: { filteredGenre -> Bool in
                    return selectedGenre.id == filteredGenre.id
                }) {
                    return index + 1
                }
            }
        case .filterBySubType:
            if let selectedSubType = selectedSubType {
                if let index = filteredSubTypes.index(where: { filteredSubType -> Bool in
                    return selectedSubType.name == filteredSubType.name
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
