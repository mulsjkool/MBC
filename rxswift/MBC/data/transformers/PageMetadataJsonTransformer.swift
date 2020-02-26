//
//  PageMetadataJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import SwiftyJSON
import UIKit

class PageMetadataJsonTransformer: JsonTransformer {
    let airTimeInformationJsonTransformer: AirTimeInformationJsonTransformer
	let listFrequencyChannelJsonTransformer: ListFrequencyChannelJsonTransformer
	let listSocialNetworkJsonTransformer: ListSocialNetworkJsonTransformer
	let listRadioSubChannelJsonTransformer: ListRadioSubChannelJsonTransformer
    
    init(airTimeInformationJsonTransformer: AirTimeInformationJsonTransformer,
		 listFrequencyChannelJsonTransformer: ListFrequencyChannelJsonTransformer,
		 listSocialNetworkJsonTransformer: ListSocialNetworkJsonTransformer,
		 listRadioSubChannelJsonTransformer: ListRadioSubChannelJsonTransformer) {
        self.airTimeInformationJsonTransformer = airTimeInformationJsonTransformer
		self.listFrequencyChannelJsonTransformer = listFrequencyChannelJsonTransformer
		self.listSocialNetworkJsonTransformer = listSocialNetworkJsonTransformer
		self.listRadioSubChannelJsonTransformer = listRadioSubChannelJsonTransformer
    }
    
    private static let fields = (
        fullName: "fullName",
        pageSubType: "pageSubType",
        pageSubTypeData: "pageSubTypeData",
        channelName: "channelName",
        channelShortName: "channelShortName",
        dialect: "dialect",
        genre: "genre",
        names: "names",
        yearDebuted: "yearDebuted",
        occupations: "occupations",
        playerNickName: "playerNickName",
        votingNumber: "votingNumber",
        gender: "gender",
        establishedYear: "establishedYear",
        sequelNumber: "sequelNumber",
        seasonNumber: "seasonNumber",
        liveRecorded: "liveRecorded",
        venueAddress: "venueAddress",
		appStore: "appStore",
		googlePlay: "googlePlay",
		channelFrequency: "channelFrequency",
		socialNetwork: "socialNetwork",
		radioSubChannel: "radioScript",
        airTimeInformation: "airTimeInformation"
    )
	
    func transform(json: JSON) -> PageMetadataEntity {
        let fields = PageMetadataJsonTransformer.fields

        let fullName = json[fields.fullName].string
        let pageSubType = json[fields.pageSubType].string
        let channelName = json[fields.pageSubTypeData][fields.channelName].string
        let channelShortName = json[fields.pageSubTypeData][fields.channelShortName].string
        let genreName = json[fields.pageSubTypeData][fields.genre][fields.names].string
        let yearDebuted = json[fields.pageSubTypeData][fields.yearDebuted].int
        var occupations: [String]? = nil
        if let occupationsJson = json[fields.pageSubTypeData][fields.occupations].array {
            occupations = occupationsJson.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        let playerNickName = json[fields.pageSubTypeData][fields.playerNickName].string
        let votingNumber = json[fields.pageSubTypeData][fields.votingNumber].uInt64 ?? 0
        let gender = json[fields.pageSubTypeData][fields.gender].string
        var establishedYear: Date? = nil
        if let establishedYearString = json[fields.pageSubTypeData][fields.establishedYear].string {
            establishedYear = Date.dateFromString(string: establishedYearString,
                                              format: Constants.DateFormater.StandardWithMilisecond)
        }
        let sequelNumber = json[fields.pageSubTypeData][fields.sequelNumber].string
        let seasonNumber = json[fields.pageSubTypeData][fields.seasonNumber].string
        let liveRecorded = json[fields.pageSubTypeData][fields.liveRecorded].string
        let pageSubTypeData = json[fields.pageSubTypeData].dictionaryObject
        let venueAddress = json[fields.pageSubTypeData][fields.venueAddress].string
        var genres: [String]? = nil
        if let genresJson = json[fields.pageSubTypeData][fields.genre].array {
            genres = genresJson.map { $0.stringValue }
        } else {
            if let genreNames = json[fields.pageSubTypeData][fields.genre]["names"].string {
                genres = [genreNames]
            }
        }
        let dialect = json[fields.pageSubTypeData][fields.dialect]["names"].string
		
		let appStore = json[fields.pageSubTypeData][fields.appStore].string
		let googlePlay = json[fields.pageSubTypeData][fields.googlePlay].string
		
		let frequencyData = json[fields.pageSubTypeData][fields.channelFrequency]
		let frequencyChannels = listFrequencyChannelJsonTransformer.transform(json: frequencyData)
		
		let socialNetworkData = json[fields.pageSubTypeData][fields.socialNetwork]
		let socialNetworks = listSocialNetworkJsonTransformer.transform(json: socialNetworkData)
		
		let radioSubChannelData = json[fields.pageSubTypeData][fields.radioSubChannel]
		let radioSubChannels = listRadioSubChannelJsonTransformer.transform(json: radioSubChannelData)
        
        var airTimeInformation: [AirTimeInformationEntity]?
        if let airTimeInformationArray = json[fields.pageSubTypeData][fields.airTimeInformation].array,
            !airTimeInformationArray.isEmpty {
            airTimeInformation = airTimeInformationArray.map { json -> AirTimeInformationEntity in
                return airTimeInformationJsonTransformer.transform(json: json)
            }
        }
        
        return PageMetadataEntity(fullName: fullName, pageSubType: pageSubType, channelName: channelName,
                                  channelShortName: channelShortName, genreName: genreName, yearDebuted: yearDebuted,
                                  occupations: occupations, playerNickName: playerNickName, votingNumber: votingNumber,
                                  gender: gender, establishedYear: establishedYear, sequelNumber: sequelNumber,
                                  seasonNumber: seasonNumber, liveRecorded: liveRecorded,
                                  pageSubTypeData: pageSubTypeData, venueAddress: venueAddress,
								  genres: genres, dialect: dialect, airTimeInformation: airTimeInformation,
								  appStore: appStore, googlePlay: googlePlay, frequencyChannels: frequencyChannels,
								  socialNetworks: socialNetworks, radioSubChannels: radioSubChannels)
    }
}

class AirTimeInformationJsonTransformer: JsonTransformer {
    private static let fields = (
        displayStartDate: "displayStartDate",
        displayEndDate: "displayEndDate",
        displayStartTime: "displayStartTime",
        displayEndTime: "displayEndTime",
        startDate: "startDate",
        endDate: "endDate",
        startTime: "startTime",
        endTime: "endTime",
        interval: "interval",
        isDefaultRelationship: "isDefaultRelationship",
        disabled: "disabled",
        showLabel: "showLabel",
        channel: "channel",
        repeatOn: "repeatOn",
        inscrement: "inscrement",
        
        id: "id",
        value: "value"
    )
    
    func transform(json: JSON) -> AirTimeInformationEntity {
        let fields = AirTimeInformationJsonTransformer.fields
        
        let displayStartDateString = json[fields.displayStartDate].string ?? ""
        var displayStartDate: Date?
        if !displayStartDateString.isEmpty {
            displayStartDate = Date.dateFromString(string: displayStartDateString,
                                           format: Constants.DateFormater.BirthDayForAPI)
        }

        let displayEndDateString = json[fields.displayEndDate].string ?? ""
        var displayEndDate: Date?
        if !displayEndDateString.isEmpty {
            displayEndDate = Date.dateFromString(string: displayEndDateString,
                                                   format: Constants.DateFormater.BirthDayForAPI)
        }
        
        let displayStartTime = json[fields.displayStartTime].string ?? ""
        let displayEndTime = json[fields.displayEndTime].string ?? ""
        
        let startDate = json[fields.startDate].doubleValue
        let endDate = json[fields.endDate].doubleValue
        let startTime = json[fields.startTime].doubleValue
        let endTime = json[fields.endTime].doubleValue
        
        let interval = json[fields.interval].string ?? ""
        
        let isDefaultRelationship = json[fields.isDefaultRelationship].bool ?? false
        let disabled = json[fields.disabled].bool ?? false
        let showLabel = json[fields.showLabel].string ?? ""
        let inscrement = json[fields.inscrement].string ?? ""
        
        let channel = ChannelEntity(id: json[fields.channel][fields.id].string ?? "",
                                    title: json[fields.channel][fields.value].string ?? "")
        
        var repeatOn: [RepeatOnEntity]?
        if let repeatOnArray = json[fields.repeatOn].array, !repeatOnArray.isEmpty {
            repeatOn = repeatOnArray.map { json -> RepeatOnEntity in
                return RepeatOnEntity(id: json[fields.id].intValue, value: json[fields.value].string ?? "")
            }
            repeatOn?.sort(by: { entity1, entity2 -> Bool in
                return entity1.id < entity2.id
            })
        }
        
        return AirTimeInformationEntity(displayStartDate: displayStartDate, displayEndDate: displayEndDate,
                                        displayStartTime: displayStartTime, displayEndTime: displayEndTime,
                                        startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime,
                                        interval: interval, isDefaultRelationship: isDefaultRelationship,
                                        disabled: disabled, showLabel: showLabel, inscrement: inscrement,
                                        channel: channel, repeatOn: repeatOn)
    }
}
