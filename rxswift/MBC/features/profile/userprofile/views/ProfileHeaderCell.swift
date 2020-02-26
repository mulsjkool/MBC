//
//  ProfileHeaderView.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class ProfileHeaderCell: BaseTableViewCell {
    @IBOutlet weak private var fullNameLabel: UILabel!
    @IBOutlet weak private var subNameLabel: UILabel!
    @IBOutlet weak private var activityLogLabel: UILabel!
    @IBOutlet weak private var settingLabel: UILabel!
    @IBOutlet weak private var profileLabel: UILabel!
    
    @IBOutlet weak private var profileButton: UIButton!
    @IBOutlet weak private var settingButton: UIButton!
    @IBOutlet weak private var activityLogButton: UIButton!
    @IBOutlet weak private var avatarButton: UIButton!
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    
    @IBOutlet weak private var buttonBarView: UIView!
    
    var onProfileButtonClicked = PublishSubject<Void>()
    var onSettingButtonClicked = PublishSubject<Void>()
    var onActivityButtonClicked = PublishSubject<Void>()
    var onAvatarButtonClicked = PublishSubject<(ProfileHeaderCell)>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }
    
    private func setupUI() {
        profileLabel.text = R.string.localizable.userProfileTabProfileTitle()
        settingLabel.text = R.string.localizable.userProfileTabSettingTitle()
        activityLogLabel.text = R.string.localizable.userProfileTabActivityLogTitle()
        fullNameLabel.text = ""
        subNameLabel.text = ""
        buttonBarView.isHidden = true
    }
    
    func bindData(user: UserProfile?, selectedTab: TabUserProfileSelection) {
        updateSelectedTab(selectedTab: selectedTab)
        
        guard let user = user else { return }
        
        fullNameLabel.text = ""
        subNameLabel.text = ""
        if !user.name.isEmpty {
            fullNameLabel.text = user.name
            subNameLabel.text = user.email
        } else { fullNameLabel.text = user.email }
        
        if !user.photoURL.isEmpty {
            avatarImageView.setSquareImage(imageUrl: user.photoURL, placeholderImage: R.image.iconAvatarDefault72x107(),
                                           gifSupport: true)
        }
    }
    
    private func updateSelectedTab(selectedTab: TabUserProfileSelection) {
        profileButton.tintColor = Colors.userProfileTabButton.color()
        settingButton.tintColor = Colors.userProfileTabButton.color()
        activityLogButton.tintColor = Colors.userProfileTabButton.color()
        
        profileLabel.textColor = Colors.dark.color()
        settingLabel.textColor = Colors.dark.color()
        activityLogLabel.textColor = Colors.dark.color()
        
        switch selectedTab {
        case .profile:
            profileButton.tintColor = Colors.defaultAccentColor.color()
            profileLabel.textColor = Colors.defaultAccentColor.color()
        case .setting:
            settingButton.tintColor = Colors.defaultAccentColor.color()
            settingLabel.textColor = Colors.defaultAccentColor.color()
        case .activityLog:
            activityLogButton.tintColor = Colors.defaultAccentColor.color()
            activityLogLabel.textColor = Colors.defaultAccentColor.color()
        }
    }
    
    // MARK: - Action
    
    @IBAction func profileButtonClicked(_ sender: Any) {
        self.onProfileButtonClicked.onNext(())
    }
    
    @IBAction func settingButtonClicked(_ sender: Any) {
        self.onSettingButtonClicked.onNext(())
    }
    
    @IBAction func activityLogButtonClicked(_ sender: Any) {
        self.onActivityButtonClicked.onNext(())
    }
    
    @IBAction func avatarButtonClicked(_ sender: Any) {
        self.onAvatarButtonClicked.onNext(self)
    }
}
