//
//  IPadTextCell.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class IPadTextCell: UITableViewCell {
	@IBOutlet weak private var titleLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func bindData(title text: String, textColor: UIColor, bgColor: UIColor) {
		titleLabel.text = text
		titleLabel.textColor = textColor
		backgroundColor = bgColor
	}
}
