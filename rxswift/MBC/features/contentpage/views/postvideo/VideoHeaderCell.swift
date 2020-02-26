//
//  VideoHeaderCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class VideoHeaderCell: BaseCardTableViewCell {
    
    @IBOutlet weak private var videoContainView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!

    var post: Post!
    var inlinePlayer: InlineTHEOPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoContainView.backgroundColor = Colors.black.color()
    }
    
	func bindData(post: Post, accentColor: UIColor, videoAdsType: VideoAdsType = .unknown) {
        super.bindData(feed: post, accentColor: accentColor)
        self.post = post
        if let video = self.video {
            self.post.title = video.title
            self.post.description = video.description
        }
		bindVideo(adsType: videoAdsType)
        bindTitle()
        bindDescription()
    }
    
    private func bindVideo(adsType videoAdsType: VideoAdsType = .unknown) {
        guard let video = self.video else { return }
        if inlinePlayer == nil {
            inlinePlayer = InlineTHEOPlayer(inlineOfView: videoContainView, adsType: videoAdsType)
        }
        inlinePlayer.video = video
        inlinePlayer.feed = self.post
        inlinePlayer.muted = false
        inlinePlayer.videoPlayerTapped.subscribe({ [unowned self] _ in
            if self.inlinePlayer.video.hasEnded.value {
                self.inlinePlayer.video.currentTime.value = 0
                self.inlinePlayer.video.hasEnded.value = false
            }
        }).disposed(by: inlinePlayer.disposeBag)
        _ = playVideo(true)
    }
    
    private func playVideo(_ toPlay: Bool) -> Bool {
        guard inlinePlayer != nil, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    private func updateVideoAutoPlay(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        guard self.video != nil else { return (isVideo: false, shouldResume: false) }
        
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
    
    private func bindTitle() {
        titleLabel.text = post.title ?? ""
        titleLabelTopConstraint.constant = (titleLabel.text?.isEmpty)! ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
    }
    
    internal override func bindDescription() {
        if let video = self.video {
            descriptionLabel.text = video.description ?? ""
        } else {
            descriptionLabel.from(html: post.description ?? "")
        }
        descriptionLabel.text = descriptionLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionLabelTopConstraint = getDescriptionLabelTopConstraint()
        descriptionLabelTopConstraint.constant = (descriptionLabel.text?.isEmpty)! ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
    }
}
