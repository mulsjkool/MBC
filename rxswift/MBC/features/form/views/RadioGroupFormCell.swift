//
//  RadioGroupFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class RadioGroupFormCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    
    @IBOutlet weak private var leftImageView: UIImageView!
    @IBOutlet weak private var rightImageView: UIImageView!
    
    @IBOutlet weak private var errorLabel: UILabel!
    
    var gender: Gender?
    var preferredContactMethod: PreferredContactMethod?
    
    var onDidSubmitGender = PublishSubject<(Gender?)>()
    var onDidSubmitPreferredContactMethod = PublishSubject<(PreferredContactMethod?)>()
    
    var item: RadioGroupFormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        if Constants.DefaultValue.shouldRightToLeft {
            leftButton.contentHorizontalAlignment = .right
            rightButton.contentHorizontalAlignment = .right
            
            leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            rightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        } else {
            leftButton.contentHorizontalAlignment = .left
            rightButton.contentHorizontalAlignment = .left
            
            leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
            rightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        }
        
        leftButton.titleLabel?.numberOfLines = 2
        rightButton.titleLabel?.numberOfLines = 2
        
        leftButton.titleLabel?.lineBreakMode = .byWordWrapping
        rightButton.titleLabel?.lineBreakMode = .byWordWrapping
        
        self.updateErrorLabel(errorText: "")
    }
    
    func bindData(item: RadioGroupFormItem) {
        self.item = item
        
        titleLabel.text = item.title
        leftButton.setTitle(item.titleLeft, for: .normal)
        rightButton.setTitle(item.titleRight, for: .normal)
        self.updateErrorLabel(errorText: item.error)
        
        if !item.valueText.isEmpty {
            if item.type == .gender {
                let type = Gender(rawValue: item.valueText)
                selecteLeftButton(flag: true)
                if type == .female {
                    selecteLeftButton(flag: false)
                }
            } else {
                let type = PreferredContactMethod(rawValue: item.valueText)
                selecteLeftButton(flag: true)
                if type == .byEmail {
                    selecteLeftButton(flag: false)
                }
            }
        }
    }
    
    func updateErrorLabel(errorText: String) {
        errorLabel.text = errorText
    }
    
    // MARK: - Private methods
    
    private func selecteLeftButton(flag: Bool) {
        self.updateErrorLabel(errorText: "")
        if flag {
            leftImageView.image = R.image.iconSelected()
            rightImageView.image = R.image.iconUnselected()
            gender = Gender.male
            preferredContactMethod = PreferredContactMethod.byPhone
        } else {
            leftImageView.image = R.image.iconUnselected()
            rightImageView.image = R.image.iconSelected()
            gender = Gender.female
            preferredContactMethod = PreferredContactMethod.byEmail
        }
        
        item?.error = ""
        if item?.type == .gender {
            onDidSubmitGender.onNext(self.gender)
        } else {
            onDidSubmitPreferredContactMethod.onNext(self.preferredContactMethod)
        }
    }
    
    // MARK: - Action
    
    @IBAction func leftButtonClicked(_ sender: Any) {
        selecteLeftButton(flag: true)
    }
    
    @IBAction func rightButtonClicked(_ sender: Any) {
        selecteLeftButton(flag: false)
    }
}
