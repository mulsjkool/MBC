//
//  UIView+Extensions.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/5/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

extension UIView {
	func startShimmering() {
		
		let light: CGColor = Colors.white.color(alpha: 0.1).cgColor
		let dark: CGColor = UIColor.black.cgColor
		
		let gradient: CAGradientLayer = CAGradientLayer()
		gradient.colors = [dark, light, dark]
		
		let gradientWitth: CGFloat = 3 * self.bounds.size.width
		gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: gradientWitth, height: self.bounds.size.height)
		gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
		gradient.locations  = [NSNumber(value: 0.4 as Double), NSNumber(value: 0.5 as Double), NSNumber(value: 0.6 as Double)]
		self.layer.mask = gradient
		
		let animation: CABasicAnimation = CABasicAnimation(keyPath: "locations")
		animation.fromValue =  [NSNumber(value: 0.0 as Double),
								NSNumber(value: 0.1 as Double),
								NSNumber(value: 0.2 as Double)]
		animation.toValue  = [NSNumber(value: 0.8 as Double), NSNumber(value: 0.9 as Double), NSNumber(value: 1.0 as Double)]
		animation.duration = 1.5
		animation.repeatCount = Float.infinity
		 gradient.add(animation, forKey: "shimmer")
		self.layer.backgroundColor = UIColor(netHex: 0xEEEEEE).cgColor
		
	}
	
	func stopShimmering() {
	
		self.layer.backgroundColor = UIColor.clear.cgColor
		self.layer.mask = nil
	}
    
    func constraint(of attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        return constraints.first(where: { return $0.firstAttribute == attribute && $0.relation == .equal })
    }
	
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /// Fade in a view with a duration
    ///
    /// Parameter duration: custom animation duration
    func fadeIn(withDuration duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /// Fade out a view with a duration
    ///
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}
