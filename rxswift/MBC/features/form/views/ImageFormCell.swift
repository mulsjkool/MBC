//
//  ImageFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ImageFormCell: BaseTableViewCell {
    @IBOutlet weak private var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleToFill
    }
    
    func loadAdvertisementCover() {
        coverImageView.image = R.image.imgAdvertiseCover()
    }
    
    func loadContactUsCover() {
        coverImageView.image = R.image.imgContactUsCover()
    }
}
