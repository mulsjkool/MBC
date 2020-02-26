//
//  TaggedPageItemCollectionViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import Kingfisher

class TaggedPageItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    private var logo: String!
    
    func bindData(logo: String) {
        self.logo = logo
        showImage()
    }
    
    private func showImage() {
        guard let logo = self.logo else {
            imageView.image = R.image.iconPhotoTaggedPlaceholder()
            return
        }
        imageView.setSquareImage(imageUrl: logo, placeholderImage: R.image.iconPhotoTaggedPlaceholder())
    }
}
