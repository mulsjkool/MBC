//
//  AirTimeInformation.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AirTimeInformation: Codable {
    var displayStartDate: Date?
    var displayEndDate: Date?
    var displayStartTime: String
    var displayEndTime: String
    
    var startDate: Double
    var endDate: Double
    var startTime: Double
    var endTime: Double
    
    var interval: String
    
    var isDefaultRelationship: Bool
    var disabled: Bool
    var showLabel: String
    var inscrement: String
    
    var channel: Channel
    var repeatOn: [RepeatOn]?
    
    init(entity: AirTimeInformationEntity) {
        self.displayStartDate = entity.displayStartDate
        self.displayEndDate = entity.displayEndDate
        self.displayStartTime = entity.displayStartTime
        self.displayEndTime = entity.displayEndTime
        
        self.startDate = entity.startDate
        self.endDate = entity.endDate
        self.startTime = entity.startTime
        self.endTime = entity.endTime
        
        self.interval = entity.interval
        
        self.isDefaultRelationship = entity.isDefaultRelationship
        self.disabled = entity.disabled
        self.showLabel = entity.showLabel
        
        self.channel = Channel(entity: entity.channel)
        if let array = entity.repeatOn {
            self.repeatOn = array.map({ RepeatOn(entity: $0) })
        }
        self.inscrement = entity.inscrement
    }
}

class Channel: Codable {
    var id: String
    var title: String
    var logo: String?
    var externalUrl: String?
    var gender: String?
    var publishedDate: Date?
    
    init(entity: ChannelEntity) {
        self.id = entity.id
        self.title = entity.title
        self.logo = entity.logo
        self.externalUrl = entity.externalUrl
        self.gender = entity.gender
        self.publishedDate = entity.publishedDate
    }
}

class RepeatOn: Codable {
    var id: Int
    var value: String
    
    init(entity: RepeatOnEntity) {
        self.id = entity.id
        self.value = entity.value
    }
}
