//
//  SearchResultEmpty.swift
//  MBC
//
//  Created by Tri Vo on 2/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import MisterFusion

class SearchResultEmpty: UIView {
	
	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var notFoundLabel: UILabel!
	@IBOutlet weak private var messageNotFoundLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.searchResultEmpty.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
		self.mf.addConstraints([
			self.top |==| containerView.top,
			self.left |==| containerView.left,
			self.bottom |==| containerView.bottom,
			self.right |==| containerView.right
		])
	}
	
	func notFoundSearch(_ keyword: String) {
		notFoundLabel.text = keyword
		messageNotFoundLabel.text = R.string.localizable.searchResultMessageNotFound(keyword)
        messageNotFoundLabel.setLineSpacing(lineSpacing: 0, lineHeightMultiple: 1.2)
		messageNotFoundLabel.highlightText(keyword, color: Colors.dark.color())
        messageNotFoundLabel.textAlignment = .center
	}
}
