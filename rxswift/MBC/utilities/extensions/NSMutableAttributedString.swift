//
//  NSMutableAttributedString.swift
//  MBC
//
//  Created by Tri Vo on 3/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

extension NSMutableAttributedString {
	func colorForText(_ textToFind: String, with color: UIColor) {
		let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
		if range.location != NSNotFound { addAttribute(.foregroundColor, value: color, range: range) }
	}
}
