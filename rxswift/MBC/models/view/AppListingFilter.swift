//
//  AppListingFilter.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class AppListingFilter {
    private var filterAuthors = [FilterAuthor]()
    private var filterSubTypes = [FilterSubType]()
    
    private var selectedAuthor: FilterAuthor?
    private var selectedSubType: FilterSubType?
    private var currentSortingOption: SortingOption = .defaultSorting
    private var sortingData: [String] = [R.string.localizable.commonSortingAscending(),
                                         R.string.localizable.commonSortingDescending(),
                                         R.string.localizable.commonSortingRecency()]
    
    private var selectedAuthorIndex = -1
    private var selectedSubTypeIndex = -1
    
    init(filterAuthors: [FilterAuthor], filterSubTypes: [FilterSubType]) {
        self.filterAuthors = filterAuthors
        self.filterSubTypes = filterSubTypes
    }
    
    private var filteredAuthors: [FilterAuthor] {
        guard let subType = selectedSubType else {
            return filterAuthors
        }
        guard let mapSubTypes = subType.mapSubTypes else {
            return [FilterAuthor]()
        }
        var authors = [FilterAuthor]()
        for mapSubType in mapSubTypes {
            for author in filterAuthors where author.id == mapSubType.id {
                authors.append(author)
            }
        }
        return authors
    }
    
    private var filteredSubTypes: [FilterSubType] {
        guard let author = selectedAuthor else {
            return filterSubTypes
        }
        guard let listSubType = author.listSubType else {
            return [FilterSubType]()
        }
        var subTypes = [FilterSubType]()
        for subType in listSubType {
            for filterSubType in filterSubTypes where subType == filterSubType.type {
                subTypes.append(filterSubType)
            }
        }
        return subTypes
    }
    
    func paramsForListingApi() -> [String: Any] {
        var params = [String: Any]()
        if let selectedAuthor = selectedAuthor {
            params[FilterAppMode.filterByAuthor.paramString()] = selectedAuthor.id
        }
        if let selectedSubType = selectedSubType {
            params[FilterAppMode.filterByType.paramString()] = selectedSubType.type
        }
        params[FilterAppMode.sorting.paramString()] = currentSortingOption.sortParamValueForAppListingApi()
        return params
    }
    
    func getItemsForFilterMode(_ filterMode: FilterMode) -> [String] {
        let appFilterMode = FilterAppMode(rawValue: filterMode.rawValue) ?? FilterAppMode.none
        switch appFilterMode {
        case .filterByAuthor:
            var items = filteredAuthors.map({ filterAuthor -> String in
                return filterAuthor.title
            })
            items.insert(R.string.localizable.commonFilterAllTitle(), at: 0) // All text
            return items
        case .filterByType:
            var items = filteredSubTypes.map({ filterSubtype -> String in
                return filterSubtype.type
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
        let appFilterMode = FilterAppMode(rawValue: filterMode.rawValue) ?? FilterAppMode.none
        switch appFilterMode {
        case .filterByAuthor:
            selectedAuthorIndex = index
            selectedAuthor = (index == 0) ? nil : filteredAuthors[index - 1]
        case .filterByType:
            selectedSubTypeIndex = index
            selectedSubType = (index == 0) ? nil : filteredSubTypes[index - 1]
        case .sorting:
            currentSortingOption = SortingOption(rawValue: index) ?? SortingOption.titleAsc
        case .none:
            break
        }
    }
    
    func getSelectedItemTextForFilter(index: Int) -> (selectedItem: String?, defaultItem: String?) {
        let appFilterMode = FilterAppMode(rawValue: index) ?? FilterAppMode.none
        switch appFilterMode {
        case .filterByAuthor:
            let defaultItem = (selectedAuthorIndex == -1) ? R.string.localizable.appListingFilterByAuthor()
                : R.string.localizable.commonFilterAllTitle()
            return (selectedAuthor?.title, defaultItem)
        case .filterByType:
            let defaultItem = (selectedSubTypeIndex == -1) ? R.string.localizable.appListingFilterByAppType()
                : R.string.localizable.commonFilterAllTitle()
            return (selectedSubType?.type, defaultItem)
        case .sorting:
            return ((currentSortingOption == .defaultSorting) ? nil : currentSortingOption.localizedString(),
                    R.string.localizable.commonSortingTitle())
        case .none:
            break
        }
        return (nil, nil)
    }
    
    func getSelectedItemIndexForFilter(index: Int) -> Int {
        let appFilterMode = FilterAppMode(rawValue: index) ?? FilterAppMode.none
        switch appFilterMode {
        case .filterByAuthor:
            if let selectedAuthor = selectedAuthor {
                if let index = filteredAuthors.index(where: { filteredAuthor -> Bool in
                    return filteredAuthor.id == selectedAuthor.id
                }) {
                    return index + 1
                }
            }
        case .filterByType:
            if let selectedSubType = selectedSubType {
                if let index = filteredSubTypes.index(where: { filteredSubType -> Bool in
                    return filteredSubType.type == selectedSubType.type
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
