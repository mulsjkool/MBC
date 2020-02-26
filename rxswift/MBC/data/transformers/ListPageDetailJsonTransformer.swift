//
//  ListPageDetailJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON
import UIKit

class ListPageDetailJsonTransformer: JsonTransformer {
    let pageDetailJsonTransformer: PageDetailJsonTransformer
    
    init(pageDetailJsonTransformer: PageDetailJsonTransformer) {
        self.pageDetailJsonTransformer = pageDetailJsonTransformer
    }
    
    func transform(json: JSON) -> [PageDetailEntity] {
        return (json != JSON.null) ? json.arrayValue.map({ pageDetailJson -> PageDetailEntity in
            return pageDetailJsonTransformer.transform(json: pageDetailJson)
        }) : []
    }
}
