//
//  AnalyticsAudio.swift
//  MBC
//
//  Created by Tram Nguyen on 4/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum AudioMode: String {
    case audioOn = "on"
    case audioOff = "off"
    case undefined = ""
}

enum AudioPlayMode: String {
    case click2play, autoplay
}

class AnalyticsAudio: BaseAnalyticsTracking {

    private let mediaId: String?
    private let audioMode: AudioMode
    private let playMode: AudioPlayMode
    private let terminations: Bool
    private let mediaDuration: Double
    private let mediaPosition: Double
    private let playingTime: Double
    private let playEnds: Bool
    private let plays: Bool
    private let eventAction: AnalyticsEventAction

    //audio-aod-play
    init(mediaId: String?, isMuted: Bool, playMode: AudioPlayMode) {
        self.mediaId = mediaId
        self.audioMode = isMuted ? .audioOff : .audioOn
        self.playMode = playMode
        self.terminations = false
        self.mediaDuration = 0
        self.mediaPosition = 0
        self.playingTime = 0
        self.playEnds = false
        self.plays = true
        self.eventAction = .audioAodPlay
    }

    //audio-aod-terminate
    init(mediaId: String?, isMuted: Bool, playMode: AudioPlayMode,
         mediaDuration: Double, mediaPosition: Double, playingTime: Double) {
        self.mediaId = mediaId
        self.audioMode = isMuted ? .audioOff : .audioOn
        self.playMode = playMode
        self.terminations = true
        self.mediaDuration = mediaDuration
        self.mediaPosition = mediaPosition
        self.playingTime = playingTime
        self.playEnds = playingTime > 0.0
        self.plays = false
        self.eventAction = .audioAodTerminate
    }
}

extension AnalyticsAudio: IAnalyticsTrackingObject {

    var contendID: String? {
        return mediaId
    }

    var eventName: String {
        return AnalyticsEventName.eventTracking.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.audio.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsOtherVariable.eventAction.rawValue: eventAction.rawValue,
                       AnalyticsOtherVariable.eventLabel.rawValue: "",
                       AnalyticsVideoVariable.mediaId.rawValue: mediaId ?? "",
                       AnalyticsVideoVariable.mediaDuration.rawValue: mediaDuration,
                       AnalyticsVideoVariable.playMode.rawValue: playMode.rawValue,
                       AnalyticsVideoVariable.audioMode.rawValue: audioMode.rawValue,
                       AnalyticsVideoVariable.mediaPosition.rawValue: mediaPosition,
                       AnalyticsVideoVariable.screenMode.rawValue: VideoScreenMode.normal.rawValue,
                       AnalyticsVideoVariable.playingTime.rawValue: playingTime,
                       AnalyticsVideoVariable.terminations.rawValue: terminations.intValue,
                       AnalyticsVideoVariable.plays.rawValue: plays.intValue,
                       AnalyticsVideoVariable.streamPlays.rawValue: 0,
                       AnalyticsVideoVariable.playEnds.rawValue: playEnds.intValue,
                       AnalyticsVideoVariable.podType.rawValue: "",
                       AnalyticsVideoVariable.podStatus.rawValue: "",
                       AnalyticsVideoVariable.filledPods.rawValue: 0,
                       AnalyticsVideoVariable.emptyPods.rawValue: 0,
                       AnalyticsVideoVariable.podInterruptions.rawValue: 0
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [:]
    }

}
