//
//  ParagraphType.swift
//  MBC
//
//  Created by azuniMac on 12/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum ParagraphType: String, Decodable {
    case text
    case image
    case video
    case embed
    case ads
    case unknown
}

enum ParagraphViewOptionEnum: Int {
    case standard = 0
    case numbered = 1
    case countdown = 2
}
