//
//  TaggedPageListingCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class TaggedPageListingCell: BaseTableViewCell {

    @IBOutlet weak private var authorImageView: UIImageView!
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var separatorLineRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var separatorLineLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorLineRightConstraint.constant = Constants.DefaultValue.shouldRightToLeft ? 0
            : Constants.DefaultValue.defaultMargin
        separatorLineLeftConstraint.constant = Constants.DefaultValue.shouldRightToLeft
            ? Constants.DefaultValue.defaultMargin : 0
    }
    
    func bindData(author: Author) {
        bindAuthorAvatar(avatar: author.avatarUrl)
        bindAuthorName(authorName: author.name)
    }
    
    private func bindAuthorAvatar(avatar: String?) {
        if let avatar = avatar {
            authorImageView.setSquareImage(imageUrl: avatar, placeholderImage: R.image.iconNoLogo())
        } else {
            authorImageView.image = R.image.iconNoLogo()
        }
    }
    
    private func bindAuthorName(authorName: String?) {
        authorNameLabel.text = authorName ?? ""
    }
}
