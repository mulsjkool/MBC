//
//  BannerAdsViewCell.swift
//  MBC
//
//  Created by Tri Vo on 2/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MisterFusion
import RxSwift

class BannerAdsViewCell: BaseTableViewCell {
    
    @IBOutlet weak private var adsContainerView: UIView!
	@IBOutlet weak private var bottomLineSpacingView: UIView!
	@IBOutlet weak private var topLineSpacingView: UIView!
	@IBOutlet weak private var bottomLineHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak private var adsContainerTopConstraint: NSLayoutConstraint!
	@IBOutlet weak private var adsContainerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak private var adsContainerWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak private var adsContainerBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak private var titleLabel: UILabel!
	
	private let bannerAdsTag = 10001
	
	private var hadAds: Bool = false {
		didSet {
			if !hadAds {
				adsContainerTopConstraint.constant = 0
				adsContainerHeightConstraint.constant = 0
				adsContainerWidthConstraint.constant = 0
                adsContainerBottomConstraint.constant = 0
                self.layoutIfNeeded()
            }
            topLineSpacingView.backgroundColor = hadAds ? Colors.defaultBg.color() : .white
			titleLabel.isHidden = !hadAds
			bottomLineSpacingView.isHidden = !hadAds
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
	
	func addAds(_ view: UIView, isHideBottom: Bool = false) {
		hadAds = true
		view.tag = bannerAdsTag
		view.translatesAutoresizingMaskIntoConstraints = false
		adsContainerView.mf.addSubview(view, andConstraints:
			view.centerX |==| adsContainerView.centerX,
			view.top |==| adsContainerView.top
		)
		self.adsContainerTopConstraint.constant = Constants.DefaultValue.paddingBannerAdsCellTop
		self.adsContainerHeightConstraint.constant = view.bounds.size.height
		self.adsContainerWidthConstraint.constant = view.bounds.size.width
		self.adsContainerBottomConstraint.constant = Constants.DefaultValue.paddingBannerAdsCellBottom -
													(isHideBottom ? Constants.DefaultValue.defaultMargin : 0)
	}
	
	func setBottomSpacingColor(color: UIColor) {
		bottomLineSpacingView.backgroundColor = color
	}
	
	func hideBottomLine() {
		bottomLineHeightConstraint.constant = 0
		topLineSpacingView.isHidden = false
	}
	
    func applyColor(backgroundColor: UIColor, titleColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
        adsContainerView.backgroundColor = backgroundColor
        titleLabel.textColor = titleColor
    }
}
