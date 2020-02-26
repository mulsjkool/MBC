//
//  ArticleVideoCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import RxSwift

class ArticleVideoCell: ArticleParagraphImageCell {
    
    @IBOutlet weak private var videoContainView: UIView!

    var inlinePlayer: InlineTHEOPlayer!
    var video: Video?
    var videoPlayerTapped: PublishSubject<Video> {
        return inlinePlayer.videoPlayerTapped
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videoContainView.backgroundColor = Colors.black.color()
    }
    
    override func bindData(paragraph: Paragraph, accentColor: UIColor?, numberOfItem: Int,
                  paragraphViewOption: ParagraphViewOptionEnum) {
        super.bindData(paragraph: paragraph, numberOfItem: numberOfItem, paragraphViewOption: paragraphViewOption)
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        if let video = paragraph.media as? Video {
            self.video = video
        }
        bindTaggedPage()
        bindInterest()
        bindContentDescription(paragraph: paragraph, accentColor: accentColor)
        bindVideo()
    }
    
    private func bindVideo() {
        if inlinePlayer != nil && inlinePlayer.theoPlayer != nil, !inlinePlayer.theoPlayer.isDestroyed {
            inlinePlayer.theoPlayer = nil
            inlinePlayer.prepareForReuse()
            inlinePlayer = nil
        }
        guard let video = self.video else { return }
        if inlinePlayer == nil {
            inlinePlayer = InlineTHEOPlayer(inlineOfView: videoContainView)
        }
        inlinePlayer.video = video
        inlinePlayer.muted = false
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
        let yOrdinateToVideo = yOrdinate - self.convert(self.bounds, to: inlinePlayer.parentView).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        if !shouldResume {
            self.video?.hasEnded.value = false
            inlinePlayer.videoWillTerminate()
        }
        return (isVideo: true, shouldResume: playVideo(shouldResume))
    }
}
