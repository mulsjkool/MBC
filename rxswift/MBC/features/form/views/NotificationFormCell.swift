//
//  NotificationFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 4/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class NotificationFormCell: BaseTableViewCell {
    @IBOutlet weak private var topLabel: UILabel!
    @IBOutlet weak private var bottomLabel: UILabel!
    @IBOutlet weak private var iconImage: UIImageView!
    
    func loadAdvertisementData() {
        iconImage.image = R.image.icFormAdvertiseOk()
        topLabel.text = R.string.localizable.formAdvertisementSendOKTitle1()
        bottomLabel.removeFromSuperview()
        self.contentView.layoutIfNeeded()
    }
    
    func loadContactUsData() {
        iconImage.image = R.image.icFormContactUsOk()
        topLabel.text = R.string.localizable.formContactUsSendOKTitle1()
        bottomLabel.text = R.string.localizable.formContactUsSendOKTitle2()
    }
}
