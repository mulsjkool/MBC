//
//  Highlightable.swift
//  Highlighter
//
//  Created by Ian Keen on 2017-05-16.
//  Copyright © 2017 SeungyounYi. All rights reserved.
//

import Foundation

public protocol Highlightable: class {
    var textValue: String? { get }
    var attributedTextValue: NSAttributedString? { get set }

    func highlight(text: String, normal normalAttributes: [NSAttributedStringKey : Any]?, highlight highlightAttributes: [NSAttributedStringKey : Any]?)
}

extension Highlightable {
    public func highlight(text: String, normal normalAttributes: [NSAttributedStringKey : Any]?, highlight highlightAttributes: [NSAttributedStringKey : Any]?) {
        guard let inputText = self.textValue else { return }

        let highlightRanges = inputText.lowercased().ranges(of: text)

        guard !highlightRanges.isEmpty else { return }

        self.attributedTextValue = NSAttributedString.highlight(
            ranges: highlightRanges,
            at: text,
            in: inputText,
            normal: normalAttributes,
            highlight: highlightAttributes
        )
    }
}
