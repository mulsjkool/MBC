//
//  RelatedContentCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import RxSwift

class RelatedContentCell: BaseCardTableViewCell {
    
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var numberOfImageContainView: UIView!
    @IBOutlet weak private var numberOfImageLabel: PaddingLabel!
    @IBOutlet weak private var videoContainView: UIView!
    @IBOutlet weak private var imageAspectConstraint: NSLayoutConstraint!
    
    var inlinePlayer: InlineTHEOPlayer!
    var didTapVideo = PublishSubject<Video>()
    let relatedContentThumbnailTapped = PublishSubject<Void>()
    
    override func bindData(feed: Feed, accentColor: UIColor?) {
        super.bindData(feed: feed, accentColor: accentColor)
        bindContentTitle()
        bindThumbnail()
        bindNumberOfImage()
        setupEvents()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
        if inlinePlayer != nil && inlinePlayer.theoPlayer != nil, !inlinePlayer.theoPlayer.isDestroyed {
            inlinePlayer.prepareForReuse()
            inlinePlayer = nil
            for subView in videoContainView.subviews {
                subView.removeFromSuperview()
            }
        }
        video = nil
    }
    
    func playVideo(currentTime: Double) {
        guard let video = video else {
            inlinePlayer = nil
            return
        }
        video.currentTime.value = currentTime
        video.hasEnded.value = false
        setUpVideo()
    }
    
    private func setupEvents() {
        thumbnailImageView.isUserInteractionEnabled = true
        let thumbnailTapGesture = UITapGestureRecognizer()
        thumbnailImageView.addGestureRecognizer(thumbnailTapGesture)
        
        thumbnailTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.relatedContentThumbnailTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNumberOfImage() {
        if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType),
            type == .image, let numberOfImages = feed.numberOfImages, numberOfImages > 1 {
            numberOfImageContainView.isHidden = false
            numberOfImageLabel.isHidden = false
            numberOfImageLabel.text = "\(R.string.localizable.commonLabelAlbum()) \(numberOfImages)"
        } else {
            numberOfImageContainView.isHidden = true
            numberOfImageLabel.isHidden = true
            numberOfImageLabel.text = ""
        }
    }
    
    private func bindContentTitle() {
        let titleLabel = getDescriptionLabel()
        guard let text = feed.title else {
            titleLabel.text = ""
            return
        }
        titleLabel.from(html: text)
        Common.setupDescriptionFor(label: titleLabel, whenExpanding: feed.isTitleExpanded,
                                   maxLines: Constants.DefaultValue.numberOfLinesForRelatedContentTitle,
                                   linkColor: accentColor,
                                   delegate: self)
    }
    
    private func bindThumbnail() {
        if let post = self.feed as? Post {
            if let subTypeStr = post.subType, let subType = FeedSubType(rawValue: subTypeStr), subType == .video {
                setUpVideo()
                return
            }
            if let photo = post.medias?.first {
                thumbnailImageView.setImage(from: photo, resolution: .ar16x16, gifSupport: true)
                hideVideo()
                return
            }
        }

        if let app = self.feed as? App, let photo = app.photo {
            thumbnailImageView.setImage(from: photo, resolution: .ar16x16, gifSupport: true)
            hideVideo()
            return
        }
        if let article = self.feed as? Article, let photo = article.photo {
            thumbnailImageView.setImage(from: photo, resolution: .ar16x16, gifSupport: true)
            hideVideo()
            return
        }
        thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
        hideVideo()
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        if let post = self.feed as? Post, let photo = post.medias?.first, photo.isAGif {
            resumeGifAnimation(yOrdinate: yOrdinate, viewPortHeight: viewPortHeight)
        }
        if let app = self.feed as? App, let photo = app.photo, photo.isAGif {
            resumeGifAnimation(yOrdinate: yOrdinate, viewPortHeight: viewPortHeight)
        }
        if let article = self.feed as? Article, let photo = article.photo, photo.isAGif {
            resumeGifAnimation(yOrdinate: yOrdinate, viewPortHeight: viewPortHeight)
        }
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    private func resumeGifAnimation(yOrdinate: CGFloat, viewPortHeight: CGFloat) {
        let gifHeight = thumbnailImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + thumbnailImageView.convert(thumbnailImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? thumbnailImageView.resumeGifAnimation() : thumbnailImageView.pauseGifAnimation()
    }
    
    private func expandTitleLabel(label: TTTAttributedLabel!) {
        feed.isTitleExpanded = true
        bindContentTitle()
        layoutIfNeeded()
        expandedText.onNext(self)
    }
    
    private func updateVideoAutoPlay(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        guard video != nil else { return (isVideo: false, shouldResume: false) }
        
        if isAVideoPlaying {
            _ = playVideo(false)
            inlinePlayer.videoWillTerminate()
            return (isVideo: true, shouldResume: true)
        }
        
        let videoHeight = inlinePlayer.parentView.frame.size.height
        let yOrdinateToVideo = yOrdinate + self.convert(self.bounds, to: inlinePlayer.parentView).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        if !shouldResume {
            self.video?.hasEnded.value = false
            inlinePlayer.videoWillTerminate()
        }
        return (isVideo: true, shouldResume: playVideo(shouldResume))
    }
    
    private func playVideo(_ toPlay: Bool) -> Bool {
        guard inlinePlayer != nil, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
    private func setUpVideo() {
        videoContainView.isHidden = false
        addAspectConstraintForPhotoImageView(multiplier: Constants.DefaultValue.ratio9H16W)
        guard let theVideo = video else {
            inlinePlayer = nil
            return
        }
        if inlinePlayer == nil {
            inlinePlayer = InlineTHEOPlayer(inlineOfView: videoContainView)
            inlinePlayer.theoPlayer.presentationMode = .inline
        }
        inlinePlayer.theoPlayer.muted = false
        inlinePlayer.video = theVideo
        inlinePlayer.feed = self.feed
    }
    
    private func hideVideo() {
        for subView in videoContainView.subviews {
            subView.removeFromSuperview()
        }
        videoContainView.isHidden = true
        inlinePlayer = nil
        addAspectConstraintForPhotoImageView(multiplier: Constants.DefaultValue.ratio16H16W)
    }
    
    private func addAspectConstraintForPhotoImageView(multiplier: CGFloat) {
        if imageAspectConstraint.multiplier == multiplier { return }
        thumbnailImageView.removeConstraint(imageAspectConstraint)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        imageAspectConstraint = NSLayoutConstraint(item: thumbnailImageView,
                                                   attribute: NSLayoutAttribute.height,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: thumbnailImageView,
                                                   attribute: NSLayoutAttribute.width,
                                                   multiplier: multiplier,
                                                   constant: 0)
        thumbnailImageView.addConstraint(imageAspectConstraint)
    }
    
    override func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == Constants.DefaultValue.CustomUrlForMoreText.absoluteString {
            expandTitleLabel(label: label)
        } else if url.absoluteString == Constants.DefaultValue.CustomUrlForPostText.absoluteString {
            titleTapped.onNext(())
        }
    }
}
