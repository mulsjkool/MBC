//
//  LanguageConfigListJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class LanguageConfigListJsonTransformer: JsonTransformer {
    let languageConfigJsonTransformer: LanguageConfigJsonTransformer
    
    init(languageConfigJsonTransformer: LanguageConfigJsonTransformer) {
        self.languageConfigJsonTransformer = languageConfigJsonTransformer
    }
    
    func transform(json: JSON) -> LanguageConfigListEntity {
        var type = ""
        var dataList = [LanguageConfigEntity]()
        if let jsonDict = json.dictionary, let typeStr = jsonDict.keys.first {
            type = typeStr
            if let itemJsons = jsonDict[type]?.array {
                for json in itemJsons {
                    dataList.append(languageConfigJsonTransformer.transform(json: json))
                }
            }
        }
        
        return LanguageConfigListEntity(type: type, dataList: dataList)
    }
}

class LanguageConfigJsonTransformer: JsonTransformer {
    let languageConfigDataJsonTransformer: LanguageConfigDataJsonTransformer
    
    init(languageConfigDataJsonTransformer: LanguageConfigDataJsonTransformer) {
        self.languageConfigDataJsonTransformer = languageConfigDataJsonTransformer
    }
    
    private static let fields = (
        names: "names",
        code: "code"
    )

    func transform(json: JSON) -> LanguageConfigEntity {
        let fields = LanguageConfigJsonTransformer.fields
        let names = json[fields.names].arrayValue.map { languageConfigDataJsonTransformer.transform(json: $0) }
        let code = json[fields.code].stringValue
        
        return LanguageConfigEntity(code: code, names: names)
    }
}

class LanguageConfigDataJsonTransformer: JsonTransformer {
    private static let fields = (
        text: "text",
        locale: "locale"
    )
    
    func transform(json: JSON) -> LanguageConfigDataEntity {
        let fields = LanguageConfigDataJsonTransformer.fields
        
        let text = json[fields.text].stringValue
        let locale = json[fields.locale].stringValue
        return LanguageConfigDataEntity(text: text, locate: locale)
    }
}
