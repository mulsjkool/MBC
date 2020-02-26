//
//  IPadPhotoAlbumCollectionCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 4/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class IPadPhotoAlbumCollectionCell: BaseCollectionViewCell {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var likeShareLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var lineSeperatorView: UIView!
    @IBOutlet private weak var lineSeperatorViewConstraintLeft: NSLayoutConstraint!
    @IBOutlet private weak var lineSeperatorViewConstraintRight: NSLayoutConstraint!
    private var media: Media!
    
    // MARK: Public
    func bindData(media: Media) {
        self.media = media
        showImage()
        showDescription()
        showLikeShare()
    }
    
    func shouldHideLineSeperatorView(_ should: Bool) {
        lineSeperatorView.isHidden = should
    }
    
    func marginSeperatorLeft() {
        lineSeperatorViewConstraintLeft.constant = 12
    }
    
    func marginSeperatorRight() {
        lineSeperatorViewConstraintRight.constant = 12
    }
    
    func resetMarginSeperator() {
        lineSeperatorViewConstraintLeft.constant = 0
        lineSeperatorViewConstraintRight.constant = 0
    }
    
    // MARK: Private
    private func showImage() {
        photoImageView.setImage(from: media, resolution: .ar16x16)
    }
    private func showDescription() {
        descriptionLabel.text = media.description ?? ""
    }
    
    private func showLikeShare() {
        let textNumberOfLike = R.string.localizable.cardLikecountTitle("\(media.numberOfLikes)")
        likeShareLabel.text = textNumberOfLike
    }
    
}
