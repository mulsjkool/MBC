//
//  ListShowJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON
import UIKit

class ListShowJsonTransformer: JsonTransformer {
    let listPageDetailJsonTransformer: ListPageDetailJsonTransformer
    
    init(listPageDetailJsonTransformer: ListPageDetailJsonTransformer) {
        self.listPageDetailJsonTransformer = listPageDetailJsonTransformer
    }
    
    func transform(json: JSON) -> [PageDetailEntity] {
        let resultField = "results"
        return (json[resultField] != JSON.null) ? listPageDetailJsonTransformer.transform(json: json[resultField]) : []
    }
}
