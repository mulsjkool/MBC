//
//  Fonts.swift
//  F8
//
//  Created by Dao Le Quang on 10/31/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import UIKit

struct Fonts {
    enum Primary: String {
        case regular = "29LTKaff-Regular"
        case ultraLight = "29LTKaff-UltraLight"
        case black = "29LTKaff-Black"
        case semiBold = "29LTKaff-SemiBold"

        func toFontWith(size: Double) -> UIFont? {
            return UIFont(name: self.rawValue, size: CGFloat(size))
        }

        var fontName: String {
            return rawValue
        }
    }
}
