//
//  BundleSearchResultCell.swift
//  MBC
//
//  Created by Tri Vo on 3/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class BundleSearchResultCell: UITableViewCell {
	
	@IBOutlet weak private var avatarImageView: UIImageView!
	@IBOutlet weak private var authorLabel: UILabel!
	@IBOutlet weak private var pageTileLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
		avatarImageView.cornerRadius = avatarImageView.bounds.height / 2
    }
	
	func bindData(bundle: Feed) {
		if let author = bundle.author {
			avatarImageView.setSquareImage(imageUrl: bundle.thumbnail)
			authorLabel.text = author.name
		}
		pageTileLabel.text = bundle.title ?? ""
	}
}
