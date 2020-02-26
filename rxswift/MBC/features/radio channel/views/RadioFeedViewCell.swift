//
//  RadioFeedViewCell.swift
//  MBC
//
//  Created by Tri Vo on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class RadioFeedViewCell: UITableViewCell {
	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var nameLabel: UILabel!
	@IBOutlet weak private var descriptionLabel: UILabel!
	@IBOutlet weak private var timestampLabel: UILabel!
	@IBOutlet weak private var thumnailImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func bindData(data: RadioFeed?, titleColor: UIColor, textColor: UIColor, bgColor: UIColor) {
		guard let radioFeed = data else { return }
		titleLabel.text = radioFeed.title
		nameLabel.text = radioFeed.name
		descriptionLabel.text = radioFeed.description
		timestampLabel.text = radioFeed.timestamp
		thumnailImageView.setSquareImage(imageUrl: radioFeed.imageUrl)
		
		titleLabel.textColor = titleColor
		containerView.backgroundColor = bgColor
		nameLabel.textColor = textColor
		descriptionLabel.textColor = textColor
		timestampLabel.textColor = textColor
	}
}
