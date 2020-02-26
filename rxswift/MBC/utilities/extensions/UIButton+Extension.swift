//
//  UIButton+Extension.swift
//  MBC
//
//  Created by Huy Kieu Anh on 7/4/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import UIKit

extension UIButton {

    @IBInspectable var localization: String {
        set {
            let realText = newValue.localized()
            setTitle(realText, for: .normal)
        }
        get {
            return title(for: .normal) ?? ""
        }
    }

    @IBInspectable var selectedLocalization: String {
        set {
            let realText = newValue.localized()
            setTitle(realText, for: .selected)
        }
        get {
            return title(for: .selected) ?? ""
        }
    }

    @IBInspectable var allCap: Bool {
        set {
            if newValue {
                if isSelected {
                    setTitle(self.selectedLocalization.uppercased(), for: .selected)
                } else {
                    setTitle(self.localization.uppercased(), for: .normal)
                }
            }
        }
        get {
            return self.titleLabel?.text == self.titleLabel?.text?.uppercased()
        }
    }
    
    func format(cornerRadius: CGFloat, color: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = color
        self.clipsToBounds = true
    }
}
