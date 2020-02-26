//
//  AlertAction.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 11/23/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Foundation

struct AlertAction {
    var title: String
    var handler: (() -> Void)

    init(title: String, handler: @escaping (() -> Void)) {
        self.title = title
        self.handler = handler
    }
}
