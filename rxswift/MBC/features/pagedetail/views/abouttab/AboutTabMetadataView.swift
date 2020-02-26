//
//  AboutTabMetadataView.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class AboutTabMetadataView: UIView {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var metadataLabel: UILabel!
    @IBOutlet weak private var containViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLabelWidthConstraint: NSLayoutConstraint!
    
    private let defaultLabelHeight: CGFloat = 14.0
    
    static func create() -> AboutTabMetadataView {
        if let metadataView = Bundle.main.loadNibNamed(R.nib.aboutTabMetadataView.name,
                                                       owner: nil, options: nil)?.first as? AboutTabMetadataView {
            return metadataView
        }
        return AboutTabMetadataView()
    }
    
    func bindData(title: String, metadata: String) {
        self.titleLabel.text = "\(title)"
        self.metadataLabel.text = metadata
        layoutIfNeeded()
        containViewHeightConstraint.constant =
            (self.titleLabel.frame.size.height > self.metadataLabel.frame.size.height)
            ? (self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y * 2)
            : (self.metadataLabel.frame.size.height + self.metadataLabel.frame.origin.y * 2)
    }
    
    func getViewHeight() -> CGFloat {
        layoutIfNeeded()
        containViewHeightConstraint.constant =
            (self.titleLabel.frame.size.height > self.metadataLabel.frame.size.height)
            ? (self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y * 2)
            : (self.metadataLabel.frame.size.height + self.metadataLabel.frame.origin.y * 2)
        return containViewHeightConstraint.constant
    }
    
    func getTitleLabelWidth() -> CGFloat {
        return (titleLabel.text?.width(withConstrainedHeight: defaultLabelHeight, font: titleLabel.font))!
    }
    
    func setTitleLabelWidthConstraint(value: CGFloat) {
        titleLabelWidthConstraint.constant = value
    }
}
