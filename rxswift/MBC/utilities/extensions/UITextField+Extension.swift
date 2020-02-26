//
//  UITextField+Extension.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/8/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

extension UITextField {
    func format(cornerRadius: CGFloat, color: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
    }
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable override var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable override var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
