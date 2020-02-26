//
//  EpisodeTabJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class EpisodeTabJsonTransformer: JsonTransformer {
    let feedJsonTransformer: FeedJsonTransformer
    
    init(feedJsonTransformer: FeedJsonTransformer) {
        self.feedJsonTransformer = feedJsonTransformer
    }
    
    func transform(json: JSON) -> [FeedEntity] {
        return json["entities"].arrayValue.map { feedJsonTransformer.transform(json: $0) }
    }
}
