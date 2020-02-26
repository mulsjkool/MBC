//
//  BundleContent.swift
//  MBC
//
//  Created by Cuong Nguyen on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class BundleContent: Feed {
    var items = [Feed]()
    var selectedItemIndex: Int = 0
    var numOfContent: Int
    var bundleItemIds = [BundleItem]()
    var ishighlighted = false
    
    override init(entity: FeedEntity) {
        self.numOfContent = entity.numOfContent ?? 0
        if let bundleItems = entity.bundleItems {
            for item in bundleItems {
                if let feed = Common.fetchFeed(entity: item) {
                    self.items.append(feed)
                }
            }
            self.numOfContent = (self.numOfContent == 0) ? self.items.count : 0
        }
        if let bundleItemIds = entity.bundleItemIds {
            for item in bundleItemIds {
                self.bundleItemIds.append(BundleItem(entity: item))
            }
            self.numOfContent = (self.numOfContent == 0) ? self.items.count : 0
        }
        super.init(entity: entity)
        self.title = (self.title == nil) ? entity.bundleTitle : self.title
    }
    
    private enum CodingKeys: String, CodingKey {
        case items
        case numOfContent
        case bundleItemIds
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encode(numOfContent, forKey: .numOfContent)
        try container.encode(bundleItemIds, forKey: .bundleItemIds)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let feedItems = try container.decode([FeedItemStruct].self, forKey: .items)
            items = feedItems.map { $0.item }
        } catch {
            print("caught: \(error)")
        }
        numOfContent = try container.decode(Int.self, forKey: .numOfContent)
        bundleItemIds = try container.decode([BundleItem].self, forKey: .bundleItemIds)
        try super.init(from: decoder)
    }
}
