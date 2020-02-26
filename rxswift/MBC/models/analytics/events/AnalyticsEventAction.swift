//
//  AnalyticsEventAction.swift
//  MBC
//
//  Created by Tram Nguyen on 1/31/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum AnalyticsEventAction: String {
    case clickOnLogin = "Click on Login"
    case clickOnLogout = "Click on Log out"
    case clickOnRegistraton = "Click On Registration" // TODO: not defined yet, should update in future
    
    case videoStreamPlay = "video-vod-streamplay"
    case videoPlay = "video-vod-play"
    case videoPodInterrupt = "video-vod-pod-interrupt"
    case videoPodEnd = "video-vod-pod-end"
    case videoMilestone25 = "video-vod-milestone25"
    case videoMilestone50 = "video-vod-milestone50"
    case videoMilestone75 = "video-vod-milestone75"
    case videoMilestone95 = "video-vod-milestone95+"
    case videoReplay = "video-vod-replay"
    case videoTerminate = "video-vod-terminate"

    case audioAodPlay = "audio-aod-play"
    case audioAodTerminate = "audio-aod-terminate"
}
