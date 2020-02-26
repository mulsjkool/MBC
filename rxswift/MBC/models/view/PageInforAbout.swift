//
//  PageInforAbout.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageInforAbout {
    var title: String
    var aboutText: String
    
    private let fields = (
        accountId: "accountId",
        socialNetworkName: "socialNetworkName"
    )
    
    init(title: String, aboutText: String) {
        self.title = title
        self.aboutText = aboutText
    }
}
