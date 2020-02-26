//
//  ScheduleJsonTransfomer.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScheduleJsonTransfomer: JsonTransformer {
    let showJsonTransformer: ShowJsonTransfomer
    let schedulerChannelJsonTransfomer: SchedulerChannelJsonTransfomer
    
    init(showJsonTransformer: ShowJsonTransfomer, schedulerChannelJsonTransfomer: SchedulerChannelJsonTransfomer) {
        self.showJsonTransformer = showJsonTransformer
        self.schedulerChannelJsonTransfomer = schedulerChannelJsonTransfomer
    }
    
    private static let fields = (
        show: "show",
        channelType: "channelType",
        defaultScheduler: "defaultScheduler",
        label: "label",
        startTime: "startTime",
        endTime: "endTime",
        duration: "duration",
        channel: "channel"
    )
    
     func transform(json: JSON) -> ScheduleEntity {
        let fields = ScheduleJsonTransfomer.fields
        let showEntity = self.showJsonTransformer.transform(json: json[fields.show])
        let channelType = json[fields.channelType].stringValue
        let defaultScheduler = json[fields.defaultScheduler].boolValue
        let label = json[fields.label].string
        let startTime = Date.dateFromTimestamp(miniSecond: json[fields.startTime].doubleValue)
        let endTime = Date.dateFromTimestamp(miniSecond: json[fields.endTime].doubleValue)
        let duration = json[fields.duration].stringValue
        
        let channelEntity = self.schedulerChannelJsonTransfomer.transform(json: json[fields.channel])
        
        let scheduleEntity = ScheduleEntity(showEntity: showEntity, channelType: channelType,
                                            defaultScheduler: defaultScheduler, label: label, startTime: startTime,
                                            endTime: endTime, duration: duration, channelId: channelEntity.id,
                                            channelTitle: channelEntity.title,
                                            channelPublishedDate: channelEntity.publishedDate,
                                            channelLogo: channelEntity.logo)
        
        return scheduleEntity
    }
}

class ListScheduleJsonTransfomer: JsonTransformer {
    let scheduleJsonTransfomer: ScheduleJsonTransfomer
    
    init(scheduleJsonTransfomer: ScheduleJsonTransfomer) {
        self.scheduleJsonTransfomer = scheduleJsonTransfomer
    }
    
    func transform(json: JSON) -> [ScheduleEntity] {
        var list = [ScheduleEntity]()
        let itemList = json["items"].arrayValue
        for jsonItem in itemList {
            let scheduleItem = self.scheduleJsonTransfomer.transform(json: jsonItem)
            list.append(scheduleItem)
        }
        return list
    }
}

class SchedulerChannelJsonTransfomer: PageJsonTransformer {
    
    override func transform(json: JSON) -> SchedulerChannelEntity {
        let pageEntity = super.transform(json: json)
        let publishedDate = json["publishedDate"] == JSON.null ? nil :
            Date.dateFromTimestamp(miniSecond: json["publishedDate"].doubleValue)
        let schedulerChannelEntity = SchedulerChannelEntity(pageEntity: pageEntity)
        schedulerChannelEntity.publishedDate = publishedDate
        return schedulerChannelEntity
    }
}

class ShowJsonTransfomer: JsonTransformer {
    private static let fields = (
        id: "id",
        title: "title",
        logo: "logo",
        externalUrl: "externalUrl",
        gender: "gender",
        
        season: "season",
        sequenceNumber: "sequenceNumber",
        about: "about",
        poster: "poster",
        label: "label",
        
        genre: "genre"
    )
    
    func transform(json: JSON) -> ShowEntity {
        let fields = ShowJsonTransfomer.fields
        let id = json[fields.id].stringValue
        let title = json[fields.title].stringValue
        let logo = json[fields.logo].stringValue
        let gender = json[fields.gender].string
        let season = json[fields.season].string
        let sequenceNumber = json[fields.sequenceNumber].string
        let about = json[fields.about].stringValue
        let poster = json[fields.poster].stringValue
        let label = json[fields.label].string
        
        let jsonGenre = json[fields.genre]
        let idGenre = jsonGenre["id"].stringValue
        let codeGenre = jsonGenre["code"].stringValue
        let defaultName = jsonGenre["defaultName"].stringValue
        let localeNamesAr = jsonGenre["localeNames"]["ar"].stringValue
        let localeNamesEn = jsonGenre["localeNames"]["en"].stringValue
        let genreEntity = GenreShowEntity(id: idGenre, code: codeGenre, defaultName: defaultName,
                                          localeNamesAr: localeNamesAr, localeNamesEn: localeNamesEn)
        
        return ShowEntity(id: id, title: title, gender: gender, logo: logo, season: season,
                          sequenceNumber: sequenceNumber, about: about, poster: poster, label: label,
                          genre: genreEntity)
        
    }
}

class ScheduledChannelsJsonTransfomer: JsonTransformer {
    private static let fields = (
        channel: "channel",
        daily: "daily",
        defaultScheduler: "defaultScheduler",
        label: "label",
        startTime: "startTime",
        endTime: "endTime",
        
        id: "id",
        title: "title",
        logo: "logo",
        externalUrl: "externalUrl",
        gender: "gender",
        publishedDate: "publishedDate"
    )
    
    func transform(json: JSON) -> ScheduleEntity {
        let fields = ScheduledChannelsJsonTransfomer.fields
        
        let defaultScheduler = json[fields.defaultScheduler].boolValue
        let daily = json[fields.daily].boolValue
        let label = json[fields.label].string
        
        let startTime = Date.dateFromTimestamp(miniSecond: json[fields.startTime].doubleValue)
        let endTime = Date.dateFromTimestamp(miniSecond: json[fields.endTime].doubleValue)
        
        let publishedDate = Date.dateFromTimestamp(miniSecond: json[fields.channel][fields.publishedDate].doubleValue)
        
        let channel = ChannelEntity(id: json[fields.channel][fields.id].string ?? "",
                                    title: json[fields.channel][fields.title].string ?? "",
                                    logo: json[fields.channel][fields.logo].string ?? "",
                                    externalUrl: json[fields.channel][fields.externalUrl].string ?? "",
                                    gender: json[fields.channel][fields.gender].string ?? "",
                                    publishedDate: publishedDate)
        
        return ScheduleEntity(defaultScheduler: defaultScheduler, label: label, startTime: startTime, endTime: endTime,
                              daily: daily, channel: channel)
    }
}

class ListScheduledChannelsJsonTransfomer: JsonTransformer {
    let scheduledChannelsJsonTransfomer: ScheduledChannelsJsonTransfomer
    
    init(scheduledChannelsJsonTransfomer: ScheduledChannelsJsonTransfomer) {
        self.scheduledChannelsJsonTransfomer = scheduledChannelsJsonTransfomer
    }
    
    func transform(json: JSON) -> [ScheduleEntity] {
        var list = [ScheduleEntity]()
        let itemList = json["items"].arrayValue
        for jsonItem in itemList {
            let scheduleItem = self.scheduledChannelsJsonTransfomer.transform(json: jsonItem)
            list.append(scheduleItem)
        }
        return list
    }
}
