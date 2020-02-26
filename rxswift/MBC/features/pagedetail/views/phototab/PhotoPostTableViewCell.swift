//
//  PhotoPostTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import TTTAttributedLabel
import Kingfisher
import MisterFusion
import RxSwift
import UIKit

class PhotoPostTableViewCell: BaseCardTableViewCell {

	@IBOutlet weak private var imgviewPhoto: UIImageView!
    @IBOutlet weak private var imageAspectConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    
    var didTapImageOfDefaultAlbum = PublishSubject<Int>()
    var didTapVideo = PublishSubject<Video>()
    var photo: Media?
    var inlinePlayer: InlineTHEOPlayer!
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgviewPhoto.handleGifReuse()
    }
    
    override func bindData(media: Media, accentColor: UIColor?) {
        super.bindData(media: media, accentColor: accentColor)
        setupRx()
        showTitle()
        setPostPhoto(self.media)
        bindDescription()
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        updateGifAutoPlay(yOrdinate: yOrdinate, viewPortHeight: viewPortHeight)
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    // MARK: PUBLIC
    
    // TO DO: Need to resume video after updating current time
    func seekTo(time: Double) {
        if self.video != nil {
            video?.currentTime.value = time
            video?.hasEnded.value = false
        }
    }
    
    // MARK: Private
    
    // set the video to play / pause. if the video has ended, return false to give the chance to other videos
    private func playVideo(_ toPlay: Bool) -> Bool {
        guard inlinePlayer != nil, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
    private func showTitle() {
        guard let video = self.media as? Video, let title = video.title, !title.isEmpty else {
            self.titleLabel.text = ""
            self.titleLabelTopConstraint.constant = 0
            return
        }
        self.titleLabel.text = title
        titleLabel.isUserInteractionEnabled = true
        self.titleLabelTopConstraint.constant = (self.titleLabel.text!.isEmpty) ? 0
            : Constants.DefaultValue.defaultMarginTitle
        let tapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                if let video = self.video {
                    print("didTapVideo")
                    self.didTapVideo.onNext(video)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateGifAutoPlay(yOrdinate: CGFloat, viewPortHeight: CGFloat) {
        guard let firstImg = photo, firstImg.isAGif else { return }
        let gifHeight = imgviewPhoto.frame.size.height
        let yOrdinateToGif = yOrdinate + imgviewPhoto.convert(imgviewPhoto.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? imgviewPhoto.resumeGifAnimation() : imgviewPhoto.pauseGifAnimation()
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
    
    private func setUpVideo() {
        guard let theVideo = video else { return }
        addAspectConstraintForPhotoImageView(multiplier: Constants.DefaultValue.ratio9H16W)
        imgviewPhoto.backgroundColor = Colors.black.color()
        if inlinePlayer == nil {
            let containerView = UIView()
            contentView.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            contentView.mf.addConstraints(
                containerView.height |==| imgviewPhoto.height,
                containerView.leading |==| imgviewPhoto.leading,
                containerView.trailing |==| imgviewPhoto.trailing,
                containerView.top |==| imgviewPhoto.top
            )
            
            inlinePlayer = InlineTHEOPlayer(inlineOfView: containerView)
        }
        inlinePlayer.video = theVideo
    }
    
    private func addAspectConstraintForPhotoImageView(multiplier: CGFloat) {
        imgviewPhoto.removeConstraint(imageAspectConstraint)
        imgviewPhoto.translatesAutoresizingMaskIntoConstraints = false
        imageAspectConstraint = NSLayoutConstraint(item: imgviewPhoto,
                                                   attribute: NSLayoutAttribute.height,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: imgviewPhoto,
                                                   attribute: NSLayoutAttribute.width,
                                                   multiplier: multiplier,
                                                   constant: 0)
        imgviewPhoto.addConstraint(imageAspectConstraint)
    }
 
    private func setupRx() {
        imgviewPhoto.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer()
        imgviewPhoto.addGestureRecognizer(imageTapGesture)
        
        imageTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapImageOfDefaultAlbum.onNext(self.tag)
            })
            .disposed(by: disposeBag)
    }
    
    private func setPostPhoto(_ media: Media) {
        if self.video != nil {
            self.imgviewPhoto.image = nil
			setUpVideo()
        } else {
            self.imgviewPhoto.setImage(from: media, resolution: .ar16x16)
			addAspectConstraintForPhotoImageView(multiplier: Constants.DefaultValue.ratio16H16W)
            photo = media
            
            if inlinePlayer != nil && inlinePlayer.theoPlayer != nil, !inlinePlayer.theoPlayer.isDestroyed {
				// Remove container view
				inlinePlayer.parentView.removeFromSuperview()
                inlinePlayer.prepareForReuse()
                inlinePlayer = nil
            }
        }
	}
}
