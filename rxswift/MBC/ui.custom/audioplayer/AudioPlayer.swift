//
//  AudioPlayer.swift
//  MBC
//
//  Created by Tri Vo on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import THEOplayerSDK

class AudioPlayer {

    private var playMode: AudioPlayMode = .autoplay
    private var mediaId: String?

	var theoPlayer: THEOplayer!

    private var playingTime: Double = 0.0
    private var currentTime: Double = 0.0
    private var dateDispatched: Date? //The date and time on which the event has been dispatched
    private var timeUpdate: EventListener?
	
	var muted: Bool = false {
		didSet { theoPlayer.muted = muted }
	}
	
	init(parentView: UIView) {
        let moatAnalytics = MoatOptions(partnerCode: Constants.MOATPartnerCode.theoPlayer)
        let playerConfig = THEOplayerConfiguration(analytics: [moatAnalytics])

        // Set up the player
        theoPlayer = THEOplayer(configuration: playerConfig)
		theoPlayer.addAsSubview(of: parentView)
		theoPlayer.setPreload(.auto)
		
		defaultNotification.addObserver(self, selector: #selector(AudioPlayer.audioWillTerminate(_:)),
										name: Keys.Notification.audioWillTerminate, object: nil)
	}

    private func resetPlayingTimeCounter() {
        playingTime = 0.0
        currentTime = 0.0
        dateDispatched = nil
    }
	
    func setAudioSource(mediaId: String, url: String) {
        self.mediaId = mediaId
        removeEventListener()

		if !url.verifyUrl() { return }
		let source = SourceDescription(source: TypedSource(src: url, type: Constants.DefaultValue.TheoVideoSourceType))
		theoPlayer.source = source

        addEventListener()
	}

    private func addEventListener() {
        timeUpdate = theoPlayer.addEventListener(type: PlayerEventTypes.TIME_UPDATE) { [weak self] event in
            if let lastDateDispatched = self?.dateDispatched {
                self?.playingTime += (event.date.timeIntervalSince1970 - lastDateDispatched.timeIntervalSince1970)
            }

            self?.dateDispatched = event.date
            self?.currentTime = event.currentTime
        }
    }

    private func removeEventListener() {
        if let timeUpdate = timeUpdate {
            theoPlayer.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: timeUpdate)
        }
    }
	
    func play(click2play: Bool = false) {
        NSLog("AUDIO PLAY NOW")
        playMode = click2play ? .click2play : .autoplay
		theoPlayer.play()

        let analyticsAudio = AnalyticsAudio(mediaId: mediaId, isMuted: muted, playMode: playMode)
        Components.analyticsService.logEvent(trackingObject: analyticsAudio)
	}
	
	func pause() {
        NSLog("AUDIO PAUSE NOW")
		theoPlayer.pause()
	}
    
    func stop() {
        theoPlayer.stop()
    }
	
	@objc
	func audioWillTerminate(_ sender: Notification? = nil) {
        removeEventListener()

		if !theoPlayer.paused {
			theoPlayer.pause()
		}

        let mediaDuration = theoPlayer.duration ?? 0
        let analyticsAudio = AnalyticsAudio(mediaId: mediaId, isMuted: muted, playMode: playMode,
                                            mediaDuration: mediaDuration, mediaPosition: currentTime,
                                            playingTime: playingTime)
        Components.analyticsService.logEvent(trackingObject: analyticsAudio)
	}
	
	deinit {
        NSLog("AUDIO PLAYER DEINIT")
		audioWillTerminate()
        theoPlayer = nil
		defaultNotification.removeObserver(self, name: Keys.Notification.audioWillTerminate, object: nil)
	}
}
