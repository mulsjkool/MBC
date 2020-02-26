//
//  ListStarJsonTransformer.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListStarJsonTransformer: JsonTransformer {
    let contentPagePageDetailJsonTransformer: ContentPagePageDetailJsonTransformer
    
    init(contentPagePageDetailJsonTransformer: ContentPagePageDetailJsonTransformer) {
        self.contentPagePageDetailJsonTransformer = contentPagePageDetailJsonTransformer
    }
    
    func transform(json: JSON) -> [PageDetailEntity] {
        return json["results"].arrayValue.map { contentPagePageDetailJsonTransformer.transform(json: $0) }
    }
}
