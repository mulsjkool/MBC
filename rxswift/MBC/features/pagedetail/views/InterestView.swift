//
//  ViewInterest.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class InterestView: UIView {

	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var interestLabel: UILabel!
	@IBOutlet weak private var labelLabel: PaddingLabel!
	@IBOutlet weak private var interestLabelLeftConstraint: NSLayoutConstraint!
	@IBOutlet weak private var interestNumberLabel: PaddingLabel!
	@IBOutlet weak private var interestNumberContainView: UIView!
	@IBOutlet weak private var plusLabel: UILabel!
	
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
		containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
	func setLabelLabel(value: String!) {
		self.labelLabel.text = value
	}
	
	func setHiddenLabelLabel(isHidden: Bool) {
		self.labelLabel.isHidden = isHidden
	}
	
	func setInterestLabel(value: String!) {
		self.interestLabel.text = value
	}
	
	func setInterestNumberLabel(value: String!) {
		self.interestNumberLabel.text = value
	}
	
	func setConstraintValueForInerestLabelLeft(value: CGFloat) {
		self.interestLabelLeftConstraint.constant = value
	}
	
	func setHiddenInterestNumberContainView(isHidden: Bool) {
		self.interestNumberContainView.isHidden = isHidden
	}
	
    func bindInterests(interests: [Interest]?) {
        bindInterests(interests: interests?.map { $0.name })
    }
    
    func bindInterests(interests: [String]?) {
        interestNumberContainView.isHidden = true
        interestLabel.text = ""
        interestNumberLabel.text = ""
        if let interests = interests {
            if !interests.isEmpty {
                for interest in interests {
                    interestLabel.text = interest
                }
                if interests.count > 1 {
                    interestNumberLabel.text = "\(interests.count)"
                    interestNumberContainView.isHidden = false
                }
            }
        }
    }
    
    func bindLabel(label: String?) {
        if let label = label {
            if !label.isEmpty {
                labelLabel.text = label
                labelLabel.isHidden = false
                self.interestLabelLeftConstraint.constant = 10.0
            } else {
                labelLabel.text = ""
                labelLabel.isHidden = true
                self.interestLabelLeftConstraint.constant = -2.0
            }
        } else {
            labelLabel.text = ""
            labelLabel.isHidden = true
            self.interestLabelLeftConstraint.constant = -2.0
        }
    }
    
    func applyAccentColor(accentColor: UIColor?) {
        var color = Colors.defaultAccentColor.color()
        if let accentColor = accentColor {
            color = accentColor
        }
        interestLabel.textColor = color
        labelLabel.backgroundColor = color
        plusLabel.textColor = color
        interestNumberLabel.backgroundColor = color
    }
}
