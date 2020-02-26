//
//  PlaylistSearchResultCell.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class PlaylistSearchResultCell: UITableViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var countLabel: UILabel!
    @IBOutlet weak private var likeCommentCountLabel: UILabel!
    
    private var playList: Playlist!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindData(data: Playlist) {
        playList = data
        setThumbnailImageview()
        setTitle()
        updateSocialCount()
        showTotalLabel()
    }
    
    private func setThumbnailImageview() {
        thumbnailImageView.clipsToBounds = true
        guard let thumbnailUrl = playList.thumbnail else {
            thumbnailImageView.image = R.image.iconPhotoPlaceholder(); return
        }
        thumbnailImageView.setSquareImage(imageUrl: thumbnailUrl,
                                          placeholderImage: R.image.iconPhotoPlaceholder())
    }
    
    private func setTitle() {
        titleLabel.text = playList.title ?? ""
    }
    
    private func updateSocialCount() {
        let array = [
            R.string.localizable.cardLikecountTitle("\(playList.numOfLikes ?? 0)"),
            R.string.localizable.cardCommentcountTitle("\(playList.numOfComments ?? 0)")
        ]
        guard !array.isEmpty else { return }
        self.likeCommentCountLabel.text = array.map({ "\($0)" })
            .joined(separator: Constants.DefaultValue.MetadataSeparatorString)
    }
    
    private func showTotalLabel() {
        countLabel.text = R.string.localizable.commonVideoTitleCount("\(playList.items.count)")
    }
}
