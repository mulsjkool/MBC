//
//  VideoPlaylistTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import THEOplayerSDK
import MisterFusion

class VideoPlaylistTableViewCell: BaseCardTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var playerView: UIView!
    @IBOutlet weak private var backgroundPlayerView: UIView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var controlsView: UIView!
    @IBOutlet weak private var muteButton: UIButton!
    @IBOutlet weak private var tagButton: UIButton!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var collapseScreenButton: UIButton!
    @IBOutlet weak private var resolutionButton: UIButton!
    @IBOutlet weak private var seekbarView: VideoSeekBarView!
    @IBOutlet weak private var bitRateView: VideoBitRateView!
    @IBOutlet weak private var bitRateViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var nextVideoCountDownView: UIView!
    @IBOutlet weak private var taggedPagesView: TaggedPagesView!
    @IBOutlet weak private var taggedContainerView: UIView!
    @IBOutlet weak private var buttonTaggedPages: UIButton!
    @IBOutlet weak private var taggedPagesViewHeightConstraint: NSLayoutConstraint!
    
    private var gradientLayer = CAGradientLayer()
    let endVideoEvent = PublishSubject<Video>()
    let showNextVideoCountDown = PublishSubject<UIView>()
    let hideNextVideoCountDown = PublishSubject<Void>()
    let didTapTaggedPage = PublishSubject<MenuPage>()
    var inlinePlayer: InlineTHEOPlayer!
    private var hideControlsTimer = Timer()
    private var hideControlDuration: Double = Components.instance.configurations.hideVideoControls
    private var shouldShow = true
    private var isShowBitRate = true
    private var gradientViewTag: Int = 100
    private let defaultBitRateViewHeight: CGFloat = 20
    private let authorNameColor = #colorLiteral(red: 0.8117647059, green: 0.8470588235, blue: 0.862745098, alpha: 1)
    private let defaulTextColor = #colorLiteral(red: 0.6666666667, green: 0.6980392157, blue: 0.7137254902, alpha: 1)
    private var isThelastVideoInPlayList: Bool = false
    
    private let taggedViewHeightDefault: CGFloat = 0
    private let taggedViewHeightWhenShow: CGFloat = (UIScreen.main.bounds.width / 16 * 9)
    private let taggedPagesTitleColor = Colors.unselectedTabbarItem.color()
    private let taggedContainerViewColor = Colors.dark.color()
    var didTapButtonTaggedPages = PublishSubject<Media>()
    
    // events
    private var eventListeners = [String: EventListener]()
    var autoNext = false
    
    // MARK: Override
    override func prepareForReuse() {
        super.prepareForReuse()
        taggedPagesView.resetPages()
        if inlinePlayer != nil && inlinePlayer.theoPlayer != nil, !inlinePlayer.theoPlayer.isDestroyed {
            inlinePlayer.prepareForReuse()
            // Remove container view
            inlinePlayer = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fillOverlayGradient()
        }
        
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    // MARK: IBAction
    
    @IBAction func muteButtonTouched(_ sender: Any) {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { print("ERROR: THEOplayer is not assigned"); return }
        updateVolumeButton(toMute: !theoPlayer.muted)
        inlinePlayer?.theoPlayer.muted = !theoPlayer.muted
    }
    
    @IBAction func resolutionButtonTouch() {
        shouldBitRateView(nil)
        self.setTimerAutoHideControls()
    }
    
    @IBAction func playButtonTouched(_ sender: Any) {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { print("ERROR: THEOplayer is not assigned"); return }
        updatePlayButton(toPause: !theoPlayer.paused)
        inlinePlayer.click2replay()
    }
    
    @IBAction func collapseScreenButtonTouched(_ sender: Any) {
        guard let theoPlayer = inlinePlayer.theoPlayer else { print("ERROR: THEOplayer is not assigned"); return }
        theoPlayer.evaluateJavaScript("toggleFullscreen();")
    }
    
    // MARK: Public
    func bindData(videoItem: Video, accentColor: UIColor?, isLastVideoInPlaylist: Bool = false) {
        super.bindData(media: videoItem, accentColor: Colors.unselectedTabbarItem.color())
        self.isThelastVideoInPlayList = isLastVideoInPlaylist
        setUpVideoPlay()
        updatePlayButton()
        setupUI()
        shouldShowTagbutton()
        showTitle()
        bindDescription()
        showAuthor()
        setLikeComment()
        setupEvents()
        setupDataBitRateView()
        setTimerAutoHideControls()
        applyColor()
        bindTaggedPage()
    }
	
	func bindVideoLiveStreaming(video: Video) {
		bindData(media: video, accentColor: Colors.unselectedTabbarItem.color())
	}
    
    func updatePlayButton(toPause: Bool? = nil) {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        let paused = toPause ?? theoPlayer.paused
        let playImage = paused ? R.image.iconVideoPlay() : R.image.iconVideoPause()
        playButton.setImage(playImage, for: UIControlState.normal)
    }
    
    // set the video to play / pause. if the video has ended, return false to give the chance to other videos
	@discardableResult
	func playVideo(_ toPlay: Bool) -> Bool {
        guard inlinePlayer != nil, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: autoNext)
    }
    
    // MARK: Private
    private func shouldShowTagbutton() {
         guard let theVideo = video, theVideo.hasTag2Page else {
            self.tagButton.isHidden = true
            return
        }
        self.tagButton.isHidden = false
    }
    
    private func applyColor() {
        getAuthorView().setTextColor(authorNameColor: authorNameColor, contentTypeColor: defaulTextColor)
        getInterestView().applyColor(accentColor: authorNameColor, textColor: #colorLiteral(red: 0.1490196078, green: 0.1960784314, blue: 0.2196078431, alpha: 1), numberColor: #colorLiteral(red: 0.09411764706, green: 0.1215686275, blue: 0.137254902, alpha: 1))
        getLikeCommentShareView().setTextColorForCountComment(defaulTextColor)
    }
    
    private func didTapBackground() {
        Common.generalAnimate {
            self.shouldShowControls(nil)
        }
    }
    
    private func addTapBackgroundEvent() {
        let tapGesture = UITapGestureRecognizer()
        backgroundPlayerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.didTapBackground()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDataBitRateView() {
        let resolutionDemo = ["720p", "576p", "468p", "360p", "288p", "252p"] // DEMO data
        bitRateView.bindData(resolutions: resolutionDemo)
        bitRateView.disposeBag.addDisposables([
            bitRateView.biteRateItemSelected.subscribe(onNext: { [weak self] text in
                print("text: \(String(describing: self)) \(text)")
            })
        ])
    }
    
    private func updateListeners() {
        /// remove previous listers (if any)
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        if let handler = eventListeners[PlayerEventTypes.PROGRESS.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.PROGRESS, listener: handler)
        }
        
        let progressUpdated = theoPlayer.addEventListener(type: PlayerEventTypes.PROGRESS) { [weak self] event in
            self?.updateBuffer(event.buffered)
        }
        eventListeners[PlayerEventTypes.PROGRESS.name] = progressUpdated
        
        if let handler = eventListeners[PlayerEventTypes.TIME_UPDATE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: handler)
        }
        // add event to update time
        let timeUpdate = theoPlayer.addEventListener(type: PlayerEventTypes.TIME_UPDATE) { [weak self] event in
            guard let duration = theoPlayer.duration, !(duration.isNaN || duration.isInfinite),
                !theoPlayer.paused else { return }
            
            let playedTime = event.currentTime > duration ? duration : event.currentTime
            self?.updateCurrentTime(currentTime: playedTime, duration: duration)
        }
        eventListeners[PlayerEventTypes.TIME_UPDATE.name] = timeUpdate
        
        if let handler = eventListeners[PlayerEventTypes.SEEKING.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.SEEKING, listener: handler)
        }
        
        let seekUpdate = theoPlayer.addEventListener(type: PlayerEventTypes.SEEKING) { [weak self] event in
            guard let sSelf = self, let duration = theoPlayer.duration else { return }
            sSelf.updateSeekLabel(toTime: event.currentTime)
            if !theoPlayer.paused { sSelf.updateCurrentTime(currentTime: event.currentTime, duration: duration) }
        }
        eventListeners[PlayerEventTypes.SEEKING.name] = seekUpdate
        
        let endVideo = theoPlayer.addEventListener(type: PlayerEventTypes.ENDED) { [weak self] _ in
            if let video = self?.video {
                self?.updatePlayButton(toPause: true)
                self?.endVideoEvent.onNext((video))
                self?.hideCountDownView()
            }
        }
        eventListeners[PlayerEventTypes.ENDED.name] = endVideo
    }
    
    private func updateSeekLabel(toTime: Double) {
        seekbarView.seekedTime = toTime
    }
    
    private func updateCurrentTime(currentTime: Double? = nil, duration: Double? = nil) {
        guard let theVideo = video else { return }
        let currentPosition = currentTime ?? theVideo.currentTime.value
        let videoDuration = duration ?? (inlinePlayer?.theoPlayer.duration ?? 0)
        seekbarView.currentTime = currentPosition
		if videoDuration.isFinite { seekbarView.videoDuration = videoDuration }
        if !isThelastVideoInPlayList {
            if let currentTime = currentTime, let duration = duration, duration.isFinite {
                let letfTime = Int(duration - currentTime)
                if letfTime == Constants.DefaultValue.videoNextVideoCountDown {
                    showCountDownView()
                }
            }
        }
    }
    
    private func showCountDownView() {
        showNextVideoCountDown.onNext(nextVideoCountDownView)
    }
    
    private func hideCountDownView() {
        hideNextVideoCountDown.onNext(())
    }
    
    private func updateBuffer(_ buffers: [TimeRange]) {
        guard let timeRange = buffers.first, let duration = inlinePlayer?.theoPlayer.duration else { return }
        seekbarView.bufferProgress = Float(timeRange.end / duration)
    }
    
    private func setupEvents() {
        disposeBag.addDisposables([
            seekbarView.timeSeekChanged.subscribe(onNext: { [weak self] value in
                guard let sSelf = self, sSelf.inlinePlayer?.theoPlayer != nil else { return }
                sSelf.seekbarTouchDown(progress: value)
                sSelf.setTimerAutoHideControls()
                sSelf.hideCountDownView()
            }),
            seekbarView.touchExit.subscribe(onNext: { [weak self] _ in
                guard let sSelf = self, sSelf.inlinePlayer?.theoPlayer != nil else { return }
                sSelf.seekbarTouchExit()
            })
        ])
    }
    
    private func setTimerAutoHideControls() {
        hideControlsTimer.invalidate()
        hideControlsTimer = Timer.scheduledTimer(timeInterval: hideControlDuration, target: self,
                                                 selector: #selector(autoHideControls),
                                                 userInfo: nil, repeats: false)
    }
    
    private func shouldShowControls(_ should: Bool?) {
        shouldShow = should ?? !shouldShow
        gradientLayer.isHidden = !shouldShow
        collapseScreenButton.isHidden = !shouldShow
        if let theVideo = video, theVideo.hasTag2Page { tagButton.isHidden = !shouldShow } else {
            tagButton.isHidden = true
            if let taggedPages = video?.taggedPages {
                taggedPagesView.bindData(tagedPages: taggedPages)
            }
        }
        playButton.isHidden = !shouldShow
        controlsView.isHidden = !shouldShow
        if isShowBitRate {
            bitRateView.isHidden = true
            isShowBitRate = false
        }
        self.setTimerAutoHideControls()
    }
    
    @objc
    private func autoHideControls() {
        shouldShowControls(false)
        shouldBitRateView(false)
    }
    
    func updateVolumeButton(toMute: Bool? = nil) {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        let muted = toMute ?? theoPlayer.muted
        let buttonImage = muted ? R.image.iconVideoUnmute() : R.image.iconVideoMute()
        muteButton.setImage(buttonImage, for: UIControlState.normal)
    }
    
    private func seekbarTouchExit() {
        guard inlinePlayer?.theoPlayer != nil else { print("ERROR: THEOplayer is not assigned"); return }
        inlinePlayer?.theoPlayer.evaluateJavaScript("seekbarTouchExit();")
    }
    
    private func seekbarTouchDown(progress: Float) {
        guard inlinePlayer?.theoPlayer != nil else { print("ERROR: THEOplayer is not assigned"); return }
        inlinePlayer?.theoPlayer.evaluateJavaScript("seekbarTouchDown(\(progress));")
    }
    
	func setupUI() {
        if Constants.DefaultValue.shouldRightToLeft {
            controlsView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            muteButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
       // fillOverlayGradient()
        addTapBackgroundEvent()
    }
    
    private func fillOverlayGradient() {
        var gradientView = backgroundPlayerView.viewWithTag(gradientViewTag)
        if gradientView == nil {
            gradientView = UIView()
            gradientView!.tag = gradientViewTag
            gradientView?.translatesAutoresizingMaskIntoConstraints = false
            backgroundPlayerView.insertSubview(gradientView!, at: 0)
            backgroundPlayerView.mf.addConstraints([
                gradientView!.top |==| backgroundPlayerView.top,
                gradientView!.leading |==| backgroundPlayerView.leading,
                gradientView!.trailing |==| backgroundPlayerView.trailing,
                gradientView!.bottom |==| backgroundPlayerView.bottom
            ])
            
        } else { gradientLayer.removeFromSuperlayer() }
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth,
                                     height: backgroundPlayerView.frame.size.height)
        gradientLayer.colors = Constants.DefaultValue.gradientForVideoFullScreen
        gradientLayer.locations = [0, 0.2, 0.7]
        gradientView!.backgroundColor = UIColor.clear
        gradientView!.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func showAuthor() {
        guard let video = self.video, let author = video.author else {
            getAuthorView().isHidden = true
            return
        }
        getAuthorView().isHidden = false
        getAuthorView().bindData(author, publishedDate: video.publishedDate, contentType: nil,
                                 subType: FeedSubType.video.rawValue, isFullScreen: false, shouldUseFollower: false)
    }
    
    func shouldDimContent(_ shouldDim: Bool) {
        var alpha: CGFloat = 0
        if shouldDim {
            hideCountDownView()
            alpha = 0.3
        } else {
            alpha = 1.0
        }
        Common.generalAnimate(duration: 0.45) {
            self.containerView.alpha = alpha
        }
    }
    
    private func updateVideoAutoPlay(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        guard video != nil else { return (isVideo: false, shouldResume: false) }
        if isAVideoPlaying {
            _ = playVideo(false)
            shouldDimContent(true)
            inlinePlayer.videoWillTerminate()
            return (isVideo: true, shouldResume: true)
        }
        let videoHeight = inlinePlayer.parentView.frame.size.height
        let yOrdinateToVideo = yOrdinate + self.convert(self.bounds, to: inlinePlayer.parentView).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        shouldDimContent(!shouldResume)
        if !shouldResume {
            self.video?.hasEnded.value = false
            inlinePlayer.videoWillTerminate()
        }
        updatePlayButton(toPause: !shouldResume)
        return (isVideo: true, shouldResume: playVideo(shouldResume))
    }
    
    @objc
	func setUpVideoPlay() {
        playerView.backgroundColor = Colors.black.color()
        guard let theVideo = video else { return }
        if inlinePlayer == nil {
            inlinePlayer = InlineTHEOPlayer(inlineOfView: playerView)
            inlinePlayer.theoPlayer.presentationMode = .inline
            inlinePlayer.setPortrailFullscreen()
            inlinePlayer.disposeBag.addDisposables([
                inlinePlayer.endVideoEvent.subscribe(onNext: { [weak self] video in
                    self?.endVideoEvent.onNext((video))
                })
            ])
        }
        inlinePlayer.video = theVideo
        inlinePlayer.theoPlayer.muted = false
         _ = playVideo(true)
        updateListeners()
    }
    
    private func shouldBitRateView(_ should: Bool?) {
        isShowBitRate = should ?? !isShowBitRate
        bitRateView.isHidden = !isShowBitRate
        bitRateViewHeightConstraint.constant = defaultBitRateViewHeight
    }
    
    private func showTitle() {
        guard let video = media as? Video, let title = video.title else {
            titleLabel.text = ""
            return
        }
        titleLabel.text = title
    }
    
    func bindTaggedPage() {
        showTaggedPage()
    }
    
    private func showTaggedPage() {
        guard let image = media, image.hasTag2Page else {
            taggedPagesViewHeightConstraint.constant = 0
            return
        }
        guard let taggedPages = image.taggedPages, image.isTaggedPageExpanded else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
            return
        }
        taggedPagesView.bindData(tagedPages: taggedPages)
        taggedPagesView.setColorForTitle(color: taggedPagesTitleColor)
        
        taggedPagesView.disposeBag.addDisposables([
            taggedPagesView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.didTapTaggedPage.onNext(menuPage)
            })
        ])
        shouldExpandTaggedPage(image.isTaggedPageExpanded)
    }
    
    @IBAction func buttonTaggedTouch() {
        guard let video = media else { return }
        if video.isGettingTaggedPages {
            if taggedPagesViewHeightConstraint.constant == taggedViewHeightWhenShow {
                shouldExpandTaggedPage(false)
            } else {
                shouldExpandTaggedPage(true)
            }
        } else {
            video.isGettingTaggedPages = true
            video.isTaggedPageExpanded = true
            didTapButtonTaggedPages.onNext(video)
        }
    }
    
    private func shouldExpandTaggedPage(_ should: Bool) {
        if should {
            
            taggedPagesViewHeightConstraint.constant = taggedViewHeightWhenShow
            if let taggedPages = media.taggedPages {
                taggedPagesView.bindData(tagedPages: taggedPages)
            }
            taggedContainerView.backgroundColor = taggedContainerViewColor
//            buttonTaggedPages.setImage(R.image.iconInfoSolid(), for: .normal)
            taggedPagesView.isHidden = false
            media?.isTaggedPageExpanded = true
        } else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
//            buttonTaggedPages.setImage(R.image.iconHomestreamTagOutline(), for: .normal)
            taggedContainerView.backgroundColor = UIColor.clear
            taggedPagesView.isHidden = true
            media?.isTaggedPageExpanded = false
        }
    }
}
