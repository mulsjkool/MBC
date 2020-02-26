//
//  VideoFullscreenLandscapeView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import THEOplayerSDK
import RxSwift

class VideoFullscreenLandscapeView: BaseView {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var playerView: UIView!
    @IBOutlet weak private var mainContentView: UIView!
    @IBOutlet weak private var controlsView: UIView!
    @IBOutlet weak private var muteButton: UIButton!
    @IBOutlet weak private var resolutionButton: UIButton!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var seekbarView: VideoSeekBarView!
    @IBOutlet weak private var collapseScreenButton: UIButton!
    @IBOutlet weak private var tagButton: UIButton!
    @IBOutlet weak private var closeTitleButton: UIButton!
    @IBOutlet weak private var authorView: AvatarFullScreenView!
    @IBOutlet weak private var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleView: VideoTitleFullScreenView!
    @IBOutlet weak private var titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var bitRateView: VideoBitRateView!
    @IBOutlet weak private var bitRateViewHeightConstraint: NSLayoutConstraint!
    let videoloadingNextView = VideoFullscreenLoadingNextView()
    private let defaultBitRateViewHeight: CGFloat = 20
    private lazy var titleViewMaximumHeight: CGFloat = titleView.frame.origin.y - 50
    private var gradientLayer = CAGradientLayer()
    private var shouldShow = true
    private var isShowTitleMode = false
    private var isShowBitRate = true
    private var hideControlsTimer = Timer()
    private var hideControlDuration: Double = Components.instance.configurations.hideVideoControls

    private lazy var baseVC: BaseViewController = { return BaseViewController() }()
    
    let endVideoEvent = PublishSubject<Video>()
    let getNextVideoFromVideo = PublishSubject<Video>()
    let videoOrientStationChange = PublishSubject<PresentationMode>()
    var shouldLoadNextVideo: Bool = false

    static let shared = VideoFullscreenLandscapeView()
    private var videoDuration: Double? {
        guard let theoPlayer = inlinePlayer?.theoPlayer, let duration = theoPlayer.duration,
            !(duration.isNaN || duration.isInfinite) else {
            return nil
        }
        return duration
    }
    
    var inlinePlayer: InlineTHEOPlayer? {
        didSet {
            updateListeners()
            updateButtons()
        }
    }
    
    var video: Video! { didSet { bindData() } }
    var feed: Feed?
    
    func removeHandlers() {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        
        if let handler = eventListeners[PlayerEventTypes.PROGRESS.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.PROGRESS, listener: handler)
        }
        
        if let handler = eventListeners[PlayerEventTypes.TIME_UPDATE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: handler)
        }
        
        if let handler = eventListeners[PlayerEventTypes.SEEKING.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.SEEKING, listener: handler)
        }
        
        if let handler = eventListeners[PlayerEventTypes.ENDED.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.ENDED, listener: handler)
        }
        
        if let handler = eventListeners[PlayerEventTypes.PRESENTATION_MODE_CHANGE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE, listener: handler)
        }
    }
    
    // events
    private var eventListeners = [String: EventListener]()
    
    // MARK: Override
    private override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @IBAction func playButtonTouched(_ sender: Any) {
        guard let inlinePlayer = inlinePlayer else { print("ERROR: THEOplayer is not assigned"); return }
        updatePlayButton(toPause: !inlinePlayer.theoPlayer.paused)
        inlinePlayer.click2replay()
    }
    
    @IBAction func muteButtonTouched(_ sender: Any) {
        guard let inlinePlayer = inlinePlayer else { print("ERROR: THEOplayer is not assigned"); return }
        updateVolumeButton(toMute: !inlinePlayer.theoPlayer.muted)
        inlinePlayer.theoPlayer.muted = !inlinePlayer.theoPlayer.muted
    }
    
    @IBAction func restoreButtonTouched(_ sender: Any) {
        guard let inlinePlayer = inlinePlayer else { print("ERROR: THEOplayer is not assigned"); return }
        inlinePlayer.theoPlayer.evaluateJavaScript("toggleFullscreen();")
    }
    
    // MARK: Public
    
    func playNext(video: Video) {
        self.video = video
        inlinePlayer?.playNext(nextvideo: video)
    }
    
    func seekbarTouchDown(progress: Float) {
        guard let inlinePlayer = inlinePlayer else { print("ERROR: THEOplayer is not assigned"); return }
        inlinePlayer.theoPlayer.evaluateJavaScript("seekbarTouchDown(\(progress));")
    }
    
    func seekbarTouchExit() {
        guard let inlinePlayer = inlinePlayer else { print("ERROR: THEOplayer is not assigned"); return }
        inlinePlayer.theoPlayer.evaluateJavaScript("seekbarTouchExit();")
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.videoFullscreenLandscapeView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
     //   disposeBag = DisposeBag()
        setupUI()
        setupEvents()
    }
    
    private func setupEvents() {
        disposeBag.addDisposables([
            seekbarView.timeSeekChanged.subscribe(onNext: { [weak self] value in
                guard self?.inlinePlayer != nil else { return }
                self?.seekbarTouchDown(progress: value)
                self?.setTimerAutoHideControls()
            }),
            seekbarView.touchExit.subscribe(onNext: { [weak self] _ in
                guard self?.inlinePlayer != nil else { return }
                self?.seekbarTouchExit()
            }),
            likeCommentShareView.shareTapped.subscribe(onNext: { [weak self] data in
                self?.showActivityVC(obj: data)
            })
        ])
    }
    
    private func bindData() {
        showAuthor()
        showInterest()
        showTitle()
        showTagButton()
        showLikeShareComment()
        setTimerAutoHideControls()
        setupDataBitRateView()
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
    
    private func showAuthor() {
        guard let author = video.author else {
            self.authorView.isHidden = true
            return
        }
        self.authorView.isHidden = false
        self.authorView.bindData(author, publishedDate: video.publishedDate, contentType: nil,
                                 subType: video.contentType, isFullScreen: true, shouldUseFollower: false)
    }
    
    private func showInterest() {
        guard let interest = video.interests else {
            self.interestView.isHidden = true
            return
        }
        interestView.bindLabel(label: video.label, isExpanded: video.isInterestExpanded)
        interestView.bindInterests(interests: interest, isExpanded: video.isInterestExpanded)
        interestView.applyColor(accentColor: UIColor.white, textColor: Colors.dark.color())
        self.disposeBag.addDisposables([
            interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                self.interestViewHeightConstraint.constant = viewHeight
            })
        ])
        interestView.reLayoutConstraints()
    }
    
    private func showLikeShareComment() {
        likeCommentShareView.media = nil
        likeCommentShareView.feed = nil
        if let feed = self.feed {
            likeCommentShareView.feed = feed
        } else if let media = self.video {
            likeCommentShareView.media = media
        }
        likeCommentShareView.setTextColorForCountComment(UIColor.white)
        likeCommentShareView.setupImagesForSingleCardCell()
    }
    
    private func showTagButton() {
        tagButton.isHidden = !video.hasTag2Page
    }
    
    private func showTitle() {
        disposeBag.addDisposables([
            titleView.updateTitleHeight.subscribe(onNext: { [unowned self] height in
                self.titleViewHeightConstraint.constant = height
            }),
            titleView.expandTitleView.subscribe(onNext: { [unowned self] height in
                Common.generalAnimate(animation: {
                    self.isShowTitleMode = true
                    self.closeTitleButton.isHidden = false
                    self.shouldShowControls(false)
                    self.titleViewHeightConstraint.constant = height > self.titleViewMaximumHeight ?
                        self.titleViewMaximumHeight : height
                })
            })
        ])
        titleView.bindData(title: video.title, description: video.description)
    }
    
    private func setupUI() {
        if Constants.DefaultValue.shouldRightToLeft {
            controlsView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            muteButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            resolutionButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        mainContentView.backgroundColor = UIColor.clear
        fillOverlayGradient()
        addTapBackgroundEvent()
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func updateListeners() {
        removeHandlers()
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        let progressUpdated = theoPlayer.addEventListener(type: PlayerEventTypes.PROGRESS) { [weak self] event in
            guard let sSelf = self else { return }
            sSelf.updateBuffer(event.buffered)
        }
        eventListeners[PlayerEventTypes.PROGRESS.name] = progressUpdated
        
        // add event to update time
        let timeUpdate = theoPlayer.addEventListener(type: PlayerEventTypes.TIME_UPDATE) { [weak self] event in
            guard let videoDuration = self?.videoDuration else { return }
            let remainingTime = videoDuration - event.currentTime < 0 ? 0 : videoDuration - event.currentTime
            guard remainingTime > 0 else {
                if let video = self?.video {
                    if !video.hasEnded.value {
                        video.hasEnded.value = true
                        if (self?.shouldLoadNextVideo)! {
                            self?.showVideoLoadingNextView()
                            self?.getNextVideoFromVideo.onNext(video)
                        } else {
                            self?.endVideoEvent.onNext(video)
                        }
                    }
                }
                return
            }
            
            guard let theoPlayer = self?.inlinePlayer?.theoPlayer else { return }
            guard let duration = theoPlayer.duration, !theoPlayer.paused else { return }
            self?.updateCurrentTime(currentTime: event.currentTime, duration: duration)
            Constants.Singleton.isAInlineVideoPlaying = true
        }
        eventListeners[PlayerEventTypes.TIME_UPDATE.name] = timeUpdate

        let seekUpdate = theoPlayer.addEventListener(type: PlayerEventTypes.SEEKING) { [weak self] event in
            guard let theoPlayer = self?.inlinePlayer?.theoPlayer,
                let duration = theoPlayer.duration else { return }
            
            self?.updateSeekLabel(toTime: event.currentTime)
            if !theoPlayer.paused { self?.updateCurrentTime(currentTime: event.currentTime, duration: duration) }
        }
        eventListeners[PlayerEventTypes.SEEKING.name] = seekUpdate
        
        let endVideo = theoPlayer.addEventListener(type: PlayerEventTypes.ENDED) { [weak self] _ in
            if let video = self?.video {
                self?.video.hasEnded.value = true
                if (self?.shouldLoadNextVideo)! {
                    self?.showVideoLoadingNextView()
                    self?.getNextVideoFromVideo.onNext(video)
                } else {
                     self?.endVideoEvent.onNext(video)
                }
            }
        }
        eventListeners[PlayerEventTypes.ENDED.name] = endVideo
        
        let modeChanged =
            theoPlayer.addEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE) { [weak self] _ in
                self?.videoOrientStationChange.onNext(theoPlayer.presentationMode)
            }
        eventListeners[PlayerEventTypes.PRESENTATION_MODE_CHANGE.name] = modeChanged
    }
    
    private func showVideoLoadingNextView() {
        if videoloadingNextView.superview == nil {
            videoloadingNextView.frame = CGRect(x: 0, y: 0, width: self.frame.width,
                                                height: self.frame.height)
            containerView.addSubview(videoloadingNextView)
            videoloadingNextView.startUpdateProgess()
            videoloadingNextView.disposeBag.addDisposables([
                videoloadingNextView.progressFinish.subscribe(onNext: { [weak self] _ in
                    self?.hideVideoLoadingView()
                     if let video = self?.video {
                        self?.endVideoEvent.onNext(video)
                    }
                })
            ])
        }
    }
    
    private func hideVideoLoadingView() {
        videoloadingNextView.removeFromSuperview()
        videoloadingNextView.disposeBag = DisposeBag()
    }
    
    private func updateButtons() {
        updatePlayButton()
        updateVolumeButton()
        updateCurrentTime()
    }
    
    private func updatePlayButton(toPause: Bool? = nil) {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        let paused = toPause ?? theoPlayer.paused
        let playImage = paused ? R.image.iconVideoPlay() : R.image.iconVideoPause()
        playButton.setImage(playImage, for: UIControlState.normal)
    }
    
    private func updateVolumeButton(toMute: Bool? = nil) {
        guard let theoPlayer = inlinePlayer?.theoPlayer else { return }
        let muted = toMute ?? theoPlayer.muted
        let buttonImage = muted ? R.image.iconVideoUnmute() : R.image.iconVideoMute()
        muteButton.setImage(buttonImage, for: UIControlState.normal)
    }
    
    private func updateBuffer(_ buffers: [TimeRange]) {
        guard let timeRange = buffers.first, inlinePlayer?.theoPlayer != nil,
            let duration = inlinePlayer?.theoPlayer.duration else { return }
        seekbarView.bufferProgress = Float(timeRange.end / duration)
    }
    
    private func updateCurrentTime(currentTime: Double? = nil, duration: Double? = nil) {
        let currentPosition = currentTime ?? self.video.currentTime.value
        let videoDuration = duration ?? (inlinePlayer?.theoPlayer.duration ?? 0)
        seekbarView.currentTime = currentPosition
		if videoDuration.isFinite { seekbarView.videoDuration = videoDuration }
    }
    
    private func updateSeekLabel(toTime: Double) {
        seekbarView.seekedTime = toTime
    }

    private func fillOverlayGradient() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenHeight,
                                height: Constants.DeviceMetric.screenWidth)
        gradientLayer.colors = Constants.DefaultValue.gradientForVideoFullScreen
        gradientLayer.locations = [0, 0.2, 0.7]
        mainContentView.layer.insertSublayer(gradientLayer, at: 0)
        mainContentView.backgroundColor = UIColor.clear
    }
    
    private func shouldShowControls(_ should: Bool?) {
        shouldShow = should ?? !shouldShow
        if !self.closeTitleButton.isHidden {
            gradientLayer.isHidden = false
            titleView.isHidden = false
            if video.interests != nil { interestView.isHidden = false }
            likeCommentShareView.isHidden = false
            separatorView.isHidden = false
        } else {
            gradientLayer.isHidden = !shouldShow
            titleView.isHidden = !shouldShow
            if video.interests != nil { interestView.isHidden = !shouldShow }
            likeCommentShareView.isHidden = !shouldShow
            separatorView.isHidden = !shouldShow
        }
        collapseScreenButton.isHidden = !shouldShow
        if video.hasTag2Page { tagButton.isHidden = !shouldShow }
        if video.author != nil { authorView.isHidden = !shouldShow }
        playButton.isHidden = !shouldShow
        controlsView.isHidden = !shouldShow
        if isShowBitRate {
            bitRateView.isHidden = true
            isShowBitRate = false
        }
        self.setTimerAutoHideControls()
    }
    
    private func didTapBackground() {
        guard !isShowTitleMode else { return }
        Common.generalAnimate {
            self.shouldShowControls(nil)
        }
    }

    private func addTapBackgroundEvent() {
        let tapGesture = UITapGestureRecognizer()
        playerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .asDriver()
            .drive(onNext: { [unowned self] _ in
                self.didTapBackground()
            })
            .disposed(by: disposeBag)
    }
    
    private func setTimerAutoHideControls() {
        hideControlsTimer.invalidate()
        hideControlsTimer = Timer.scheduledTimer(timeInterval: hideControlDuration, target: self,
                                                     selector: #selector(autoHideControls),
                                                     userInfo: nil, repeats: false)
    }
    
    @objc
    private func autoHideControls() {
        shouldShowControls(false)
        shouldBitRateView(false)
    }
    
    private func shouldBitRateView(_ should: Bool?) {
        isShowBitRate = should ?? !isShowBitRate
        bitRateView.isHidden = !isShowBitRate
        bitRateViewHeightConstraint.constant = defaultBitRateViewHeight
    }
    
    private func showActivityVC(obj: Likable) {
        self.baseVC.getURLFromObjAndShare(obj: obj)
        
        disposeBag.addDisposables([
            self.baseVC.closeActivityVC.subscribe(onNext: { [weak self] _ in
                self?.baseVC.view.removeFromSuperview()
            })
        ])
        
        self.superview?.addSubview(self.baseVC.view)
    }
    
    // MARK: IBAction
    @IBAction func closeButtonTouch() {
        inlinePlayer?.videoWillTerminate()
        isShowTitleMode = false
        shouldShowControls(true)
        closeTitleButton.isHidden = true
        titleView.showTitle()
    }
    
    @IBAction func resolutionBUttonTouch() {
        shouldBitRateView(nil)
        self.setTimerAutoHideControls()
    }

}
