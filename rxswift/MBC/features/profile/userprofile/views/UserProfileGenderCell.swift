//
//  UserProfileGenderCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class UserProfileGenderCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    
    @IBOutlet weak private var maleButton: UIButton!
    @IBOutlet weak private var femaleButton: UIButton!
    
    @IBOutlet weak private var maleImageView: UIImageView!
    @IBOutlet weak private var femaleImageView: UIImageView!
    
    @IBOutlet weak private var okButton: UIButton!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var editButton: UIButton!
    
    var gender: Gender!
    var profileItem: ProfileGenderItem!
    
    var onDidSubmitRequest = PublishSubject<(Gender)>()
    var onNeedReloadCell = PublishSubject<Void>()
    var onEditButtonClicked = PublishSubject<(UserProfileGenderCell)>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    private func setupUI() {
        maleButton.setTitle(R.string.localizable.commonButtonMale(), for: .normal)
        femaleButton.setTitle(R.string.localizable.commonButtonFemale(), for: .normal)
        
        if Constants.DefaultValue.shouldRightToLeft {
            maleButton.contentHorizontalAlignment = .right
            femaleButton.contentHorizontalAlignment = .right
            
            maleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            femaleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        } else {
            maleButton.contentHorizontalAlignment = .left
            femaleButton.contentHorizontalAlignment = .left
            
            maleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
            femaleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        }
    
        selecteMale(flag: true)
    }
    
    func bindData(item: ProfileGenderItem, user: UserProfile?) {
        self.profileItem = item
        self.isEditingView(flag: item.isEditting)
        
        titleLabel.text = item.titleLabel
        maleButton.setTitle(item.maleTitle, for: .normal)
        femaleButton.setTitle(item.femaleTile, for: .normal)
        if user?.gender == Gender.male {
            selecteMale(flag: true)
            valueLabel.text = item.maleTitle
        } else {
            selecteMale(flag: false)
            valueLabel.text = item.femaleTile
        }
    }
    
    private func isEditingView(flag: Bool) {
        okButton.isHidden = !flag
        cancelButton.isHidden = !flag
        editButton.isHidden = flag
        
        maleButton.isHidden = !flag
        maleImageView.isHidden = !flag
        femaleButton.isHidden = !flag
        femaleImageView.isHidden = !flag
        valueLabel.isHidden = flag
    }
    
    private func selecteMale(flag: Bool) {
        if flag {
            maleImageView.image = R.image.iconSelected()
            femaleImageView.image = R.image.iconUnselected()
            gender = Gender.male
        } else {
            maleImageView.image = R.image.iconUnselected()
            femaleImageView.image = R.image.iconSelected()
            gender = Gender.female
        }
    }
    
    private func updateStatus() {
        self.profileItem.isEditting = !self.profileItem.isEditting
        self.isEditingView(flag: self.profileItem.isEditting)
    }
    
    // MARK: - Action
    
    @IBAction func maleButtonClicked(_ sender: Any) {
        selecteMale(flag: true)
    }
    
    @IBAction func femaleButtonClicked(_ sender: Any) {
        selecteMale(flag: false)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.updateStatus()
        self.onNeedReloadCell.onNext(())
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        self.updateStatus()
        if gender == Gender.male { valueLabel.text = self.profileItem.maleTitle } else {
            valueLabel.text = self.profileItem.femaleTile
        }
        onDidSubmitRequest.onNext(gender)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.updateStatus()
        onEditButtonClicked.onNext(self)
    }
}
