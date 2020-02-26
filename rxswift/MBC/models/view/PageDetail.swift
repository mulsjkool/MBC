//
//  PageDetail.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageDetail: Codable {
    var entityId: String
    var coverThumbnail: String
    var posterThumbnail: String
	var logoThumbnail: String
    var promoVideo: Video?
    var title: String
    var topMetadata = ""
    var bottomMetadata = ""
    var pageSettings: PageSettings
    var metadata: [String: Any?]?
    private var metadataJsonString: String?
    var type: String
    var subType: String?
    var pageAboutTab: PageAboutTab
    var languageConfigList: [LanguageConfigListEntity]
    var language: String?
    var genres: [String]?
    var dialect: String?
    var universalUrl: String
    var bundles = [BundleContent]()
	var appStore: String?
	var googlePlay: String?
	var frequencyChannels: [FrequencyChannel]?
	var socialNetworks: [SocialNetwork]?
	var radioSubChannels: [RadioSubChannel]?
    var airTimeInformation: [AirTimeInformation]?
    var seasonNumber: String?
    var geoTargeting: String
    var geoSuggestions: [String]
    
    init(entity: PageDetailEntity, languageConfigList: [LanguageConfigListEntity]) {
        if !entity.entityId.isEmpty {
            self.entityId = entity.entityId
        } else { self.entityId = entity.id }
        self.universalUrl = entity.universalUrl
        self.coverThumbnail = entity.pageInfo.coverThumbnail
        self.posterThumbnail = entity.pageInfo.posterThumbnail
        self.logoThumbnail = entity.pageInfo.logoThumbnail
        self.title = entity.pageInfo.title
        self.pageSettings = PageSettings(entity: entity.pageSetting)
        self.metadata = entity.pageMetadata.pageSubTypeData
        if let metadata = self.metadata,
            let metadataJsonData = try? JSONSerialization.data(withJSONObject: metadata, options: []) {
            metadataJsonString = String(data: metadataJsonData, encoding: .utf8)
        }
        self.type = entity.pageInfo.type
        self.language = entity.pageInfo.language
        self.subType = entity.pageMetadata.pageSubType
        self.genres = entity.pageMetadata.genres
        self.dialect = entity.pageMetadata.dialect
        self.seasonNumber = entity.pageMetadata.seasonNumber
        self.languageConfigList = languageConfigList
        self.pageAboutTab = PageAboutTab(type: entity.pageInfo.type,
                                         subType: entity.pageMetadata.pageSubType,
                                         metadata: entity.pageMetadata.pageSubTypeData,
                                         languageConfigList: languageConfigList)
        
        self.geoTargeting = entity.pageInfo.geoTargeting
        self.geoSuggestions = entity.pageInfo.geoSuggestions
        
        let type = entity.pageInfo.type
        let pageType = PageType(rawValue: type) ?? PageType.other
        switch pageType {
        case .show:
            self.topMetadata = getTopMetadataForShowType(entity: entity.pageMetadata)
            self.bottomMetadata = getBottomMetadataForShowType(entity: entity.pageMetadata)
        case .profile:
            self.topMetadata = getTopMetadataForProfileType(entity: entity.pageMetadata)
            self.bottomMetadata = getBottomMetadataForProfileType(entity: entity.pageMetadata)
        case .channel:
            self.topMetadata = getTopMetadataForChannelType(entity: entity.pageMetadata)
            self.bottomMetadata = getBottomMetadataForChannelType(entity: entity.pageMetadata)
			if let pageSubType = PageSubType(rawValue: subType!), pageSubType == .radioChannel {
				getRadioChannelInfo(entity: entity.pageMetadata)
			}
        default:
            break
        }
        
        if let items = entity.bundles {
            self.bundles = items.map({ BundleContent(entity: $0) })
        }

        if let videoEntity = entity.pageInfo.promoVideo {
            self.promoVideo = Video(entity: videoEntity)
        }
        
        if let array = entity.pageMetadata.airTimeInformation, !array.isEmpty {
            self.airTimeInformation = array.map({ objEntity -> AirTimeInformation in
                return AirTimeInformation(entity: objEntity)
            })
        }
    }
    
    // MARK: Private functions
    
    private func getTopMetadataForShowType(entity: PageMetadataEntity) -> String {
        guard let pageSubTypeString = entity.pageSubType else {
            return ""
        }
        let pageSubType = PageSubType(rawValue: pageSubTypeString) ?? PageSubType.other
        switch pageSubType {
        // Year
        case .movie, .series, .program:
            return (entity.yearDebuted != nil) ? "\(entity.yearDebuted!)" : ""
        default:
            return ""
        }
    }
    
    private func getTopMetadataForProfileType(entity: PageMetadataEntity?) -> String {
        guard let entity = entity, let pageSubTypeString = entity.pageSubType else {
            return ""
        }
        let pageSubType = PageSubType(rawValue: pageSubTypeString) ?? PageSubType.other
        var gender = Gender.male
        if let genderStr = entity.gender {
            gender = Gender(rawValue: genderStr) ?? Gender.male
        }
        // Voting Number
        if pageSubType == .talent {
            if gender == .male {
                return "\(entity.votingNumber) \(R.string.localizable.pagedetailHeaderVotingformale().localized())"
            } else {
                return "\(entity.votingNumber) \(R.string.localizable.pagedetailHeaderVotingforfemale().localized())"
            }
        }
        
        return ""
    }
    
    private func getTopMetadataForChannelType(entity: PageMetadataEntity?) -> String {
        // Channel short name
        return entity?.channelShortName ?? ""
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getBottomMetadataForShowType(entity: PageMetadataEntity?) -> String {
        guard let entity = entity, let pageSubTypeString = entity.pageSubType else {
            return ""
        }
        
        let pageSubType = PageSubType(rawValue: pageSubTypeString) ?? PageSubType.other
        switch pageSubType {
            
        // Genre and Sequence Number
        case .movie:
            var array = [String]()
            if let genre = entity.genreName, !genre.isEmpty {
                array.append(genre)
            }
            if let sequelNumber = entity.sequelNumber, !sequelNumber.isEmpty {
                array.append(sequelNumber)
            }
            return array.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
        
        // Genre and Season
        case .series, .program:
            var array = [String]()
            if let genre = entity.genreName, !genre.isEmpty {
                array.append(genre)
            }
            if let seasonNumber = entity.seasonNumber, !seasonNumber.isEmpty {
                array.append(seasonNumber)
            }
            return array.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
            
        // Live and Record
        case .news, .match:
            var array = [String]()
            
            if let liveRecordedText = entity.liveRecorded,
                let liveRecorded = LiveRecordType(rawValue: liveRecordedText) {
                array.append(liveRecorded.getArabicText())
            }
            return array.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
            
        // Genre, Live and Record
        case .play:
            var array = [String]()
            if let genre = entity.genreName, !genre.isEmpty {
                array.append(genre)
            }
            if let liveRecordedText = entity.liveRecorded,
                let liveRecorded = LiveRecordType(rawValue: liveRecordedText) {
                array.append(liveRecorded.getArabicText())
            }
            return array.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
            
        default:
            return ""
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getBottomMetadataForProfileType(entity: PageMetadataEntity?) -> String {
        guard let entity = entity, let pageSubTypeString = entity.pageSubType else {
            return ""
        }
        let pageSubType = PageSubType(rawValue: pageSubTypeString) ?? PageSubType.other
        switch pageSubType {
            
        // Occupations
        case .star, .talent, .guest:
            guard let occupations = entity.occupations else {
                return ""
            }
            return occupations.map({ $0.getLocalizedString(languageConfigList: languageConfigList,
                                                           type: "occupations") ?? "" })
                .joined(separator: Constants.DefaultValue.MetadataOccupationSeparatorString)
        
        // Nick name and Occupations
        case .sportPlayer:
            var array = [String]()
            if let playerNickName = entity.playerNickName, !playerNickName.isEmpty {
                array.append(playerNickName)
            }
            
            if let occupations = entity.occupations {
                let occupationsStr = occupations.map({ $0.getLocalizedString(languageConfigList: languageConfigList,
                                                                             type: "occupations") ?? "" })
                    .joined(separator: Constants.DefaultValue.MetadataOccupationSeparatorString)
                if occupationsStr.length > 0 {
                    array.append(occupationsStr)
                }
            }
            
            return array.map({ "\($0)" }).joined(separator: Constants.DefaultValue.MetadataSeparatorString)
        
        // Nick name and Established Year
        case .sportTeam:
            var array = [String]()
            if let playerNickName = entity.playerNickName, !playerNickName.isEmpty {
                array.append(playerNickName)
            }
            if let establishedYear = entity.establishedYear {
                // swiftlint:disable:next line_length
                array.append("\(R.string.localizable.pagedetailHeaderEstablishedYearSportTeam()) \(establishedYear.year)")
            }
            return array.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
            
        // Established Year
        case .band:
            guard let establishedYear = entity.establishedYear else {
                return ""
            }
            return "\(R.string.localizable.pagedetailHeaderEstablishedYearBand()) \(establishedYear.year)"
        
        default:
            return ""
        }
    }
    
    private func getBottomMetadataForChannelType(entity: PageMetadataEntity?) -> String {
        // Channel Name and Genre
        var array = [String]()
        if let channelName = entity?.channelName, !channelName.isEmpty {
            array.append(channelName)
        }
        if let genres = entity?.genres {
            array.append(genres.joined(separator: Constants.DefaultValue.InforTabMetadataGenreSeparatorString))
        }
        return array.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
    }
	
	private func getRadioChannelInfo(entity: PageMetadataEntity) {
		self.appStore = entity.appStore
		self.googlePlay = entity.googlePlay
		if let frequencies = entity.frequencyChannels {
			self.frequencyChannels = frequencies.map { FrequencyChannel(entity: $0) }
		}
		if let networks = entity.socialNetworks {
			if socialNetworks == nil { socialNetworks = [] }
			filterSocialPriority(socials: networks).forEach { socialNetworks?.append(SocialNetwork(entity: $0)) }
			if let appStore = entity.appStore {
				let appStoreSocial = SocialNetworkEntity(accountId: appStore,
														 socialNetworkName: SocialNetworkEnum.apple.rawValue)
				socialNetworks?.append(SocialNetwork(entity: appStoreSocial))
			}
		}
		if let subChannels = entity.radioSubChannels {
			self.radioSubChannels = subChannels.map { RadioSubChannel(entity: $0) }
		}
	}
	
	private func filterSocialPriority(socials: [SocialNetworkEntity]) -> [SocialNetworkEntity] {
		var socialPriority = [SocialNetworkEntity]()
		socials.forEach {
			if let socialType = SocialNetworkEnum(rawValue: $0.socialNetworkName), socialType == .facebook
				|| socialType == .twitter || socialType == .instagram { socialPriority.append($0) }
		}
		if socialPriority.count < Constants.DefaultValue.numberOfSocialPriority {
			var counter = socialPriority.count
			socials.forEach {
				if let socialType = SocialNetworkEnum(rawValue: $0.socialNetworkName),
					socialType != .facebook && socialType != .twitter && socialType != .instagram
					&& counter < Constants.DefaultValue.numberOfSocialPriority {
					socialPriority.append($0)
					counter += 1
				}
			}
		}
		return socialPriority
	}
    
    private enum CodingKeys: String, CodingKey {
        case entityId
        case coverThumbnail
        case posterThumbnail
		case logoThumbnail
        case title
        case topMetadata
        case bottomMetadata
        case pageSettings
        case metadataJsonString
        case venueAddress
        case type
        case subType
        case languageConfigList
        case language
        case genres
        case universalUrl
        case promoVideo
        case seasonNumber
		case appStore
		case googlePlay
		case frequencyChannels
		case socialNetworks
		case radioSubChannels
        case airTimeInformation
        case geoTargeting
        case geoSuggestions
        case bundles
    }
    
    // MARK: Encodable
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entityId, forKey: .entityId)
        try container.encode(coverThumbnail, forKey: .coverThumbnail)
        try container.encode(posterThumbnail, forKey: .posterThumbnail)
		try container.encode(logoThumbnail, forKey: .logoThumbnail)
        try container.encode(title, forKey: .title)
        try container.encode(topMetadata, forKey: .topMetadata)
        try container.encode(bottomMetadata, forKey: .bottomMetadata)
        try container.encode(pageSettings, forKey: .pageSettings)
        try container.encode(metadataJsonString, forKey: .metadataJsonString)
        try container.encode(type, forKey: .type)
        try container.encode(subType, forKey: .subType)
        try container.encode(languageConfigList, forKey: .languageConfigList)
        try container.encode(language, forKey: .language)
        try container.encode(genres, forKey: .genres)
        try container.encode(universalUrl, forKey: .universalUrl)
        try container.encode(promoVideo, forKey: .promoVideo)
        try container.encode(seasonNumber, forKey: .seasonNumber)
		try container.encode(appStore, forKey: .appStore)
		try container.encode(googlePlay, forKey: .googlePlay)
		try container.encode(frequencyChannels, forKey: .frequencyChannels)
		try container.encode(socialNetworks, forKey: .socialNetworks)
		try container.encode(radioSubChannels, forKey: .radioSubChannels)
        try container.encode(airTimeInformation, forKey: .airTimeInformation)
        try container.encode(geoTargeting, forKey: .geoTargeting)
        try container.encode(geoSuggestions, forKey: .geoSuggestions)
        try container.encode(bundles, forKey: .bundles)
    }
    
    // MARK: Decodable
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entityId = try container.decode(String.self, forKey: .entityId)
        coverThumbnail = try container.decode(String.self, forKey: .coverThumbnail)
        posterThumbnail = try container.decode(String.self, forKey: .posterThumbnail)
		logoThumbnail = try container.decode(String.self, forKey: .logoThumbnail)
        title = try container.decode(String.self, forKey: .title)
        topMetadata = try container.decode(String.self, forKey: .topMetadata)
        bottomMetadata = try container.decode(String.self, forKey: .bottomMetadata)
        pageSettings = try container.decode(PageSettings.self, forKey: .pageSettings)
        metadataJsonString = try container.decode(String?.self, forKey: .metadataJsonString)
        if let jsonData = metadataJsonString?.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) {
            metadata = json as? [String: Any?]
        }
        type = try container.decode(String.self, forKey: .type)
        subType = try container.decode(String?.self, forKey: .subType)
        languageConfigList = try container.decode([LanguageConfigListEntity].self, forKey: .languageConfigList)
        pageAboutTab = PageAboutTab(type: type, subType: subType, metadata: metadata,
                                    languageConfigList: languageConfigList)
        language = try container.decode(String?.self, forKey: .language)
        genres = try container.decode([String]?.self, forKey: .genres)
        universalUrl = try container.decode(String.self, forKey: .universalUrl)
        promoVideo = try container.decode(Video?.self, forKey: .promoVideo)
        seasonNumber = try container.decode(String?.self, forKey: .seasonNumber)
		appStore = try container.decode(String?.self, forKey: .appStore)
		googlePlay = try container.decode(String?.self, forKey: .googlePlay)
		frequencyChannels = try container.decode([FrequencyChannel]?.self, forKey: .frequencyChannels)
		socialNetworks = try container.decode([SocialNetwork]?.self, forKey: .socialNetworks)
		radioSubChannels = try container.decode([RadioSubChannel]?.self, forKey: .radioSubChannels)
        airTimeInformation = try container.decode([AirTimeInformation]?.self, forKey: .airTimeInformation)
        geoTargeting = try container.decode(String.self, forKey: .geoTargeting)
        geoSuggestions = try container.decode([String].self, forKey: .geoSuggestions)
        bundles = try container.decode([BundleContent].self, forKey: .bundles)
    }
}
