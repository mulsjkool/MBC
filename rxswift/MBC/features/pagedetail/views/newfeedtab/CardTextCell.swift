//
//  CardTextCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/5/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import TTTAttributedLabel
import UIKit
import RxSwift

class CardTextCell: BaseCardTableViewCell {
	func bindData(post: Post, accentColor: UIColor?) {
        super.bindData(feed: post, accentColor: accentColor)
        bindDescription()
	}
}
