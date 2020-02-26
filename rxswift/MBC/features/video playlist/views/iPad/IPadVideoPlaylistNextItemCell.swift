//
//  IPadVideoPlaylistNextItemCell.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class IPadVideoPlaylistNextItemCell: UITableViewCell {
	@IBOutlet weak private var thumbnailImageView: UIImageView!
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var authorLabel: UILabel!
	@IBOutlet weak private var numberOfLikeCommentLabel: UILabel!
	@IBOutlet weak private var overlayNextItemView: UIView!
	@IBOutlet weak private var durationView: UIView!
	@IBOutlet weak private var durationLabel: UILabel!
	@IBOutlet weak private var nextItemLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
    }
	
	private func setupUI() {
		nextItemLabel.text = R.string.localizable.commonVideoNextItem()
	}
    
}
