//
//  MBCLoadingPlaceHolderView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/5/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import MisterFusion
import UIKit

class MBCLoadingPlaceHolderView: UIView {

	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var contentView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
        Bundle.main.loadNibNamed(IPad.NibName.mbcLoadingPlaceHolder, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
	}
	
	func setAutolayoutWithParentView() {
		// auto layout
		guard let superView = self.superview else { return }
		self.translatesAutoresizingMaskIntoConstraints = false
		superView.mf.addConstraints(
			self.top |==| superView.top,
			self.left |==| superView.left,
			self.width |==| superView.width,
			self.height |==| superView.height
		)
	}
	
	func stopShimmer() {
		for view in contentView.subviews {
			view.stopShimmering()
		}
	}
	
	override func didMoveToSuperview() {
		superview?.didMoveToSuperview()
		setAutolayoutWithParentView()
		for view in self.contentView.subviews {
			view.startShimmering()
		}
	}
	
}
