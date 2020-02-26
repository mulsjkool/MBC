//
//  MenuCell.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 11/28/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Kingfisher
import RxSwift
import UIKit

class MenuCell: BaseTableViewCell {
    // outlets
    @IBOutlet weak private var logoView: UIImageView!
    @IBOutlet weak private var menuLabel: UILabel!
    @IBOutlet weak private var badgeView: UIView!
    @IBOutlet weak private var badgeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var labelSpaceBadgeConstraint: NSLayoutConstraint!
    @IBOutlet weak private var logoViewWidthConstant: NSLayoutConstraint!
	
	let staticMenuIconWidth = CGFloat(16)
	let featureMenuIconWidth = CGFloat(24)
	
	override func prepareForReuse() {
		super.prepareForReuse()
		logoView.image = nil
		cancelDownloadTask()
	}
	
	func updateView(menuItem: MenuPage) {
		menuLabel.text = menuItem.title
        hideBadgeView(shouldHide: true)
		setSelection()
		logoViewWidthConstant.constant = featureMenuIconWidth
	}

	func updateWithStaticItem(menuItem: StaticMenuItem) {
		menuLabel.text = menuItem.name
		logoView.image = R.image.iconNoLogo()
		
		guard let icon = menuItem.icon else { return }

		logoView.image = icon
		logoViewWidthConstant.constant = staticMenuIconWidth

		// temporary hide all badge
		hideBadgeView(shouldHide: true)
		setSelection()
	}

	private func hideBadgeView(shouldHide: Bool) {
		if shouldHide {
			badgeWidthConstraint.constant = 0
			labelSpaceBadgeConstraint.constant = 0
		} else {
			badgeWidthConstraint.constant = 27
			labelSpaceBadgeConstraint.constant = 16
		}
	}

	func setLogo(_ image: UIImage?) {
		logoView.image = image
	}
	
	func cancelDownloadTask() {
		logoView.cancelDownloadTask()
	}
	
	private func setSelection() {
		selectionStyle = .default
		menuLabel.highlightedTextColor = Colors.defaultAccentColor.color()
	}
}
