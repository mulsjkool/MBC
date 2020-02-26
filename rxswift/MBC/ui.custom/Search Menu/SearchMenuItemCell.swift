//
//  SearchMenuItemCell.swift
//  MBC
//
//  Created by Tri Vo on 2/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class SearchMenuItemCell: UICollectionViewCell {

	@IBOutlet weak private var contentLabel: UILabel!
	@IBOutlet weak private var lineSelection: UIView!
	@IBOutlet weak private var lineSpacing: UIView!
	
	override var isSelected: Bool {
		didSet {
			lineSelection.isHidden = !isSelected
			contentLabel.textColor = isSelected ? Colors.defaultAccentColor.color() : Colors.dark.color()
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		lineSelection.isHidden = true
    }
	
	public func contentFont() -> UIFont {
		return contentLabel.font
	}
	
	public func bindData(data: String) {
		contentLabel.text = data
	}
}
