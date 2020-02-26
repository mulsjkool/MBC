//
//  UILabel+Extension.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/28/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

extension UILabel {

    @IBInspectable var localization: String {
        set {
            self.text = newValue.localized()
        }
        get {
            return self.text ?? ""
        }
    }

    func from(html: String) {
        let textColor = self.textColor
        guard let attText = html.htmlToAttributedString() else { return }
        let textAttributes = [NSAttributedStringKey.foregroundColor: textColor as Any,
                              NSAttributedStringKey.font: self.font as Any // This will cause html format issue
        ]
        
        let finalAttText = NSMutableAttributedString(attributedString: attText)
        finalAttText.addAttributes(textAttributes, range: NSRange(location: 0, length: attText.length))
        attributedText = finalAttText
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
	
	func highlightText(_ textToFind: String, color: UIColor) {
		guard let originalText = self.text else { return }
		var mutableString = NSMutableAttributedString(string: originalText)
        if let labelattributedText = self.attributedText {
            mutableString = NSMutableAttributedString(attributedString: labelattributedText)
        }
        mutableString.colorForText(textToFind, with: color)
        self.attributedText = mutableString
	}
}

// MARK: - Copyable action
extension UILabel {
	private struct CustomProperties {
		static var sillyName: String?
	}
	
	@IBInspectable var copyableAction: Bool {
		get { return self.copyableAction }
		set { if newValue { sharedInit() } }
	}

	var copyableFullText: String? {
		get { return objc_getAssociatedObject(self, &CustomProperties.sillyName) as? String }
		set {
			if let unwrappedValue = newValue {
				objc_setAssociatedObject(self, &CustomProperties.sillyName, unwrappedValue,
										 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}
	
	func sharedInit() {
		isUserInteractionEnabled = true
		addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
	}
	
	override open var canBecomeFirstResponder: Bool {
		return true
	}
	
	@objc
	func showMenu(sender: AnyObject?) {
		becomeFirstResponder()
		let menu = UIMenuController.shared
		if !menu.isMenuVisible {
			menu.setTargetRect(bounds, in: self)
			menu.setMenuVisible(true, animated: true)
		}
	}
	
	open override func copy(_ sender: Any?) {
		let board = UIPasteboard.general
		board.string = copyableFullText
		let menu = UIMenuController.shared
		menu.setMenuVisible(false, animated: true)
	}
	
	open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return action == #selector(UIResponderStandardEditActions.copy)
	}
}
