//
//  ViewInterest.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit
import MisterFusion

class InterestView: BaseView {

	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var interestLabel: UILabel!
	@IBOutlet weak private var labelLabel: PaddingLabel!
	@IBOutlet weak private var interestNumberLabel: PaddingLabel!
	@IBOutlet weak private var interestNumberContainView: UIView!
	@IBOutlet weak private var plusLabel: UILabel!
    @IBOutlet weak private var labelLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var interestNumberContainViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var interestLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var interestLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var labelLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var interestLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var labelLabelLeftConstraint: NSLayoutConstraint!
    
    let needToUpdateHeight = PublishSubject<CGFloat>()
    let didExpand = PublishSubject<Void>()
    var isExpanded = false
    var interestsStr = ""
    private var isPlaylistCarouselInterests = false
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.interestView.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
        interestLabel.text = ""
        interestsStr = ""
        interestNumberLabel.text = ""
        plusLabel.isHidden = true
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        setupRx()
	}
    
    private func setupRx() {
        let tapGesture = UITapGestureRecognizer()
        interestNumberContainView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { [unowned self] _ in
            self.didExpand.onNext(())
            self.isExpanded = true
            self.interestLabel.text = self.interestsStr
            if self.isPlaylistCarouselInterests {
                self.reLayoutConstraintsForPlaylistCarousel()
            } else {
                self.reLayoutConstraints()
            }
        }).disposed(by: disposeBag)
    }
	
    func bindInterests(interests: [Interest]?, isExpanded: Bool) {
        guard let interests = interests else {
            interestLabel.text = ""
            interestsStr = ""
            interestNumberLabel.text = ""
            plusLabel.isHidden = true
            return
        }
        let array = interests.map({ $0.name })
        bindInterests(interests: array, isExpanded: isExpanded)
    }
    
    func bindInterests(interests: [String]?, isExpanded: Bool) {
        self.isExpanded = isExpanded
        guard let interests = interests, !interests.isEmpty else {
            interestLabel.text = ""
            interestsStr = ""
            interestNumberLabel.text = ""
            plusLabel.isHidden = true
            return
        }
        
        interestNumberLabel.text = (interests.count > 1) ? "\(interests.count - 1)" : ""
        
        interestsStr = interests.joined(separator: Constants.DefaultValue.InterestSeparatorString)
        interestLabel.text = isExpanded ? interestsStr : interests[0]
    }
    
    func bindLabel(label: String?, isExpanded: Bool) {
        if Constants.Singleton.isiPad { labelLabelLeftConstraint.constant = 0 }
        self.isExpanded = isExpanded
        guard let label = label, !label.isEmpty else {
            labelLabel.text = ""
            labelLabel.isHidden = true
            return
        }
        labelLabel.text = label
        labelLabel.isHidden = false
    }
    
    private let maxLabelWidth: CGFloat = (Constants.DeviceMetric.screenWidth - 2 *
        Constants.DefaultValue.defaultMargin) / 2
    private let defaulLabelHeight: CGFloat = 16.0
    private let defaulInterestHeight: CGFloat = 20.0
    private let defaultViewHeight: CGFloat = 16.0
    private let fullScreenWidth: CGFloat = Constants.DeviceMetric.screenWidth - 2 * Constants.DefaultValue.defaultMargin
    private let defaultInterestLabelRight: CGFloat = 8.0
    private let defaultInterestNumberWidth: CGFloat = 28.0
    private let defaultInterestLabelLeftInset: CGFloat = 4
    
    func reLayoutConstraints() {
        var labelWidth: CGFloat = 0.0
        var interestWidth: CGFloat = 0.0
        var actualLabelWidth: CGFloat = 0.0
        
        if let label = labelLabel.text, !label.isEmpty {
            actualLabelWidth = label.width(withConstrainedHeight: defaulLabelHeight, font: labelLabel.font)
                + 2 * Constants.DefaultValue.defaultLabelLeftInset
            labelWidth = (actualLabelWidth > maxLabelWidth) ? maxLabelWidth : actualLabelWidth
        } else {
            labelWidth = 0
        }
        
        if let interest = interestLabel.text, !interest.isEmpty {
            if (interestNumberLabel.text?.isEmpty)! {
                interestNumberContainViewWidthConstraint.constant = 0
            } else {
                let interestNumberViewWidth = (interestNumberLabel.text?.width(withConstrainedHeight: defaulLabelHeight,
                                            font: interestNumberLabel.font) ?? 0) + 2 * defaultInterestLabelLeftInset
                if !isExpanded {
                    interestNumberContainViewWidthConstraint.constant = !((interestNumberLabel.text?.isEmpty)!) ?
                        (defaultInterestNumberWidth + interestNumberViewWidth) : 0
                } else {
                    interestNumberContainViewWidthConstraint.constant = 0
                }
            }
			let width = interest.width(withConstrainedHeight: defaulInterestHeight, font: interestLabel.font)
			let maxWidth = fullScreenWidth - interestNumberContainViewWidthConstraint.constant - labelWidth -
			defaultInterestLabelRight
			interestWidth = (width > maxWidth) ? maxWidth : width
        } else {
            interestNumberContainViewWidthConstraint.constant = 0
            interestWidth = 0
        }
        
        if labelWidth == 0 && interestWidth == 0 {
			labelLabelWidthConstraint.constant = 0
			interestLabelWidthConstraint.constant = 0
            interestLabelHeightConstraint.constant = 0
            labelLabelHeightConstraint.constant = 0
            needToUpdateHeight.onNext(0)
            plusLabel.isHidden = true
			return
		}
        if labelWidth == 0 {
            interestWidth = (interestWidth > fullScreenWidth) ? fullScreenWidth : interestWidth
        }
        if interestWidth == 0 {
            labelWidth = (labelWidth > fullScreenWidth) ? fullScreenWidth : labelWidth
        }
        
        labelLabelWidthConstraint.constant = labelWidth
        interestLabelWidthConstraint.constant = interestWidth
        var labelHeight = (labelLabel.text?.height(withConstrainedWidth: labelWidth, font: labelLabel.font))! +
            labelLabel.frame.origin.y * 2
        labelHeight = (labelHeight > defaulLabelHeight) ? labelHeight : defaulLabelHeight
        labelLabelHeightConstraint.constant = labelHeight
        
        var interestHeight = (interestLabel.text?.height(withConstrainedWidth: interestWidth,
                                                         font: interestLabel.font))!
            + interestLabel.frame.origin.y * 2
        interestHeight = (interestHeight > defaulInterestHeight) ? interestHeight : defaulInterestHeight
        interestLabelHeightConstraint.constant = interestHeight
        
        interestLabelRightConstraint.constant = (labelWidth > 0 && interestWidth > 0) ? defaultInterestLabelRight : 0
        
        var viewHeight = (labelHeight > interestHeight) ? labelHeight : interestHeight
        viewHeight = (viewHeight > defaultViewHeight) ? viewHeight : defaultViewHeight
        needToUpdateHeight.onNext(viewHeight)
        
        plusLabel.isHidden = (interestNumberLabel.text?.isEmpty)! ? true : false
        
        if !isExpanded {
            interestNumberContainView.isHidden = (interestNumberContainViewWidthConstraint.constant == 0)
        } else {
            interestNumberContainView.isHidden = true
        }
    }
    
    func reLayoutConstraintsForPlaylistCarousel() {
        layoutIfNeeded()
        interestLabel.numberOfLines = 1
        interestLabel.textAlignment = .center
        isPlaylistCarouselInterests = true
        let labelWidth: CGFloat = 0.0
        var interestWidth: CGFloat = 0.0
        
        var interestLabelRight = defaultInterestLabelRight
        if let interest = interestLabel.text, !interest.isEmpty {
            if (interestNumberLabel.text?.isEmpty)! {
                interestNumberContainViewWidthConstraint.constant = 0
            } else {
                let interestNumberViewWidth = (interestNumberLabel.text?.width(withConstrainedHeight: defaulLabelHeight,
                    font: interestNumberLabel.font) ?? 0) + 2 * defaultInterestLabelLeftInset
                if !isExpanded {
                    interestNumberContainViewWidthConstraint.constant = !interestNumberLabel.text!.isEmpty ?
                        (defaultInterestNumberWidth + interestNumberViewWidth) : 0
                } else {
                    interestNumberContainViewWidthConstraint.constant = 0
                    interestLabelRight = 0
                }
            }
            let width = interest.width(withConstrainedHeight: defaulInterestHeight, font: interestLabel.font)
            let maxWidth = self.frame.size.width - interestNumberContainViewWidthConstraint.constant - labelWidth -
                interestLabelRight
            interestWidth = (width > maxWidth) ? maxWidth : width
        } else {
            interestNumberContainViewWidthConstraint.constant = 0
            interestWidth = 0
        }
        
        if labelWidth == 0 && interestWidth == 0 {
            labelLabelWidthConstraint.constant = 0
            interestLabelWidthConstraint.constant = 0
            plusLabel.isHidden = true
            return
        }
        
        labelLabelWidthConstraint.constant = labelWidth
        interestLabelWidthConstraint.constant = interestWidth
        interestLabelRightConstraint.constant = 0.0
        labelLabelLeftConstraint.constant = (self.frame.size.width - interestWidth - interestLabelRight
            - interestNumberContainViewWidthConstraint.constant) / 2.0
        
        if let text = interestNumberLabel.text, !text.isEmpty {
            plusLabel.isHidden = false
        } else {
            plusLabel.isHidden = true
        }
        
        if !isExpanded {
            interestNumberContainView.isHidden = (interestNumberContainViewWidthConstraint.constant == 0)
        } else {
            interestNumberContainView.isHidden = true
        }
    }
    
    func setInterestLabelFont(font: UIFont) {
        interestLabel.font = font
    }
    
    func applyAccentColor(accentColor: UIColor?) {
        var color = Colors.defaultAccentColor.color()
        if let accentColor = accentColor {
            color = accentColor
        }
        interestLabel.textColor = (interestLabel.text?.isEmpty)! ? UIColor.clear : color
        labelLabel.backgroundColor = (labelLabel.text?.isEmpty)! ? UIColor.clear : color
        labelLabel.textColor = (labelLabel.text?.isEmpty)! ? UIColor.clear : UIColor.white
        plusLabel.textColor = color
        interestNumberLabel.backgroundColor = (interestNumberLabel.text?.isEmpty)! ? UIColor.clear : color
        interestNumberLabel.textColor = UIColor.white
    }
    
    func applyColor(accentColor: UIColor, textColor: UIColor, numberColor: UIColor? = nil) {
        interestLabel.textColor = (interestLabel.text?.isEmpty)! ? UIColor.clear : accentColor
        interestLabel.backgroundColor = UIColor.clear
        labelLabel.backgroundColor = (labelLabel.text?.isEmpty)! ? UIColor.clear : accentColor
        labelLabel.textColor = (labelLabel.text?.isEmpty)! ? UIColor.clear : textColor
        plusLabel.textColor = accentColor
        interestNumberLabel.backgroundColor = (interestNumberLabel.text?.isEmpty)! ? UIColor.clear : accentColor
        if let numberColor = numberColor {
            interestNumberLabel.textColor = (interestNumberLabel.text?.isEmpty)! ? UIColor.clear : numberColor
        } else {
            interestNumberLabel.textColor = (interestNumberLabel.text?.isEmpty)! ? UIColor.clear : textColor
        }
    }
}
