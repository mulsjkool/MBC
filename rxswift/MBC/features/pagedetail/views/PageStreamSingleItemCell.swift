//
//  PageStreamSingleItemCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class PageStreamSingleItemCell: HomeStreamSingleItemCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func bindData(feed: Feed, accentColor: UIColor?) {
        super.bindData(feed: feed, accentColor: accentColor)
    }
    
    override func bindThumnail() {
        super.bindThumnail()
        if let post = feed as? Post {
            guard let thumbnail = post.thumbnail else { return }
            bindThumnailFrom(imageUrl: thumbnail)
        }
    }
}
