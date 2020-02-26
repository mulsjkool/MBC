//
//  LoadMoreCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class LoadMoreCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
}
