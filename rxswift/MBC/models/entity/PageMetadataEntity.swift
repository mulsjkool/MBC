//
//  PageMetadataEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageMetadataEntity {
    var fullName: String?
    var pageSubType: String?
    var channelName: String?
    var channelShortName: String?
    var genreName: String?
    var yearDebuted: Int?
    var occupations: [String]?
    var playerNickName: String?
    var votingNumber: UInt64 = 0
    var gender: String?
    var establishedYear: Date?
    var sequelNumber: String?
    var seasonNumber: String?
    var liveRecorded: String?
    var pageSubTypeData: [String: Any?]?
    var venueAddress: String?
    var genres: [String]?
    var dialect: String?
	var appStore: String?
	var googlePlay: String?
	var frequencyChannels: [FrequencyChannelEntity]?
	var socialNetworks: [SocialNetworkEntity]?
	var radioSubChannels: [RadioSubChannelEntity]?
	var airTimeInformation: [AirTimeInformationEntity]?

    init(fullName: String?, pageSubType: String?, channelName: String?, channelShortName: String?, genreName: String?,
         yearDebuted: Int?, occupations: [String]?, playerNickName: String?, votingNumber: UInt64, gender: String?,
         establishedYear: Date?, sequelNumber: String?, seasonNumber: String?, liveRecorded: String?,
         pageSubTypeData: [String: Any?]?, venueAddress: String?, genres: [String]?, dialect: String?,
		airTimeInformation: [AirTimeInformationEntity]?, appStore: String?,
		googlePlay: String?, frequencyChannels: [FrequencyChannelEntity]?, socialNetworks: [SocialNetworkEntity]?,
		radioSubChannels: [RadioSubChannelEntity]?) {
        self.fullName = fullName
        self.pageSubType = pageSubType
        self.channelName = channelName
        self.channelShortName = channelShortName
        self.genreName = genreName
        self.yearDebuted = yearDebuted
        self.occupations = occupations
        self.playerNickName = playerNickName
        self.votingNumber = votingNumber
        self.gender = gender
        self.establishedYear = establishedYear
        self.sequelNumber = sequelNumber
        self.seasonNumber = seasonNumber
        self.liveRecorded = liveRecorded
        self.pageSubTypeData = pageSubTypeData
        self.venueAddress = venueAddress
        self.genres = genres
        self.dialect = dialect
		self.appStore = appStore
		self.googlePlay = googlePlay
		self.frequencyChannels = frequencyChannels
		self.socialNetworks = socialNetworks
		self.radioSubChannels = radioSubChannels
        self.airTimeInformation = airTimeInformation
    }
}
