//
//  CommentViewCel.swift
//  MBC
//
//  Created by Tri Vo on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class HeaderCommentViewCell: BaseTableViewCell {
    
    @IBOutlet weak private var commentLabel: UILabel!
    @IBOutlet weak private var numberOfCommentLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		commentLabel.text = R.string.localizable.commentTitle()
	}
    
    func bindData(comments: [Comment]?) {
        numberOfCommentLabel.text = "(\(comments?.count ?? 0))"
    }
    
}
