//
//  FilterContentJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class FilterContentJsonTransformer: JsonTransformer {
    private static let fields = (
        listAuthor : "listAuthor",
        mapSubType : "mapSubType",
        
        occupations : "occupations",
        monthOfBirths : "monthOfBirths",
        
        genres: "genres",
        subtypes: "subtypes"
    )
    
    var filterAuthorJsonTransformer: FilterAuthorJsonTransformer!
    var filterSubTypeJsonTransformer: FilterSubTypeJsonTransformer!
    
    var filterMonthOfBirthJsonTransformer: FilterMonthOfBirthJsonTransformer!
    var filterOccupationJsonTransformer: FilterOccupationJsonTransformer!
    
    var filterGenreJsonTransformer: FilterGenreJsonTransformer!
    var filterShowSubTypeJsonTransformer: FilterShowSubTypeJsonTransformer!
    
    init(filterAuthorJsonTransformer: FilterAuthorJsonTransformer,
         filterSubTypeJsonTransformer: FilterSubTypeJsonTransformer,
         filterMonthOfBirthJsonTransformer: FilterMonthOfBirthJsonTransformer,
         filterOccupationJsonTransformer: FilterOccupationJsonTransformer,
         filterGenreJsonTransformer: FilterGenreJsonTransformer,
         filterShowSubTypeJsonTransformer: FilterShowSubTypeJsonTransformer) {
        self.filterAuthorJsonTransformer = filterAuthorJsonTransformer
        self.filterSubTypeJsonTransformer = filterSubTypeJsonTransformer
        self.filterOccupationJsonTransformer = filterOccupationJsonTransformer
        self.filterMonthOfBirthJsonTransformer = filterMonthOfBirthJsonTransformer
        self.filterGenreJsonTransformer = filterGenreJsonTransformer
        self.filterShowSubTypeJsonTransformer = filterShowSubTypeJsonTransformer
    }
    
    func transform(json: JSON) -> FilterContentEntity {
        let fields = FilterContentJsonTransformer.fields
        
        var filterAuthors: [FilterAuthorEntity]? = nil
        if let listAuthorJson = json[fields.listAuthor].array {
            filterAuthors = listAuthorJson.map({ jsonValue in
                return filterAuthorJsonTransformer.transform(json: jsonValue)
            })
        }
        
        var filterSubTypes: [FilterSubTypeEntity]? = nil
        if json[fields.mapSubType].dictionary != nil {
            filterSubTypes = filterSubTypeJsonTransformer.transform(json: json[fields.mapSubType])
        }
        
        var filterMonthOfBirth: [FilterMonthOfBirthEntity]? = nil
        if let listMonthOfBirthJson = json[fields.monthOfBirths].array {
            filterMonthOfBirth = listMonthOfBirthJson.map({ jsonValue in
                return filterMonthOfBirthJsonTransformer.transform(json: jsonValue)
            })
        }
        
        var filterOccupations: [FilterOccupationEntity]? = nil
        if let listOccupationsJson = json[fields.occupations].array {
            filterOccupations = listOccupationsJson.map({ jsonValue in
                return filterOccupationJsonTransformer.transform(json: jsonValue)
            })
        }
        
        var filterGenres: [FilterGenreEntity]? = nil
        if let listGenreJson = json[fields.genres].array {
            filterGenres = listGenreJson.map({ jsonValue in
                return filterGenreJsonTransformer.transform(json: jsonValue)
            })
        }
        
        var filterShowSubTypes: [FilterShowSubTypeEntity]? = nil
        if let listShowSubtypeJson = json[fields.subtypes].array {
            filterShowSubTypes = listShowSubtypeJson.map({ jsonValue in
                return filterShowSubTypeJsonTransformer.transform(json: jsonValue)
            })
        }
        
        return FilterContentEntity(filterAuthors: filterAuthors, filterSubTypes: filterSubTypes,
                                   filterOccupations: filterOccupations, filterMonthOfBirths: filterMonthOfBirth, 
                                   filterGenres: filterGenres, filterShowSubTypes: filterShowSubTypes)
    }
}

// MARK: - App filter

class FilterAuthorJsonTransformer: JsonTransformer {
    private static let fields = (
        listSubType : "listSubType",
        id : "id",
        title : "title"
    )
    
    func transform(json: JSON) -> FilterAuthorEntity {
        let fields = FilterAuthorJsonTransformer.fields
        
        var listSubType: [String]? = nil
        if let listSubTypeJson = json[fields.listSubType].array {
            listSubType = listSubTypeJson.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        let id = json[fields.id].string ?? ""
        let title = json[fields.title].string ?? ""
        
        return FilterAuthorEntity(listSubType: listSubType, id: id, title: title)
    }
}

class MapSubTypeJsonTransformer: JsonTransformer {
    private static let fields = (
        id : "id",
        title : "title"
    )
    
    func transform(json: JSON) -> MapSubTypeEntity {
        let fields = MapSubTypeJsonTransformer.fields

        let id = json[fields.id].string ?? ""
        let title = json[fields.title].string ?? ""
        
        return MapSubTypeEntity(id: id, title: title)
    }
}

class FilterSubTypeJsonTransformer: JsonTransformer {
    
    var mapSubTypeJsonTransformer: MapSubTypeJsonTransformer!
    
    init(mapSubTypeJsonTransformer: MapSubTypeJsonTransformer) {
        self.mapSubTypeJsonTransformer = mapSubTypeJsonTransformer
    }

    func transform(json: JSON) -> [FilterSubTypeEntity]? {
        if let dictionary = json.dictionary {
            var filterSubTypes = [FilterSubTypeEntity]()
            for key in dictionary.keys {
                var mapSubTypes = [MapSubTypeEntity]()
                if let mapSubTypeArray = dictionary[key]?.array {
                    for mapSubTypeJson in mapSubTypeArray {
                        let mapSubType = mapSubTypeJsonTransformer.transform(json: mapSubTypeJson)
                        mapSubTypes.append(mapSubType)
                    }
                }
                let filterSubType = FilterSubTypeEntity(type: key, mapSubTypes: mapSubTypes)
                filterSubTypes.append(filterSubType)
            }
            return filterSubTypes
        }
        
        return nil
    }
}

// MARK: - Star filter

class FilterMonthOfBirthJsonTransformer: JsonTransformer {
    private static let fields = (
        name : "name",
        title : "title",
        occupations : "occupations"
    )
    
    func transform(json: JSON) -> FilterMonthOfBirthEntity {
        let fields = FilterMonthOfBirthJsonTransformer.fields
        
        let name = json[fields.name].string ?? ""
        let title = json[fields.title].string ?? ""
        
        var list: [String]? = nil
        if let listJson = json[fields.occupations].array {
            list = listJson.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        
        return FilterMonthOfBirthEntity(name: name, title: title, occupationArray: list)
    }
}

class FilterOccupationJsonTransformer: JsonTransformer {
    private static let fields = (
        name : "name",
        title : "title",
        monthOfBirths : "monthOfBirths"
    )
    
    func transform(json: JSON) -> FilterOccupationEntity {
        let fields = FilterOccupationJsonTransformer.fields
        
        let name = json[fields.name].string ?? ""
        let title = json[fields.title].string ?? ""
        
        var list: [String]? = nil
        if let listJson = json[fields.monthOfBirths].array {
            list = listJson.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        
        return FilterOccupationEntity(name: name, title: title, monthOfBirthArray: list)
    }
}

class FilterGenreJsonTransformer: JsonTransformer {
    private static let fields = (
        id : "id",
        names : "names",
        subtypes : "subtypes"
    )
    
    func transform(json: JSON) -> FilterGenreEntity {
        let fields = FilterGenreJsonTransformer.fields
        
        var subtypes: [String]? = nil
        if let subtypesJson = json[fields.subtypes].array {
            subtypes = subtypesJson.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        let id = json[fields.id].string ?? ""
        let name = json[fields.names].string ?? ""
        
        return FilterGenreEntity(subtypes: subtypes, id: id, name: name)
    }
}

class FilterShowSubTypeJsonTransformer: JsonTransformer {
    private static let fields = (
        name : "name",
        genres : "genres"
    )
    
    func transform(json: JSON) -> FilterShowSubTypeEntity {
        let fields = FilterShowSubTypeJsonTransformer.fields
        
        var genres: [String]? = nil
        if let genresJson = json[fields.genres].array {
            genres = genresJson.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        let name = json[fields.name].string ?? ""
        
        return FilterShowSubTypeEntity(genres: genres, name: name)
    }
}
