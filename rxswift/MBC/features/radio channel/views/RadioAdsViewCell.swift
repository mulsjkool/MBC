//
//  RadioAdsViewCell.swift
//  MBC
//
//  Created by Tri Vo on 3/18/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import MisterFusion

class RadioAdsViewCell: BaseTableViewCell {
	@IBOutlet weak private var adsContainerView: UIView!
	@IBOutlet weak private var adsContainerTopConstraint: NSLayoutConstraint!
	@IBOutlet weak private var adsContainerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak private var adsContainerWidthConstraint: NSLayoutConstraint!
	
	private let bannerAdsTag = 10001
	private var hadAds: Bool = false {
		didSet {
			if !hadAds {
				adsContainerTopConstraint.constant = 0.5
				adsContainerHeightConstraint.constant = 0
			}
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		hadAds = false
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		hadAds = false
		viewWithTag(bannerAdsTag)?.removeFromSuperview()
	}
	
	func addAds(_ view: UIView) {
		hadAds = true
		adsContainerTopConstraint.constant = Constants.DefaultValue.defaultMargin
		adsContainerHeightConstraint.constant = view.bounds.height
		adsContainerWidthConstraint.constant = view.bounds.width
		view.tag = bannerAdsTag
		view.translatesAutoresizingMaskIntoConstraints = false
		adsContainerView.mf.addSubview(view, andConstraints:
			view.centerX |==| adsContainerView.centerX,
			view.top |==| adsContainerView.top
		)
	}
}
