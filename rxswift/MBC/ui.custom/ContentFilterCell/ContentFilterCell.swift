//
//  ContentFilterCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ContentFilterCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    
    func bindData(text: String, isTextHighlighted: Bool) {
        titleLabel.text = text
        titleLabel.textColor = isTextHighlighted ? Colors.userProfileTabButton.color() : Colors.filterTextColor.color()
    }
}
