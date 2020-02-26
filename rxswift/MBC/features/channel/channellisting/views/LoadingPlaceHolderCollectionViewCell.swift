//
//  LoadingPlaceHolderCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class LoadingPlaceHolderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var loadingView: UIView!

    func showLoadingAnimation() {
        self.layoutIfNeeded()
        loadingView.stopShimmering()
        loadingView.startShimmering()
    }
}
