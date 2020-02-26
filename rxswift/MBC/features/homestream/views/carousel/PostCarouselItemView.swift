//
//  PostCarouselItemView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Kingfisher
import UIKit
import RxSwift
import MisterFusion

class PostCarouselItemView: BaseCarouselItemView {
	@IBOutlet weak private var authorLabel: UILabel!
	@IBOutlet weak private var commentLikeCountLabel: UILabel!
    @IBOutlet private weak var durationView: UIView!
    @IBOutlet private weak var durationLabel: UILabel!
    
    var authorNameTapped = PublishSubject<Feed>()
	
	override func bindData(_ feed: Feed) {
		super.bindData(feed)
		setAuthor()
		setLikeCount()
        setupAuthorLabelEvent()

        //When feed is article, duration don't show.
        durationLabel.text = ""
        durationView.isHidden = true
        
        if feed is Post {
            if (feed as? Post)?.postSubType == .video {
                self.showVideoDuration()
            }
            if (feed as? Post)?.postSubType == .image {
                self.showImageNumber()
            }
        }
	}
	
	private func setLikeCount() {
        guard let numOfLike = feed.numOfLikes, numOfLike > 0 else {
            self.commentLikeCountLabel.text = ""
            return
        }
        self.commentLikeCountLabel.text = R.string.localizable.cardLikecountTitle("\(numOfLike)")
	}
	
	private func setAuthor() {
		self.authorLabel.text = feed.author != nil ? feed.author?.name : ""
	}
    
    private func setupAuthorLabelEvent() {
        authorLabel.isUserInteractionEnabled = true
        let authorNameTapGesture = UITapGestureRecognizer()
        authorLabel.addGestureRecognizer(authorNameTapGesture)
        
        authorNameTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.authorNameTapped.onNext((self.feed))
            })
            .disposed(by: disposeBag)
    }
    
    private func showVideoDuration() {
        if let video = (feed as? Post)?.medias?.first as? Video {
            durationLabel.text = Common.formatDurationFrom(video.duration)
            durationView.isHidden = false
        }
    }
    
    private func showImageNumber() {
        if let array = (feed as? Post)?.medias, !array.isEmpty {
            durationLabel.text = R.string.localizable.commonPhotoNumbers("\(array.count)")
            durationView.isHidden = false
        }
    }
}
