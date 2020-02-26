//
//  RadioSocialCell.swift
//  MBC
//
//  Created by Tri Vo on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class RadioSocialCell: UICollectionViewCell {
	@IBOutlet weak private var socialImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	func bindData(data: SocialNetwork, bgColor: UIColor) {
		if let logoImage = data.socialNetworkName.whiteLogo() {
			socialImageView.image = logoImage
		}
		backgroundColor = bgColor
	}
}
