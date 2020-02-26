//
//  InlineTHEOPlayer.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import MisterFusion
import THEOplayerSDK
import RxSwift
import RxCocoa

enum VideoAdsType {
	case unknown, preRoll, midRoll
}

class InlineTHEOPlayer: NSObject {
    var disposeBag = DisposeBag()
    var theoPlayer: THEOplayer!
    let fullscreenView = VideoFullscreenLandscapeView.shared
    var shouldLoadNextVideo: Bool = false
    let videoPlayerTapped = PublishSubject<Video>()
	let willShowAds = PublishSubject<Void>()
	let willEndAds = PublishSubject<Void>()
    let audioButtonWidth = CGFloat(22)
    private var isFullscreenLandscape: Bool = false
    
    var video: Video! {
        didSet {
            if !Constants.Singleton.isiPad && Constants.Singleton.isLandscape && !isFullscreenLandscape { return }
            guard theoPlayer != nil, video != nil else { return }
            resetPlayingTimeCounter()
            updateSource()
            updateListeners()
            updatePlayback()
        }
    }
    
    var feed: Feed?

    func setVideoForFullscreenLandscape(video: Video) {
        isFullscreenLandscape = true
        self.video = video
        isFullscreenLandscape = false
        
    }
    
    private var unmuteWidthConstraint: NSLayoutConstraint!
    var muted: Bool = true {
        didSet {
            guard theoPlayer != nil else { return }
            theoPlayer.muted = muted
            
            //// hide/show audio icon
            guard unmuteImage != nil, parentView != nil, unmuteWidthConstraint != nil else { return }
            parentView.removeConstraint(unmuteWidthConstraint)
            unmuteWidthConstraint = parentView.addLayoutConstraint(unmuteImage.width |==|
                (muted ? audioButtonWidth : 0))
        }
    }
	
	var videoAdsType: VideoAdsType = .unknown
    var parentView: UIView!
    private var thumbContainerView: UIView!
    private var unmuteImage: UIImageView!
    private var bigPlayImage: UIImageView!
    private var remainingTimeLabel: UILabel!

    private var playMode: VideoPlayMode = .autoplay
    private var playingTime: Double = 0.0
    private var dateDispatched: Date? //The date and time on which the event has been dispatched
	private var isShowAds: Bool = false
    
    var isAudioHidden: Bool {
        didSet {
            
            guard unmuteImage != nil, parentView != nil, unmuteWidthConstraint != nil else { return }
            unmuteImage.isHidden = isAudioHidden
            parentView.removeConstraint(unmuteWidthConstraint)
            unmuteWidthConstraint = parentView.addLayoutConstraint(unmuteImage.width |==|
                (isAudioHidden ? 0 : audioButtonWidth))
        }
    }
    
    var isRemainingTimeHidden: Bool {
        didSet {
            remainingTimeLabel.isHidden = isRemainingTimeHidden
        }
    }
    
    // events
    private var eventListeners = [String: EventListener]()
    let endVideoEvent = PublishSubject<Video>()
    let remainingTimeEvent = PublishSubject<String>()

    deinit {
        defaultNotification.removeObserver(self, name: Keys.Notification.videoWillTerminate, object: nil)
    }
    
	init(inlineOfView: UIView, adsType videoAdsType: VideoAdsType = .unknown) {
        isAudioHidden = false
        isRemainingTimeHidden = false
        
        super.init()
        
        parentView = inlineOfView
		self.videoAdsType = videoAdsType
        
        setupPlayer()
        setupAdditionalViews()

        defaultNotification.addObserver(self, selector: #selector(InlineTHEOPlayer.videoWillTerminate(_:)),
                                        name: Keys.Notification.videoWillTerminate, object: nil)
    }

    @objc
    func videoWillTerminate(_ sender: Notification? = nil) {
        if !theoPlayer.paused {
            theoPlayer.pause()

            let vodTerminate = VideoVodTerminate(mediaId: video.id,
                                                 mediaTitle: video.title ?? "",
                                                 muted: theoPlayer.muted,
                                                 mediaDuration: videoDuration ?? 0,
                                                 playMode: playMode,
                                                 mediaPosition: video.currentTime.value,
                                                 screenMode: screenMode,
                                                 playingTime: playingTime)
            Components.analyticsService.logEvent(trackingObject: AnalyticsVideo(vodTerminate: vodTerminate))
        }
    }
    
    func setPortrailFullscreen() {
        unmuteImage.isHidden = true
        remainingTimeLabel.isHidden = true
        bigPlayImage.isHidden = true
    }
    
    func prepareForReuse() {
        removeHandlers()
		removeAdsListen()
        
        if let theoWebview = parentView.subviews.first(where: { "\(type(of: $0))" == "WKWebView" }) {
            theoWebview.removeFromSuperview()
        }
        theoPlayer = nil
        bigPlayImage.removeFromSuperview()
        bigPlayImage = nil
        remainingTimeLabel.removeFromSuperview()
        remainingTimeLabel = nil
        unmuteImage.removeFromSuperview()
        unmuteImage = nil
        removeThumbnail()
        thumbContainerView = nil
        disposeBag = DisposeBag()
    }

    func playNext(nextvideo: Video) {
        playMode = .autonextvideo
        video = nextvideo
        resumePlaying(toResume: true, autoNext: true)
    }

    func click2replay() {
        playMode = .click2play

        if self.video.hasEnded.value {
            self.video.currentTime.value = 0
            self.video.hasEnded.value = false
            _ = resumePlaying(toResume: true, autoNext: false)
        } else {
            _ = resumePlaying(toResume: theoPlayer.paused, autoNext: false)
        }
    }
    
    @discardableResult
    func resumePlaying(toResume: Bool, autoNext: Bool) -> Bool {
        guard theoPlayer != nil && !theoPlayer.isDestroyed && !video.hasEnded.value else { return false }

        playMode = autoNext ? .autonextvideo : .autoplay
        
        // issue: while scrolling, player doesn't fire ENDED play event
        // at first load, video has not played, but paused = false. confused!!!
//        if toResume && theoPlayer.paused { theoPlayer.play() }
//        else if !toResume && !theoPlayer.paused { theoPlayer.pause() }
        toResume ? theoPlayer.play() : theoPlayer.pause()
        Constants.Singleton.playingTHEOplayer = theoPlayer
        if toResume { setVideoResumed() }
        updateVideoThumbnailOnResume(toResume: toResume)
        return toResume
    }
    
    func setVideoFullscreen() {
        fullscreenView.video = video
        fullscreenView.feed = feed
        fullscreenView.inlinePlayer = self
    }
    
    // MARK: Private
    private func updateVideoThumbnailOnResume(toResume: Bool) {
        guard thumbContainerView != nil, bigPlayImage != nil else { return }
        let thumbnailIsShowing = parentView.viewWithTag(Constants.ViewTag.videoThumbImg) != nil
        if toResume && thumbnailIsShowing { removeThumbnail() }
        if !toResume && !thumbnailIsShowing { addThumbnail() }
    }

    private func resetPlayingTimeCounter() {
        playingTime = 0.0
        dateDispatched = nil
    }

    private func updatePlayback() {
        video.hasEnded.value ? setVideoEnded() : setCurrentTime()
    }
    
    private func updateSource() {
        theoPlayer.stop()
        guard !video.originalLink.isEmpty else {
            theoPlayer.source = nil
            return }
		var ads: GoogleImaAdDescription? = nil
		if let adsUrl = video.adsUrl, let duration = video.duration, Double(duration) - video.currentTime.value
										>= Components.instance.configurations.adsTimeOffset, videoAdsType != .unknown {
			print("InlineTHEOPlayer -- HAVE ADS \(adsUrl)")
			ads = GoogleImaAdDescription(src: adsUrl)
			let timeOffset = videoAdsType != .midRoll ? 0 : video.currentTime.value +
															Components.instance.configurations.adsTimeOffset
			ads?.timeOffset = String(format: "%f", timeOffset)
			registerAdsListen()
		}
		let sourceDesc = SourceDescription(source: TypedSource(src: video.originalLink,
															   type: Constants.DefaultValue.TheoVideoSourceType),
										   ads: ads != nil ? [ads!] : nil,
										   poster: nil)
        theoPlayer.source = sourceDesc
		
        createThumbnailImage()
    }

    private var videoDuration: Double? {
        guard let duration = theoPlayer.duration, !(duration.isNaN || duration.isInfinite) else {
            return nil
        }
        return duration
    }

    private var screenMode: VideoScreenMode {
        return theoPlayer.presentationMode == .fullscreen ? .expanded : .instream
    }

    private func updateListeners() {
        removeHandlers()
        
        // add event to update time
        let timeUpdate = theoPlayer.addEventListener(type: PlayerEventTypes.TIME_UPDATE) { [weak self] event in
            guard let duration = self?.videoDuration else { return }
            let remainingTime = duration - event.currentTime < 0 ? 0 : duration - event.currentTime
            guard remainingTime >= 0 else { return }

            if let lastDateDispatched = self?.dateDispatched {
                self?.playingTime += (event.date.timeIntervalSince1970 - lastDateDispatched.timeIntervalSince1970)
            }

            self?.dateDispatched = event.date
            
            self?.video.currentTime.value = event.currentTime // to store last playing position
            self?.setRemainingTime(withDuration: remainingTime)
            
            Constants.Singleton.isAInlineVideoPlaying = true
            self?.theoPlayer.fullscreenOrientationCoupling = !Constants.Singleton.isiPad

            self?.trackVideo()
        }
        eventListeners[PlayerEventTypes.TIME_UPDATE.name] = timeUpdate
        
        let playingHandler = theoPlayer.addEventListener(type: PlayerEventTypes.PLAY, listener: { [weak self] _ in
            self?.bigPlayImage.fadeOut()
        })
        eventListeners[PlayerEventTypes.PLAY.name] = playingHandler
        
        let pausedHandler = theoPlayer.addEventListener(type: PlayerEventTypes.PAUSE, listener: { [weak self] _ in
            self?.bigPlayImage.fadeIn()
            self?.dateDispatched = nil
        })
        eventListeners[PlayerEventTypes.PAUSE.name] = pausedHandler
        
        let endedHandler = theoPlayer.addEventListener(type: PlayerEventTypes.ENDED, listener: { [weak self] _ in
            self?.video.hasEnded.value = true
            Constants.Singleton.isAInlineVideoPlaying = false
            if self?.theoPlayer.presentationMode == .inline { self?.theoPlayer.fullscreenOrientationCoupling = false }
            self?.setVideoEndedAnimation()
            if let video = self?.video {
                self?.endVideoEvent.onNext(video)
            }
        })
        eventListeners[PlayerEventTypes.ENDED.name] = endedHandler
        
        let modeChanged =
            theoPlayer.addEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE) { [weak self] _ in
                guard let presentationMode = self?.theoPlayer?.presentationMode else { return }
                self?.updateVideoFullscreenView(mode: presentationMode)

                self?.trackExpandedPlayStart(presentationMode: presentationMode)
            }
        if !Constants.Singleton.isiPad {
            updateVideoFullscreenView(mode: theoPlayer.presentationMode)
            eventListeners[PlayerEventTypes.PRESENTATION_MODE_CHANGE.name] = modeChanged
        }

        theoPlayer.addJavascriptMessageListener(name: Constants.Scripting.eventPlayerTouched) { [weak self] _ in
			if let video = self?.video {
                self?.videoPlayerTapped.onNext(video)
            }
        }
    }
	
	private func registerAdsListen() {
		removeAdsListen()
		
		let adBegin = theoPlayer.ads.addEventListener(type: AdsEventTypes.AD_BEGIN, listener: { [weak self] _ in
			print("AD_BEGIN")
			self?.willShowAds.onNext(())
			self?.isShowAds = true
		})
		eventListeners[AdsEventTypes.AD_BEGIN.name] = adBegin
		
		let adEnd = theoPlayer.ads.addEventListener(type: AdsEventTypes.AD_END, listener: { [weak self] _ in
			print("AD_END")
			self?.willEndAds.onNext(())
			self?.isShowAds = false
		})
		eventListeners[AdsEventTypes.AD_END.name] = adEnd
		
		let adError = theoPlayer.ads.addEventListener(type: AdsEventTypes.AD_ERROR, listener: { _ in
			print("AD_ERROR")
		})
		eventListeners[AdsEventTypes.AD_ERROR.name] = adError
		
		let adBreakBegin = theoPlayer.ads.addEventListener(type: AdsEventTypes.AD_BREAK_BEGIN, listener: { _ in
			print("AD_BREAK_BEGIN")
		})
		eventListeners[AdsEventTypes.AD_BREAK_BEGIN.name] = adBreakBegin
		
		let adBreakEnd = theoPlayer.addEventListener(type: AdsEventTypes.AD_BREAK_END, listener: { _ in
			print("AD_BREAK_END")
		})
		eventListeners[AdsEventTypes.AD_BREAK_END.name] = adBreakEnd
	}
	
	private func removeAdsListen() {
		if let adBegin = eventListeners[AdsEventTypes.AD_BEGIN.name] {
			theoPlayer.ads.removeEventListener(type: AdsEventTypes.AD_BEGIN, listener: adBegin)
		}
		if let adEnd = eventListeners[AdsEventTypes.AD_END.name] {
			theoPlayer.ads.removeEventListener(type: AdsEventTypes.AD_END, listener: adEnd)
		}
		if let adError = eventListeners[AdsEventTypes.AD_ERROR.name] {
			theoPlayer.ads.removeEventListener(type: AdsEventTypes.AD_ERROR, listener: adError)
		}
		if let adBreakBegin = eventListeners[AdsEventTypes.AD_BREAK_BEGIN.name] {
			theoPlayer.ads.removeEventListener(type: AdsEventTypes.AD_BREAK_BEGIN, listener: adBreakBegin)
		}
		if let adBreakEnd = eventListeners[AdsEventTypes.AD_BREAK_END.name] {
			theoPlayer.ads.removeEventListener(type: AdsEventTypes.AD_BREAK_END, listener: adBreakEnd)
		}
	}

    private func trackExpandedPlayStart(presentationMode: PresentationMode) {
        guard presentationMode == .fullscreen else { return }
        let vodPlay = VideoVodPlay(mediaId: video.id,
                                   mediaTitle: video.title ?? "",
                                   muted: theoPlayer.muted,
                                   playMode: playMode,
                                   screenMode: .expanded,
                                   mediaPosition: video.currentTime.value)
        Components.analyticsService.logEvent(trackingObject: AnalyticsVideo(vodPlay: vodPlay, isReplay: true))
    }

    private func trackVideo() {
        guard let duration = videoDuration else { return }
        let currentTime = video.currentTime.value

        if floor(currentTime) == 0.0 {
            let vodPlay = VideoVodPlay(mediaId: video.id,
                                       mediaTitle: video.title ?? "",
                                       muted: theoPlayer.muted,
                                       playMode: playMode,
                                       screenMode: screenMode,
                                       mediaPosition: 0)
            let playTracking = AnalyticsVideo(vodPlay: vodPlay)

            if Components.analyticsService.isNotLogged(id: playTracking.contendID) {
                Components.analyticsService.logEvent(trackingObject: playTracking)
            } else {
                Components.analyticsService.logEvent(trackingObject: AnalyticsVideo(vodPlay: vodPlay,
                                                                                    isReplay: true))
            }
        } else {
            let vodMilestone = VideoVodMilestone(mediaId: video.id,
                                                 mediaTitle: video.title ?? "",
                                                 muted: theoPlayer.muted,
                                                 mediaDuration: duration,
                                                 playMode: playMode,
                                                 mediaPosition: currentTime,
                                                 screenMode: screenMode)

            if let milestoneTracking = AnalyticsVideo(vodMilestone: vodMilestone) {
                Components.analyticsService.logEvent(trackingObject: milestoneTracking)
            }
        }
    }
    
    private func removeHandlers() {
        guard theoPlayer != nil else { return }
        
        /// remove previous listers (if any)
        if let handler = eventListeners[PlayerEventTypes.PLAY.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.PLAY, listener: handler)
        }
        if let handler = eventListeners[PlayerEventTypes.PAUSE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.PAUSE, listener: handler)
        }
        if let handler = eventListeners[PlayerEventTypes.ENDED.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.ENDED, listener: handler)
        }
        if let handler = eventListeners[PlayerEventTypes.TIME_UPDATE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: handler)
        }
        if let handler = eventListeners[PlayerEventTypes.READY_STATE_CHANGE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.READY_STATE_CHANGE, listener: handler)
        }
        
        if let handler = eventListeners[PlayerEventTypes.PRESENTATION_MODE_CHANGE.name] {
            theoPlayer.removeEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE, listener: handler)
        }
        
        theoPlayer.removeJavascriptMessageListener(name: Constants.Scripting.eventPlayerTouched)
    }
    
    private func updateVideoFullscreenView(mode: PresentationMode) {
        if mode == .fullscreen {
            if let keyWindow = UIApplication.shared.keyWindow, fullscreenView.superview == nil {
                keyWindow.addSubview(fullscreenView)
               // fullscreenView.tag = Constants.ViewTag.fullscreenLandscape
                fullscreenView.translatesAutoresizingMaskIntoConstraints = false
           //     guard let windowView = fullscreenView.superview else { return }
                keyWindow.mf.addConstraints(
                    fullscreenView.top |==| keyWindow.top,
                    fullscreenView.leading |==| keyWindow.leading,
                    fullscreenView.trailing |==| keyWindow.trailing,
                    fullscreenView.bottom |==| keyWindow.bottom
                )
            }
            theoPlayer.muted = false
            setVideoFullscreen()
        } else {
            if fullscreenView.superview != nil {
                fullscreenView.removeHandlers()
                fullscreenView.removeFromSuperview()
            }
            theoPlayer.muted = self.muted
        }
    }
    
    private func setVideoEndedAnimation() {
        guard remainingTimeLabel != nil, unmuteImage != nil, bigPlayImage != nil else { return }
        remainingTimeLabel.fadeOut()
        unmuteImage.fadeOut()
        bigPlayImage.fadeIn()
        
        addThumbnail()
    }
    
    private func setVideoEnded() {
        guard remainingTimeLabel != nil, unmuteImage != nil, bigPlayImage != nil else { return }
        remainingTimeLabel.fadeOut(withDuration: 0)
        unmuteImage.fadeOut(withDuration: 0)
        bigPlayImage.fadeIn(withDuration: 0)
        
        addThumbnail()
    }
    
    private func setVideoResumed() {
        guard remainingTimeLabel != nil, unmuteImage != nil, bigPlayImage != nil else { return }
        remainingTimeLabel.fadeIn(withDuration: 0)
        unmuteImage.fadeIn(withDuration: 0)
        bigPlayImage.fadeOut(withDuration: 0)
        
        guard let theVideo = video else { return }
        if theVideo.currentTime.value == 0 {
            theoPlayer.setCurrentTime(theVideo.currentTime.value, completionHandler: { _, _ in
                theVideo.currentTime.value = Double.leastNormalMagnitude
            })
        }
        
        guard theoPlayer != nil && !theoPlayer.isDestroyed && !video.hasEnded.value,
            let videoDuration = theoPlayer.duration,
            abs(videoDuration - theVideo.currentTime.value) < Constants.DefaultValue.videoTimeDifference else { return }
        theVideo.currentTime.value = 0
        theoPlayer.setCurrentTime(theVideo.currentTime.value)
    }
    
    private func setCurrentTime() {
        if video.hasEnded.value { return }
        
        unmuteImage.fadeIn(withDuration: 0)
        remainingTimeLabel.fadeIn(withDuration: 0)
        bigPlayImage.fadeIn(withDuration: 0)
        theoPlayer.setCurrentTime(video.currentTime.value)
        let stateHandler = theoPlayer.addEventListener(type: PlayerEventTypes.READY_STATE_CHANGE,
                                                       listener: { [weak self] event in
                                                        guard let strongS = self else { return }
            if strongS.video.currentTime.value > 0 && strongS.video.currentTime.value > event.currentTime &&
                (event.readyState == .HAVE_CURRENT_DATA || event.readyState == .HAVE_ENOUGH_DATA) {
                strongS.theoPlayer.setCurrentTime(strongS.video.currentTime.value)
            }
        })
        
        eventListeners[PlayerEventTypes.READY_STATE_CHANGE.name] = stateHandler
    }
    
    private func setupPlayer() {
        let jqueryPath = Bundle.main.path(forResource: "jquery-3.3.1.min", ofType: "js")!
        let jqueryUIPath = Bundle.main.path(forResource: "jquery-ui.min", ofType: "js")!
        let jquerySimulatePath = Bundle.main.path(forResource: "jquery.simulate", ofType: "js")!
        let customTheoPath = Bundle.main.path(forResource: "customTheo", ofType: "js")!

        let jsPaths = [jqueryPath, jqueryUIPath, jquerySimulatePath, customTheoPath]
        let moatAnalytics = MoatOptions(partnerCode: Constants.MOATPartnerCode.theoPlayer)
        
        let playerConfig = THEOplayerConfiguration(defaultCSS: true,
                                                   cssPaths: [],
                                                   jsPaths: jsPaths,
												   googleIMA: true,
                                                   analytics: [moatAnalytics])
        // Set up the player
        theoPlayer = THEOplayer(configuration: playerConfig)
        theoPlayer.autoplay = false
        theoPlayer.muted = true
        theoPlayer.setPreload(.auto)
        theoPlayer.frame = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth,
                                  height: Constants.DeviceMetric.screenWidth * Constants.DefaultValue.ratio9H16W)
        
        theoPlayer.addAsSubview(of: parentView)
        
        theoPlayer.fullscreenOrientationCoupling = false
    }
    
    private func setupAdditionalViews() {
        createPlayButton()
        createUnmuteButton()
        createRemainingTimeLabel()
    }
    
    private func createThumbnailImage() {
        guard let image = video.videoThumbnail, bigPlayImage != nil, parentView != nil else { return }
        
        if let view = parentView.viewWithTag(Constants.ViewTag.videoThumbImg) { view.removeFromSuperview() }
        
        thumbContainerView = UIView()
        thumbContainerView.backgroundColor = Colors.blackBackGround.color()
        thumbContainerView.tag = Constants.ViewTag.videoThumbImg
        addThumbnail()
        
        let thumbImage = UIImageView()
        thumbImage.setImage(from: Media(withImageUrl: image), resolution: ImageResolution.ar16x9, gifSupport: false)
        thumbContainerView.addSubview(thumbImage)
        thumbImage.translatesAutoresizingMaskIntoConstraints = false
        thumbImage.contentMode = .scaleAspectFit
        thumbContainerView.addLayoutConstraints(
            thumbImage.centerX |==| thumbContainerView.centerX,
            thumbImage.centerY |==| thumbContainerView.centerY,
            thumbImage.height |==| thumbContainerView.height
        )
        
        let tapGesture = UITapGestureRecognizer()
        thumbContainerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
				guard let video = self?.video, let isShowingAds = self?.isShowAds, !isShowingAds else { return }
				self?.videoPlayerTapped.onNext(video)
            }).disposed(by: disposeBag)
    }
    
    private func removeThumbnail() {
        guard thumbContainerView != nil else { return }
        thumbContainerView.removeFromSuperview()
    }
    
    private func addThumbnail() {
        guard thumbContainerView != nil &&
            parentView.viewWithTag(Constants.ViewTag.videoThumbImg) == nil else { return }
        
        thumbContainerView.translatesAutoresizingMaskIntoConstraints = false
        parentView.insertSubview(thumbContainerView, belowSubview: bigPlayImage)
        parentView.addLayoutConstraints(
            thumbContainerView.centerX |==| parentView.centerX,
            thumbContainerView.centerY |==| parentView.centerY,
            thumbContainerView.height |==| parentView.height,
            thumbContainerView.width |==| parentView.width
        )
    }
    
    private func createUnmuteButton() {
        guard unmuteImage == nil && parentView.viewWithTag(Constants.ViewTag.videoUnmuteImg) == nil else { return }
        
        unmuteImage = UIImageView(image: R.image.iconVideoUnmute())
        unmuteImage.tag = Constants.ViewTag.videoUnmuteImg
        parentView.addSubview(unmuteImage)
        unmuteImage.translatesAutoresizingMaskIntoConstraints = false
        parentView.addLayoutConstraints(
            unmuteImage.height |==| 15,
            unmuteImage.leading |==| parentView.leading |+| Constants.DefaultValue.defaultMargin,
            unmuteImage.bottom |==| parentView.bottom |-| Constants.DefaultValue.defaultMargin
        )
        
        unmuteWidthConstraint = parentView.addLayoutConstraint(unmuteImage.width |==| audioButtonWidth)
    }
    
    private func createPlayButton() {
        guard bigPlayImage == nil && parentView.viewWithTag(Constants.ViewTag.videoBigPlayImg) == nil else { return }
        
        bigPlayImage = UIImageView(image: R.image.iconVideoPlay())
        parentView.addSubview(bigPlayImage)
        bigPlayImage.tag = Constants.ViewTag.videoBigPlayImg
        bigPlayImage.translatesAutoresizingMaskIntoConstraints = false
        parentView.addLayoutConstraints(
            bigPlayImage.height |==| 48,
            bigPlayImage.width |==| 48,
            bigPlayImage.centerX |==| parentView.centerX,
            bigPlayImage.centerY |==| parentView.centerY
        )
    }
    
    private func createRemainingTimeLabel() {
        guard remainingTimeLabel == nil
            && parentView.viewWithTag(Constants.ViewTag.videoTimeRemaining) == nil else { return }
        
        remainingTimeLabel = UILabel()
        remainingTimeLabel.textAlignment = .center
        remainingTimeLabel.font = Fonts.Primary.regular.toFontWith(size: 10)
        remainingTimeLabel.textColor = UIColor.white
        remainingTimeLabel.text = "-:-"
        remainingTimeLabel.tag = Constants.ViewTag.videoTimeRemaining

        parentView.addSubview(remainingTimeLabel)
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        parentView.addLayoutConstraints(
            remainingTimeLabel.height |==| 14,
            remainingTimeLabel.width |==| 40,
            remainingTimeLabel.leading |==| unmuteImage.trailing |+| (Constants.DefaultValue.defaultMargin / 2),
            remainingTimeLabel.centerY |==| unmuteImage.centerY |+| 2
        )
    }
    
    private func setRemainingTime(withDuration: Double) {
        remainingTimeLabel.text = Common.videoTimeFor(duration: withDuration)
        guard let text = remainingTimeLabel.text else { return }
        remainingTimeEvent.onNext(text)
    }
}
