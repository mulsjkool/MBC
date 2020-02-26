//
//  ChannelCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    
    func bindData(page: PageDetail) {
        if page.logoThumbnail.isEmpty {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
        } else {
            thumbnailImageView.setSquareImage(imageUrl: page.logoThumbnail)
        }
    }
}
