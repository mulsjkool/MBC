//
//  LoadMoreCommentCell.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class LoadMoreCommentCell: UITableViewCell {
	@IBOutlet weak private var titleLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		titleLabel.text = R.string.localizable.commentLoadMore()
		titleLabel.font = Constants.DefaultValue.loadMoreFont
		titleLabel.backgroundColor = Constants.Singleton.isiPad ? Colors.playlistRelated.color() : .clear
    }
}
