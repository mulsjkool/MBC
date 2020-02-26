//
//  FollowView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit
import MisterFusion

open class FollowView: UIView {

	@IBOutlet private weak var containerView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.followView.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
		self.backgroundColor = UIColor.clear
		containerView.layer.cornerRadius = self.bounds.height / 2
	}
	
	func setBackgroundColor(_ color: UIColor) {
		containerView.backgroundColor = color
	}
}
