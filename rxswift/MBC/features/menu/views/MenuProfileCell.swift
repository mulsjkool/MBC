//
//  MenuProfileCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class MenuProfileCell: BaseTableViewCell {
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        statusLabel.text = R.string.localizable.commonAvatarStatus()
        nameLabel.text = ""
    }
    
    func updateView(user: UserProfile?) {
        setSelection()
        guard let user = user else { return }
        
        nameLabel.text = ""
        if !user.name.isEmpty {
            nameLabel.text = user.name
        } else {
            nameLabel.text = user.email
        }
        
        if !user.photoURL.isEmpty {
            avatarImageView.setSquareImage(imageUrl: user.photoURL,
                                           placeholderImage: R.image.iconAvatarDefault100x100(),
                                           gifSupport: true)
        }
    }
    
    func cancelDownloadTask() {
        avatarImageView.kf.cancelDownloadTask()
    }
    
    private func setSelection() {
        selectionStyle = .default
    }
}
