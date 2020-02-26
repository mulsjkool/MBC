//
//  UIColorExtension.swift
//  MBC
//
//  Created by R0CKSTAR on 6/13/14.
//  Copyright © 2016 MBC. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        if rgba.hasPrefix("#") {
            let index = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex = String(rgba[index...])
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch hex.count {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255),
                          lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }

    convenience init(netHex: Int, alpha: CGFloat) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff

        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    class func getRandomColor() -> UIColor {

        let randomRed: CGFloat = CGFloat(drand48())

        let randomGreen: CGFloat = CGFloat(drand48())

        let randomBlue: CGFloat = CGFloat(drand48())

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }

}
