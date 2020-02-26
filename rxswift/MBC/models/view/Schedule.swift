//
//  Schedule.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class Schedule {
    var label: String?
    var title: String
    var season: String?
    var sequenceNumber: String?
    var genre: String
    var startTime: Date
    var endTime: Date
    var duration: String
    var channelType: String
    var defaultScheduler: Bool
    
    var isOnShowTime: Bool = false
    var rowIndex: Int = 0
    
    var showId: String?
    
    // channel
    var channelId: String
    var channelTitle: String
    var channelPublishedDate: Date?
    var channelLogo: String?
    
    var daily: Bool = false
    var channel: Channel?
    
    init(entity: ScheduleEntity) {
        self.label = entity.label
        self.title = entity.title
        self.season = entity.season
        self.sequenceNumber = entity.sequenceNumber
        self.genre = entity.genre
        self.startTime = entity.startTime
        self.endTime = entity.endTime
        self.duration = entity.duration
        self.channelType = entity.channelType
        self.defaultScheduler = entity.defaultScheduler

        self.showId = entity.showId
        
        self.channelId = entity.channelId
        self.channelTitle = entity.channelTitle
        self.channelPublishedDate = entity.channelPublishedDate
        self.channelLogo = entity.channelLogo
        self.daily = entity.daily
        
        if let channel = entity.channel {
            self.channel = Channel(entity: channel)
        }
    }
}
