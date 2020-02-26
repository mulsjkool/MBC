//
//  ListPageJsonTransformer.swift
//  MBC
//
//  Created by azun on 11/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListPageJsonTransformer: JsonTransformer {
    let pageJsonTransformer: PageJsonTransformer

    init(pageJsonTransformer: PageJsonTransformer) {
        self.pageJsonTransformer = pageJsonTransformer
    }

    func transform(json: JSON) -> [PageEntity] {
        return json["pages"].arrayValue.map { pageJsonTransformer.transform(json: $0) }
    }
}
