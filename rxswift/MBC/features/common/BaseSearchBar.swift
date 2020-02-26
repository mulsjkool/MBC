//
//  BaseSearchBar.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 4/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import UIKit
import MisterFusion

class BaseSearchBar: UISearchBar {
    var isEditing = false
    private var magnifyImage: UIImageView?
    private var magnifyYConstraint: NSLayoutConstraint?
    private var replacingPhLabel: UILabel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawCustomSearchBar()
    }
    
    var cancelButton: UIButton? {
         return value(forKey: Constants.UIControlKey.cancelButtonUISearchBar) as? UIButton
    }
    
    var clearTextButton: UIButton? {
        return searchField?.value(forKey: Constants.UIControlKey.clearButtonUISearchBar) as? UIButton
    }
    
    var placeholderLabel: UILabel? {
        return searchField?.value(forKey: Constants.UIControlKey.placeholderLabelUISearchBar) as? UILabel
    }
    
    var searchField: UITextField? {
        return value(forKey: Constants.UIControlKey.searchField) as? UITextField
    }
    
    func drawCustomSearchBar() {
        self.drawSearchBar()
        self.drawSearchField()
        self.customSearchIcon()
        self.layoutPlaceholderText()
    }
    
    private func indexOfSearchFieldInSubviews() -> Int? {
        guard let searchView = subviews.first else { return nil }
        var index: Int?
        
        for i in 0 ..< searchView.subviews.count where searchView.subviews[i] is UITextField {
            index = i
            break
        }
        
        return index
    }
    
    private func drawSearchBar() {
        self.searchTextPositionAdjustment = UIOffsetMake(5, 2) // adjust position of search text field, placeholder
        
        guard let searchBarHolder = self.superview?.superview,
            "\(type(of: searchBarHolder))" == Constants.UIControlClassName.searchAdaptorView else {
                // iOS 10
                if isEditing {
                    superview?.frame.origin.x = 0
                    superview?.frame.size.width = Constants.DeviceMetric.screenWidth
                        - Constants.DeviceMetric.navBarSearchBarMargin
                    frame = superview?.frame ?? CGRect.zero
                    frame.origin.x = Constants.DeviceMetric.navBarSearchBarMargin
                    frame.origin.y = 0
                } else {
                    frame = superview?.frame ?? CGRect.zero
                    frame.origin.x = 0
                    frame.origin.y = 0
                    if let height = superview?.frame.size.height { frame.size.height = height }
                }
                return
        }
        
        // iOS 11
        if isEditing {
            let parentFrame = searchBarHolder.superview?.superview?.frame ?? CGRect.zero
            searchBarHolder.frame = CGRect(x: 0, y: searchBarHolder.frame.origin.y,
                                           width: parentFrame.size.width, height: searchBarHolder.frame.size.height)
            superview?.frame.size.width = searchBarHolder.frame.size.width
                - Constants.DeviceMetric.navBarSearchBarMargin
            frame = superview?.frame ?? CGRect.zero
            frame.origin.x += Constants.DeviceMetric.navBarSearchBarMargin
        } else {
            frame = superview?.frame ?? CGRect.zero
            
            frame.size.width -= Constants.DeviceMetric.navBarSearchBarMargin
            frame.origin.x += Constants.DeviceMetric.navBarSearchBarMargin / 2
        }
    }
    
    private func drawSearchField() {
        guard let index = indexOfSearchFieldInSubviews(), let searchView = subviews.first,
            let searchField: UITextField = searchView.subviews[index] as? UITextField else { return }
        
        searchView.backgroundColor = UIColor.clear
        
        searchField.frame.origin.x = 0
        searchField.frame.origin.y = 0
        
        searchField.frame.size.height = Constants.DeviceMetric.navBarSearchBarHeight
        
        if isEditing, let button = cancelButton {
            searchField.frame.origin.x = button.frame.origin.x + button.frame.size.width
                + Constants.DeviceMetric.navBarSearchBarMargin
            searchField.frame.size.width = searchView.frame.size.width - searchField.frame.origin.x
                - Constants.DeviceMetric.navBarSearchBarMargin
            button.frame.origin.y = -2 // button align vertically
        } else {
            searchField.frame.size.width = searchView.frame.size.width
        }
        
        searchField.textColor = tintColor
        searchField.backgroundColor = Colors.white.color(alpha: 0.3)
        searchField.borderStyle = .none
        searchField.layer.cornerRadius = searchField.bounds.height * 0.5
        searchField.clipsToBounds = true
        searchField.font = Fonts.Primary.regular.toFontWith(size: 12)
        
        // iOS 10, background image
        guard let backgroundImage = (searchView.subviews.first { return "\(type(of: $0))"
            == Constants.UIControlClassName.searchBarBackground
        }) else { return }
        backgroundImage.frame = searchField.frame
    }
    
    private func layoutPlaceholderText() {
        // label
        guard let txtField = searchField, let phLabel = placeholderLabel else { return }
        
        phLabel.isHidden = true
        phLabel.textColor = Colors.unselectedTabbarItem.color()
        if replacingPhLabel == nil {
            replacingPhLabel = UILabel()
            replacingPhLabel!.font = phLabel.font
            replacingPhLabel!.textColor = phLabel.textColor
            
            txtField.addSubview(replacingPhLabel!)
        }
        
        phLabel.textColor = Colors.redActiveTabbarItem.color()
        replacingPhLabel?.text = phLabel.text
        if isEditing {
            replacingPhLabel?.isHidden = txtField.hasText
            replacingPhLabel?.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
            replacingPhLabel?.frame = phLabel.frame
        } else {
            replacingPhLabel?.textAlignment = .center
            replacingPhLabel?.frame = phLabel.frame
            
            if phLabel.frame == CGRect.zero { // iOS 10, something is incorrect, where the frame hasn't been setup
                replacingPhLabel?.frame = txtField.frame
            } else {
                replacingPhLabel?.frame.origin.x = (txtField.frame.size.width - phLabel.frame.size.width) * 0.5
            }
        }
    }
    
    private func customSearchIcon() {
        guard let searchTextField = searchField else { return }
        
        let image: UIImage = R.image.iconSearch()!
        let imageView: UIImageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 6, y: 6, width: 12, height: 12)
        searchTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        searchTextField.attributedPlaceholder = NSAttributedString(string: searchTextField.placeholder!,
                                                                   attributes: [NSAttributedStringKey.foregroundColor:
                                                                    Colors.unselectedTabbarItem.color()])
        if Constants.DefaultValue.shouldRightToLeft {
            if isEditing {
                searchTextField.leftView = imageView
                searchTextField.leftViewMode = .always
                searchTextField.rightView = nil
            } else {
                searchTextField.leftView = nil
                searchTextField.rightViewMode = .always
                searchTextField.rightView = imageView
            }
            
        } else {
            searchTextField.leftView = nil
            searchTextField.rightView = imageView
            searchTextField.rightViewMode = .always
        }
        
        if let clearButton = clearTextButton { clearButton.setImage(R.image.iconCloseWhite(), for: .normal) }
    }
}
