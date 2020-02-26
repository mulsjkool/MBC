//
//  AnalyticsVideo.swift
//  MBC
//
//  Created by Tram Nguyen on 3/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum VideoAudioMode: String {
    case audioOn = "on"
    case audioOff = "off"
    case undefined = ""
}

enum VideoPlayMode: String {
    case click2play, autoplay, autonextvideo
}

enum VideoScreenMode: String {
    case normal, instream, expanded
}

enum VideoPodType: String {
    case preroll, midroll, undefined = ""
}

enum VideoPodStatus: String {
    case filled, empty, interrupted, undefined = ""
}

class AnalyticsVideo: BaseAnalyticsTracking {

    private var mediaId: String
    private var mediaTitle: String
    private var audioMode: VideoAudioMode
    private var mediaDuration: Double = 0
    private var playMode: VideoPlayMode
    private var mediaPosition: Double = 0
    private var screenMode: VideoScreenMode
    private var playingTime: Double = 0
    private var terminations: Bool = false
    private var plays: Bool = false
    private var streamPlays: Bool = false
    private var playEnds: Bool = false
    private var podType: VideoPodType = .undefined
    private var podStatus: VideoPodStatus = .undefined
    private var filledPods: Bool = false
    private var emptyPods: Bool = false
    private var podInterruptions: Bool = false

    private let eventAction: AnalyticsEventAction

    init(vodTerminate: VideoVodTerminate) {
        self.mediaId = vodTerminate.mediaId
        self.mediaTitle = vodTerminate.mediaTitle
        self.audioMode = vodTerminate.muted.audioMode
        self.mediaDuration = vodTerminate.mediaDuration
        self.playMode = vodTerminate.playMode
        self.mediaPosition = vodTerminate.mediaPosition
        self.screenMode = vodTerminate.screenMode
        self.playingTime = vodTerminate.playingTime
        self.terminations = true
        self.playEnds = self.playingTime > 0
        self.eventAction = .videoTerminate
    }

    init?(vodMilestone: VideoVodMilestone) {
        self.mediaId = vodMilestone.mediaId
        self.mediaTitle = vodMilestone.mediaTitle
        self.audioMode = vodMilestone.muted.audioMode
        self.playMode = vodMilestone.playMode
        self.mediaPosition = vodMilestone.mediaPosition
        self.screenMode = vodMilestone.screenMode

        let percent = vodMilestone.mediaPosition / vodMilestone.mediaDuration
        if percent >= 0.95 {
            self.eventAction = .videoMilestone95
        } else if percent >= 0.75 {
            self.eventAction = .videoMilestone75
        } else if percent >= 0.50 {
            self.eventAction = .videoMilestone50
        } else if percent >= 0.25 {
            self.eventAction = .videoMilestone25
        } else {
            return nil
        }
    }

    init(vodPodEnd: VideoVodPodEnd) {
        self.mediaId = vodPodEnd.mediaId
        self.mediaTitle = vodPodEnd.mediaTitle
        self.audioMode = vodPodEnd.muted.audioMode
        self.playMode = vodPodEnd.playMode
        self.mediaPosition = vodPodEnd.mediaPosition
        self.screenMode = .expanded
        self.filledPods = vodPodEnd.filledPods
        self.emptyPods = vodPodEnd.emptyPods
        self.podStatus = vodPodEnd.podStatus
        self.podType = vodPodEnd.podType
        self.eventAction = .videoPodEnd
    }

    init(vodPodInterrupt: VideoVodPodInterrupt) {
        self.mediaId = vodPodInterrupt.mediaId
        self.mediaTitle = vodPodInterrupt.mediaTitle
        self.audioMode = vodPodInterrupt.muted.audioMode
        self.playMode = vodPodInterrupt.playMode
        self.mediaPosition = vodPodInterrupt.mediaPosition
        self.screenMode = .expanded
        self.filledPods = vodPodInterrupt.filledPods
        self.emptyPods = vodPodInterrupt.emptyPods
        self.podStatus = .interrupted
        self.podType = vodPodInterrupt.podType
        self.podInterruptions = true
        self.eventAction = .videoPodInterrupt
    }

    init(vodPlay: VideoVodPlay, isReplay: Bool = false) {
        self.mediaId = vodPlay.mediaId
        self.mediaTitle = vodPlay.mediaTitle
        self.audioMode = vodPlay.muted.audioMode
        self.playMode = vodPlay.playMode
        self.screenMode = vodPlay.screenMode

        if isReplay {
            self.eventAction = .videoReplay
        } else {
            let isExpanded = vodPlay.screenMode == .expanded

            self.streamPlays = !isExpanded
            self.plays = isExpanded
            self.eventAction = isExpanded ? .videoPlay : .videoStreamPlay
        }
    }

}

extension AnalyticsVideo: IAnalyticsTrackingObject {

    var contendID: String? {
        if eventAction == .videoReplay {
            return nil
        }
        return mediaId + eventAction.rawValue
    }

    var eventName: String {
        return AnalyticsEventName.eventTracking.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.video.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsOtherVariable.eventAction.rawValue: eventAction.rawValue,
                       AnalyticsOtherVariable.eventLabel.rawValue: "",
                       AnalyticsVideoVariable.mediaId.rawValue: mediaId,
                       AnalyticsVideoVariable.mediaTitle.rawValue: mediaTitle,
                       AnalyticsVideoVariable.mediaDuration.rawValue: mediaDuration,
                       AnalyticsVideoVariable.playMode.rawValue: playMode.rawValue,
                       AnalyticsVideoVariable.audioMode.rawValue: audioMode.rawValue,
                       AnalyticsVideoVariable.mediaPosition.rawValue: mediaPosition,
                       AnalyticsVideoVariable.screenMode.rawValue: screenMode.rawValue,
                       AnalyticsVideoVariable.playingTime.rawValue: playingTime,
                       AnalyticsVideoVariable.terminations.rawValue: terminations.intValue,
                       AnalyticsVideoVariable.plays.rawValue: plays.intValue,
                       AnalyticsVideoVariable.streamPlays.rawValue: streamPlays.intValue,
                       AnalyticsVideoVariable.playEnds.rawValue: playEnds.intValue,
                       AnalyticsVideoVariable.podType.rawValue: podType.rawValue,
                       AnalyticsVideoVariable.podStatus.rawValue: podStatus.rawValue,
                       AnalyticsVideoVariable.filledPods.rawValue: filledPods.intValue,
                       AnalyticsVideoVariable.emptyPods.rawValue: emptyPods.intValue,
                       AnalyticsVideoVariable.podInterruptions.rawValue: podInterruptions.intValue
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [:]
    }

}
