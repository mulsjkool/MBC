//
//  PlaylistCarouselCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class PlaylistCarouselCollectionViewCell: BundleCarouselCollectionViewCell {
    
    @IBOutlet weak private var numberOfVideoView: UIView!
    @IBOutlet weak private var commentCountLabel: UILabel!
    @IBOutlet weak private var likeCountLabel: UILabel!
    @IBOutlet weak private var likeCommentCountSeparatedLabel: UILabel!
    
    var numberOfVideoTapped = PublishSubject<Void>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = getImageView()
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
    }
    
    override func bindData(_ feed: Feed, accentColor: UIColor? = nil) {
        super.bindData(feed, accentColor: accentColor)
        bindLikeAndCommentNo()
        setupNumberOfVideoEvent()
    }
    
    private func bindLikeAndCommentNo() {
        let commentCount = feed.numOfComments ?? 0
        if commentCount > 0 {
            commentCountLabel.text = R.string.localizable.cardCommentcountTitle("\(commentCount)").localized()
        } else {
            commentCountLabel.text = ""
        }
        
        let likeCount = feed.numOfLikes ?? 0
        if likeCount > 0 {
            likeCountLabel.text = R.string.localizable.cardLikecountTitle("\(likeCount)").localized()
        } else {
            likeCountLabel.text = ""
        }
        likeCommentCountSeparatedLabel.isHidden = (likeCount == 0 || commentCount == 0)
    }
    
    private func setupNumberOfVideoEvent() {
        numberOfVideoView.isUserInteractionEnabled = true
        let numberOfVideoTapGesture = UITapGestureRecognizer()
        numberOfVideoView.addGestureRecognizer(numberOfVideoTapGesture)
        
        numberOfVideoTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.numberOfVideoTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
