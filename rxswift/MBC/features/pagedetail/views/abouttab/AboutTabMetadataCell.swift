//
//  AboutTabMetadataCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/15/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import MisterFusion
import UIKit

class AboutTabMetadataCell: BaseTableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var metadataContainView: UIView!
    @IBOutlet weak private var metadataContainViewHeightConstraint: NSLayoutConstraint!
    
    private let minTitleLabelWidth: CGFloat = 85.0
    
    func bindData(metadata: [[String: String]]) {
        var maxWidth: CGFloat = 0.0
        var previousView: AboutTabMetadataView? = nil
        for dict in metadata {
            guard let key = dict.keys.first else {
                continue
            }
            let metadataView = AboutTabMetadataView.create()
            metadataContainView.addSubview(metadataView)
            metadataView.bindData(title: key, metadata: dict[key]!)
            
            metadataView.translatesAutoresizingMaskIntoConstraints = false
            if let previousView = previousView {
                metadataContainView.mf.addConstraints(
                    metadataView.top |==| previousView.bottom,
                    metadataView.left |==| metadataContainView.left,
                    metadataView.right |==| metadataContainView.right
                    //metadataView.height |==| metadataView.getViewHeight()
                )
            } else {
                metadataContainView.mf.addConstraints(
                    metadataView.top |==| metadataContainView.top,
                    metadataView.left |==| metadataContainView.left,
                    metadataView.right |==| metadataContainView.right
                    //metadataView.height |==| metadataView.getViewHeight()
                )
            }
            previousView = metadataView
            maxWidth = (maxWidth > metadataView.getTitleLabelWidth()) ? maxWidth : metadataView.getTitleLabelWidth()
        }
        
        maxWidth = (maxWidth > minTitleLabelWidth) ? maxWidth : minTitleLabelWidth
        for subView in metadataContainView.subviews {
            if let metadataView = subView as? AboutTabMetadataView {
                metadataView.setTitleLabelWidthConstraint(value: maxWidth)
                metadataContainView.mf.addConstraints(
                    metadataView.height |==| metadataView.getViewHeight()
                )
            }
        }
        layoutIfNeeded()
        if let previousView = previousView {
            metadataContainViewHeightConstraint.constant = previousView.frame.origin.y + previousView.frame.size.height
        }
    }
}
