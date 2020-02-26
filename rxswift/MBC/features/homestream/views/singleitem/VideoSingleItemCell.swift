//
//  VideoSingleItemCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 5/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxSwift
import VisualEffectView

class VideoSingleItemCell: HomeStreamSingleItemCell {
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var muteButton: UIButton!
    @IBOutlet private weak var videoDurationLabel: UILabel!
    var inlinePlayer: InlineTHEOPlayer!
//    private var blurEffectView: UIView?
    private var blurViewTag: Int = 100

    // MARK: Overrive
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func bindData(feed: Feed, accentColor: UIColor?) {
        super.bindData(feed: feed, accentColor: accentColor)
        setUpdateEvent()
        bindVideo()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addBlurView()
        }
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
    //    updateGifAutoPlay(yOrdinate: yOrdinate, viewPortHeight: viewPortHeight)
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    // MARK: Private
    private func bindVideo() {
        if inlinePlayer == nil { inlinePlayer = InlineTHEOPlayer(inlineOfView: videoView) }
        inlinePlayer.video = video
        inlinePlayer.feed = self.feed
        inlinePlayer.isAudioHidden = true
        inlinePlayer.isRemainingTimeHidden = true
        inlinePlayer.disposeBag = DisposeBag()
        inlinePlayer.disposeBag.addDisposables([
            inlinePlayer.remainingTimeEvent.subscribe(onNext: { [weak self] remaining in
                self?.videoDurationLabel.text = remaining
            }),
            inlinePlayer.videoPlayerTapped.subscribe(onNext: { [weak self] video in
                self?.videoPlayerTapped.onNext(video)
            })

        ])
    
    }
    
    private func setUpdateEvent() {
        let videoDurationLabelTapGesture = UITapGestureRecognizer()
        videoDurationLabel.addGestureRecognizer(videoDurationLabelTapGesture)
        videoDurationLabelTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [weak self] _ in
                self?.buttonMuteTouch()
            })
            .disposed(by: disposeBag)
    }
    private func updateVideoAutoPlay(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        guard video != nil else { return (isVideo: false, shouldResume: false) }
        
        if isAVideoPlaying {
            _ = playVideo(false)
            inlinePlayer?.videoWillTerminate()
            return (isVideo: true, shouldResume: true)
        }
        
        let videoHeight = videoView.frame.size.height
        let yOrdinateToVideo = yOrdinate + videoView.convert(videoView.bounds, to: self).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        if !shouldResume {
            self.video?.hasEnded.value = false
            inlinePlayer?.videoWillTerminate()
        }
        return (isVideo: true, shouldResume: playVideo(shouldResume))
    }
    
    private func playVideo(_ toPlay: Bool) -> Bool {
        guard let inlinePlayer = self.inlinePlayer, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
    private func addBlurView() {
        let thumbNailImageView = getThumbnailImageView()
        var blurEffectView = thumbNailImageView.viewWithTag(blurViewTag) as? VisualEffectView
        if blurEffectView == nil {
            
          //  let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let bounds = thumbNailImageView.bounds
            blurEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            blurEffectView!.tag = blurViewTag
            blurEffectView!.blurRadius = 12
            thumbNailImageView.addSubview(blurEffectView!)
           
        }
    }
    
    // MARK: IBAction
    @IBAction func buttonMuteTouch() {
        guard let video = self.video else { return }
        videoPlayerTapped.onNext(video)
    }
    
}
