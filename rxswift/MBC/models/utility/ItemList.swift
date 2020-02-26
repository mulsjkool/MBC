//
//  ItemList.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/12/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class ItemList {
    private var items: [AnyObject]
    
    func clear() {
        items.removeAll()
		grandTotal = 0
    }
    
    var count: Int {
        return items.count
    }
    
    var list: [AnyObject] {
        return items
    }
    
    func addAll(list: [AnyObject]) {
        items.append(contentsOf: list)
    }
	
	func insert(item: AnyObject, index: Int) {
		items.insert(item, at: index)
	}
    
    func addItem(item: AnyObject) {
        items.append(item)
    }
    
    init(items: [AnyObject]) {
        self.items = items
    }
    
    init() {
        self.items = [AnyObject]()
    }
	
	var grandTotal: Int! = 0
	var title: String?
}
