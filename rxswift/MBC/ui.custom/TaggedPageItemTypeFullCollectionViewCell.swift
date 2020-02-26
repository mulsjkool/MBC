//
//  TaggedPageItemTypeFullCollectionViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class TaggedPageItemTypeFullCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    private var page: MenuPage!
    
    func bindData(page: MenuPage) {
        self.page = page
        showImage()
        showTitle()
    }
    
    private func showImage() {
        guard let page = self.page, !page.posterUrl.isEmpty else {
            imageView.image = R.image.iconNoLogo()
            return
        }
        imageView.setSquareImage(imageUrl: page.posterUrl, placeholderImage: R.image.iconPhotoPlaceholder())
    }
    
    private func showTitle() {
        guard let page = self.page else {
            titleLabel.text = ""
            return
        }
        titleLabel.text = page.title
    }
}
