//
//  AirTimeInformationEntity.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/12/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AirTimeInformationEntity: NSObject {
    var displayStartDate: Date?
    var displayEndDate: Date?
    var displayStartTime: String
    var displayEndTime: String
    
    var startDate: Double = 0
    var endDate: Double = 0
    var startTime: Double = 0
    var endTime: Double = 0
    
    var interval: String
    
    var isDefaultRelationship: Bool
    var disabled: Bool
    var showLabel: String
    var inscrement: String
    
    var channel: ChannelEntity
    var repeatOn: [RepeatOnEntity]?
    
    init(displayStartDate: Date?, displayEndDate: Date?, displayStartTime: String, displayEndTime: String,
         startDate: Double, endDate: Double, startTime: Double, endTime: Double, interval: String,
         isDefaultRelationship: Bool, disabled: Bool, showLabel: String, inscrement: String,
         channel: ChannelEntity, repeatOn: [RepeatOnEntity]?) {
        self.displayStartDate = displayStartDate
        self.displayEndDate = displayEndDate
        self.displayStartTime = displayStartTime
        self.displayEndTime = displayEndTime
        
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
        
        self.interval = interval
        
        self.isDefaultRelationship = isDefaultRelationship
        self.disabled = disabled
        self.showLabel = showLabel
        self.inscrement = inscrement
        
        self.channel = channel
        self.repeatOn = repeatOn
    }
}

class ChannelEntity: NSObject {
    var id: String
    var title: String
    var logo: String?
    var externalUrl: String?
    var gender: String?
    var publishedDate: Date?
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    convenience init(id: String, title: String, logo: String?, externalUrl: String?, gender: String?,
                     publishedDate: Date?) {
        self.init(id: id, title: title)
        self.logo = logo
        self.externalUrl = externalUrl
        self.gender = gender
        self.publishedDate = publishedDate
    }
}

class RepeatOnEntity: NSObject {
    var id: Int
    var value: String
    
    init(id: Int, value: String) {
        self.id = id
        self.value = value
    }
}
