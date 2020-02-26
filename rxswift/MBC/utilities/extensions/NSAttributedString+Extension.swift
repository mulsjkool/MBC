//
//  NSAttributedString+Extension.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

extension NSAttributedString {
    // source https://developer.apple.com/library/content/documentation/Cocoa
    // /Conceptual/TextLayout/Tasks/CountLines.html
    func getNumberOfLines(withConstraintWidth width: CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let textStorage = NSTextStorage(attributedString: self)
        let container = NSTextContainer(size: constraintRect)
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        var numberOfLines = 0, index = 0
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange = NSRange(location: 0, length: self.length)
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    func appendText(_ text: String) -> NSAttributedString {
        var range = NSRange(location: 0, length: self.length)
        let textAttributes = self.attributes(at: 0, effectiveRange: &range)
        let result = NSMutableAttributedString()
        
        let appendedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        let mutableString = NSMutableAttributedString(attributedString: self)
        
        result.append(mutableString)
        result.append(appendedText)
        
        return result
    }
}
