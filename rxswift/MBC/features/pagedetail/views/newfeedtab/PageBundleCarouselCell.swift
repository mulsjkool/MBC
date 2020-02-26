//
//  PageBundleCarouselCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class PageBundleCarouselCell: CarouselTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let collectionView = getCollectionView()
        collectionView.register(R.nib.pageBundleCarouselCollectionViewCell(),
                        forCellWithReuseIdentifier: R.reuseIdentifier.pageBundleCarouselCollectionViewCell.identifier)
    }
}
