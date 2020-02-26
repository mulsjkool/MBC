//
//  PageAboutTab.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

enum PageAboutRow: String {
    case metadata
    case location
    case about
    case socialNetworks
    case infoComponent
}

enum LinkedTypeEnum: String {
    case etablishYear = "ETABLISH_YEAR"
    case dob = "DOB"
    case character = "CHARACTER"
    case genre = "GENRE"
    case horoscope = "HOROSCOPE"
    case nationality = "NATIONALITY"
    case occupation = "OCCUPATION"
    case occupations = "OCCUPATIONS"
    case title = "TITLE"
    case seasonNumber = "SEASON_NUMBER"
    case sequelNumber = "SEQUEL_NUMBER"
    case subGenre = "SUB_GENRE"
}

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
class PageAboutTab {
    var metadata: [[String: String]]?
    var location: String?
    var about: PageInforAbout?
    var socialNetworks: [SocialNetwork]?
    var tabName: String?
    
    // swiftlint:disable:next cyclomatic_complexity
    init(type: String, subType: String?, metadata: [String: Any?]?, languageConfigList: [LanguageConfigListEntity]) {
        guard let metadataDict = metadata else {
            return
        }
        
        let pageType = PageType(rawValue: type) ?? PageType.other
        switch pageType {
        case .award:
            getDataForAwardType(metadataDict: metadataDict, languageConfigList: languageConfigList)
            if let pageInforAbout = about {
                tabName = pageInforAbout.title
            }
        case .business:
            getDataForBusinessType(metadataDict: metadataDict, languageConfigList: languageConfigList)
            tabName = R.string.localizable.abouttabTabnameBusiness().localized()
        case .section:
            getDataForSectionType(metadataDict: metadataDict)
            tabName = R.string.localizable.abouttabTabnameSection().localized()
        case .channel:
            getDataForChannelType(metadataDict: metadataDict, languageConfigList: languageConfigList)
            if let pageInforAbout = about {
                tabName = pageInforAbout.title
            }
        case .events:
            getDataForEventType(metadataDict: metadataDict, pageSubType: subType,
                                languageConfigList: languageConfigList)
            tabName = R.string.localizable.abouttabTabnameEvent().localized()
        case .profile:
            getDataForProfileType(metadataDict: metadataDict, pageSubType: subType,
                                  languageConfigList: languageConfigList)
            if let pageInforAbout = about {
                tabName = pageInforAbout.title
            }
        case .show:
            getDataForShowType(metadataDict: metadataDict, pageSubType: subType, languageConfigList: languageConfigList)
            if let pageSubTypeStr = subType, let pageSubType = PageShowSubType(rawValue: pageSubTypeStr) {
                switch pageSubType {
                case .movie:
                    tabName = R.string.localizable.abouttabTabnameShowMovie().localized()
                case .news:
                    tabName = R.string.localizable.abouttabTabnameShowNews().localized()
                case .play:
                    tabName = R.string.localizable.abouttabTabnameShowPlay().localized()
                case .match:
                    tabName = R.string.localizable.abouttabTabnameShowMatch().localized()
                case .program:
                    tabName = R.string.localizable.abouttabTabnameShowProgram().localized()
                case .series:
                    tabName = R.string.localizable.abouttabTabnameShowSeries().localized()
                default:
                    tabName = nil
                }
            }
        case .other:
            return
        }
    }
    
    // MARK: Private functions
    
    private enum AwardFieldEnum: String {
        case title
        case about
    }
    
    private let awardTitleLocalizations = [
        "title": R.string.localizable.abouttabAwardTitle().localized()
    ]
    
    private func getDataForAwardType(metadataDict: [String: Any?], languageConfigList: [LanguageConfigListEntity]) {
        var metaData = [[String: String]]()
        var about: String?
        
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = AwardFieldEnum(rawValue: key) else {
                continue
            }
            switch field {
            case .about:
                about = handleStringData(value: value)
            case .title:
                if let valueStr = handleDataWithLocalizationFromApi(
                    value: value, languageConfigList: languageConfigList, type: key) {
                    metaData.append([awardTitleLocalizations[key]!: valueStr])
                }
            }
        }
        
        if !metaData.isEmpty {
            self.metadata = metaData
        }
        if let aboutText = about {
            self.about = PageInforAbout(title: R.string.localizable.abouttabAwardAbout().localized(),
                                        aboutText: aboutText)
        }
    }
    
    private enum BusinessFieldEnum: String {
        case name
        case founded
        case industry
        case subIndustry
        case companyWebsite
        case hqCountry
        case country
        case city
        case about
        case socialNetwork
    }
    
    private let businessTitleLocalizations = [
        "name": R.string.localizable.abouttabName().localized(),
        "founded": R.string.localizable.abouttabFounded().localized(),
        "industry": R.string.localizable.abouttabIndustry().localized(),
        "subIndustry": R.string.localizable.abouttabSubindustry().localized(),
        "companyWebsite": R.string.localizable.abouttabCompanywebsite().localized(),
        "hqCountry": R.string.localizable.abouttabHqcountry().localized(),
        "country": R.string.localizable.abouttabCountry().localized(),
        "city": R.string.localizable.abouttabCity().localized()
    ]
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getDataForBusinessType(metadataDict: [String: Any?], languageConfigList: [LanguageConfigListEntity]) {
        var metaData = [[String: String]]()
        var about: String?
        var socialNetworks = [SocialNetwork]()
        
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = BusinessFieldEnum(rawValue: key) else {
                continue
            }
            switch field {
            case .about:
                about = handleStringData(value: value)
            case .hqCountry, .country:
                if let valueStr = handleDataWithLocalizationFromApi(
                    value: value, languageConfigList: languageConfigList, type: key) {
                    metaData.append([businessTitleLocalizations[key]!: valueStr])
                }
            case .founded:
                if let valueStr = handleDateData(value: value,
                                                inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                outputDateFormat: Constants.DateFormater.YearOnly) {
                    metaData.append([businessTitleLocalizations[key]!: valueStr])
                }
            case .socialNetwork:
                if let array = handleSocialNetworksData(value: value) {
                    socialNetworks.append(contentsOf: array)
                }
            case .industry, .subIndustry:
                if let valueStr = handleDataWithLocalizationFromApi(
                    value: value, languageConfigList: languageConfigList, type: key) {
                    metaData.append([businessTitleLocalizations[key]!: valueStr])
                }
            case .name, .companyWebsite, .city:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([businessTitleLocalizations[key]!: valueStr])
                }
            }
        }
        
        if !metaData.isEmpty {
            self.metadata = metaData
        }
        if let aboutText = about {
            self.about = PageInforAbout(title: R.string.localizable.abouttabBusinessAbout().localized(),
                                        aboutText: aboutText)
        }
        if !socialNetworks.isEmpty {
            self.socialNetworks = socialNetworks
        }
    }
    
    private enum SectionFieldEnum: String {
        case title
        case about
        case email
        case website
        case socialNetwork
    }
    
    private let sectionTitleLocalizations = [
        "title": R.string.localizable.abouttabTitle().localized(),
        "about": R.string.localizable.abouttabSectionAbout().localized(),
        "email": R.string.localizable.abouttabEmail().localized(),
        "website": R.string.localizable.abouttabCompanywebsite().localized()
    ]
    
    private func getDataForSectionType(metadataDict: [String: Any?]) {
        var metaData = [[String: String]]()
        var about: String?
        var socialNetworks = [SocialNetwork]()
        
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = SectionFieldEnum(rawValue: key) else {
                continue
            }
            switch field {
            case .about:
                about = handleStringData(value: value)
            case .socialNetwork:
                if let array = handleSocialNetworksData(value: value) {
                    socialNetworks.append(contentsOf: array)
                }
            case .title, .email, .website:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([sectionTitleLocalizations[key]!: valueStr])
                }
            }
        }
        
        if !metaData.isEmpty {
            self.metadata = metaData
        }
        if let aboutText = about {
            self.about = PageInforAbout(title: R.string.localizable.abouttabSectionAbout().localized(),
                                        aboutText: aboutText)
        }
        if !socialNetworks.isEmpty {
            self.socialNetworks = socialNetworks
        }
    }
    
    private enum ChannelFieldEnum: String {
        case channelName
        case regionList
        case about
        case channelFrequency
        case genre
        case language
        case channelShortName
        case socialNetwork
    }
    
    private let channelTitleLocalizations = [
        "channelName": R.string.localizable.abouttabChannelname().localized(),
        "regionList": R.string.localizable.abouttabRegions().localized(),
        "channelFrequency": R.string.localizable.abouttabChannelfrequency().localized(),
        "genre": R.string.localizable.abouttabGenre().localized(),
        "language": R.string.localizable.abouttabLanguage().localized()
    ]
    
    // swiftlint:disable function_body_length
    // swiftlint:disable:next cyclomatic_complexity
    private func getDataForChannelType(metadataDict: [String: Any?], languageConfigList: [LanguageConfigListEntity]) {
        var metaData = [[String: String]]()
        var about: String?
        var socialNetworks = [SocialNetwork]()
        var channelShortName: String?
        
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = ChannelFieldEnum(rawValue: key) else {
                continue
            }
            switch field {
            case .about:
                about = handleStringData(value: value)
            case .channelName:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([channelTitleLocalizations[key]!: valueStr])
                }
            case .channelShortName:
                channelShortName = handleStringData(value: value)
            case .socialNetwork:
                if let array = handleSocialNetworksData(value: value) {
                    socialNetworks.append(contentsOf: array)
                }
            case .language:
                if let valueStr = handleDataWithLocalizationFromApi(
                    value: value, languageConfigList: languageConfigList, type: key) {
                    metaData.append([channelTitleLocalizations[key]!: valueStr])
                }
            case .regionList, .genre:
                guard let array = value as? [String], !array.isEmpty else {
                    continue
                }
                var languageConfigKey = key
                if field == .genre {
                    languageConfigKey = Constants.ConfigurationDataType.genres
                }
                let strings = array.map({
                    return handleDataWithLocalizationFromApi(value: $0,
                                                             languageConfigList: languageConfigList,
                                                             type: languageConfigKey) ?? "" })
                metaData.append([channelTitleLocalizations[key]!:
                    strings.joined(separator: Constants.DefaultValue.InforTabMetadataSeparatorString)])
            case .channelFrequency:
                var tempArray = [String]()
                guard let array = value as? [[String: String]] else {
                    continue
                }
                for dict in array {
                    if let channelFrequency = dict[ChannelFieldEnum.channelFrequency.rawValue] {
                        tempArray.append(channelFrequency)
                    }
                }
                if !tempArray.isEmpty {
                    metaData.append([channelTitleLocalizations[key]!: tempArray.map({ "\($0)" })
                        .joined(separator: Constants.DefaultValue.InforTabMetadataGenreSeparatorString)])
                }
            }
        }
    
        if let channelShortName = channelShortName {
            var index = 0
            for var dict in metaData {
                if let channelName = dict[channelTitleLocalizations[ChannelFieldEnum.channelName.rawValue]!] {
                    let channelAndChannelShortName = "\(channelName) (\(channelShortName))"
                    dict = [channelTitleLocalizations[ChannelFieldEnum.channelName.rawValue]!:
                        channelAndChannelShortName]
                    metaData[index] = dict
                    break
                }
                index += 1
            }
        }
        if !metaData.isEmpty {
            self.metadata = metaData
        }
        if let aboutText = about {
            self.about = PageInforAbout(title: R.string.localizable.abouttabChannelAbout().localized(),
                                        aboutText: aboutText)
        }
        if !socialNetworks.isEmpty {
            self.socialNetworks = socialNetworks
        }
    }
    
    private enum EventFieldEnum: String {
        case eventType
        case eventName
        case eventSeasonTitle
        case eventSeason
        case eventYear
        case liveRecorded
        case startDate
        case endDate
        case time
        case country
        case city
        case venueName
        case venueSize
        case venueAddress
        case aboutEvent
        case eventPhone
        case eventEmail
        case eventWebsite
        case socialNetwork
    }
    
    private let eventTitleLocalizations = [
        "eventType": R.string.localizable.abouttabEventtype().localized(),
        "eventName": R.string.localizable.abouttabEventname().localized(),
        "eventSeasonTitle": R.string.localizable.abouttabEventseasontitle().localized(),
        "eventSeason": R.string.localizable.abouttabSeason().localized(),
        "eventYear": R.string.localizable.abouttabEventyear().localized(),
        "liveRecorded": R.string.localizable.abouttabLiveRecorded().localized(),
        "startDate": R.string.localizable.abouttabStartdate().localized(),
        "endDate": R.string.localizable.abouttabEnddate().localized(),
        "time": R.string.localizable.abouttabTime().localized(),
        "country": R.string.localizable.abouttabEventCountry().localized(),
        "city": R.string.localizable.abouttabEventCity().localized(),
        "venueName": R.string.localizable.abouttabVenuename().localized(),
        "eventPhone": R.string.localizable.abouttabPhone().localized(),
        "eventEmail": R.string.localizable.abouttabEmail().localized(),
        "eventWebsite": R.string.localizable.abouttabEventwebsite().localized(),
        "venueSize": R.string.localizable.abouttabVenuesize().localized()
    ]
    
    private enum LiveRecorded: String {
        case live
        case recorded
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getDataForEventType(metadataDict: [String: Any?], pageSubType: String?,
                                     languageConfigList: [LanguageConfigListEntity]) {
        var metaData = [[String: String]]()
        var about: String?
        var socialNetworks = [SocialNetwork]()
        //var locationAddress: String?
        
        if let pageSubType = pageSubType, !pageSubType.isEmpty,
            let string = pageSubType.getLocalizedString(languageConfigList: languageConfigList,
                                                            type: Constants.ConfigurationDataType.eventsSubType) {
            metaData.append([eventTitleLocalizations[EventFieldEnum.eventType.rawValue]!: string])
        }
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = EventFieldEnum(rawValue: key) else {
                continue
            }
            
            switch field {
            case .aboutEvent:
                about = handleStringData(value: value)
            case .eventName, .eventSeasonTitle, .city, .venueName, .eventPhone, .eventEmail, .eventWebsite, .venueSize:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([eventTitleLocalizations[key]!: valueStr])
                }
            case .eventSeason:
                if let valueStr = handleStringData(value: value) {
                    // swiftlint:disable:next line_length
                    let localizedStr = (valueStr == "1") ? "\(R.string.localizable.abouttabFirst().localized())" : "\(valueStr)"
                     metaData.append([eventTitleLocalizations[key]!: localizedStr])
                }
            case .socialNetwork:
                if let array = handleSocialNetworksData(value: value) {
                    socialNetworks.append(contentsOf: array)
                }
            case .eventYear:
                if let valueStr = handleDateData(value: value,
                                                  inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                  outputDateFormat: Constants.DateFormater.YearOnly) {
                    metaData.append([eventTitleLocalizations[key]!: valueStr])
                }
            case .liveRecorded:
                if let liveRecorded = handleStringData(value: value) {
                    if liveRecorded == LiveRecorded.live.rawValue {
                        metaData.append([eventTitleLocalizations[key]!:
                            R.string.localizable.abouttabLive().localized()])
                    } else if liveRecorded == LiveRecorded.recorded.rawValue {
                        metaData.append([eventTitleLocalizations[key]!:
                            R.string.localizable.abouttabRecorded().localized()])
                    }
                }
            case .startDate, .endDate:
                if let valueStr = handleDateData(value: value,
                                                inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                outputDateFormat: Constants.DateFormater.DateMonthYear) {
                    metaData.append([eventTitleLocalizations[key]!: valueStr])
                }
            case .time:
                if let valueStr = handleArrayData(value: value,
                                              separator: Constants.DefaultValue.InforTabMetadataSeparatorString) {
                    metaData.append([eventTitleLocalizations[key]!: valueStr.uppercased()])
                }
            case .country:
                if let valueStr = handleStringData(value: value),
                    let localizedStr = valueStr.getLocalizedString(languageConfigList: languageConfigList, type: key) {
                    metaData.append([eventTitleLocalizations[key]!: localizedStr])
                }
//            case .venueAddress:
//                locationAddress = handleStringData(value: value)
            default:
                continue
            }
        }
        
        if !metaData.isEmpty {
            self.metadata = metaData
        }
//        if let locationAddress = locationAddress {
//            self.location = locationAddress
//        }
        if let aboutText = about {
            self.about = PageInforAbout(title: R.string.localizable.abouttabEventAbout().localized(),
                                        aboutText: aboutText)
        }
        if !socialNetworks.isEmpty {
            self.socialNetworks = socialNetworks
        }
    }
    
    private enum ProfileFieldEnum: String {
        case fullName
        case title
        case occupations
        case dateOfBirth
        case ripDate
        case age
        case nationalities
        case city
        case gender
        case horoscope
        case realName
        case about
        case socialNetwork
        case playerNickName
        case weight
        case height
        case skillLevel
        case sportType
        case votingNumber
        case establishedYear
        case sportTypes
        case sportTeam
        case stadiumGPS
        case stadiumName
        case coachName
        case captainName
        case musicType
        case country
        case hideYearAndAge
    }
    
    private let profileTitleLocalizations = [
        "fullName": R.string.localizable.abouttabFullname().localized(),
        "title": R.string.localizable.abouttabArtistictitle().localized(),
        "occupations": R.string.localizable.abouttabOccupation().localized(),
        "dateOfBirth": R.string.localizable.abouttabDateofbirth().localized(),
        "ripDate": R.string.localizable.abouttabRipdate().localized(),
        "age": R.string.localizable.abouttabAge().localized(),
        "nationalities": R.string.localizable.abouttabNationality().localized(),
        "city": R.string.localizable.abouttabCity().localized(),
        "gender": R.string.localizable.abouttabGender().localized(),
        "horoscope": R.string.localizable.abouttabHoroscope().localized(),
        "realName": R.string.localizable.abouttabRealname().localized(),
        "playerNickName": R.string.localizable.abouttabPlayernickname().localized(),
        "weight": R.string.localizable.abouttabWeight().localized(),
        "height": R.string.localizable.abouttabHeight().localized(),
        "skillLevel": R.string.localizable.abouttabSkilllevel().localized(),
        "sportType": R.string.localizable.abouttabSporttype().localized(),
        "votingNumber": R.string.localizable.abouttabVotingnumber().localized(),
        "establishedYear": R.string.localizable.abouttabYearestablished().localized(),
        "sportTypes": R.string.localizable.abouttabSporttype().localized(),
        "sportTeam": R.string.localizable.abouttabSportteamtype().localized(),
        "stadiumName": R.string.localizable.abouttabStadiumname().localized(),
        "coachName": R.string.localizable.abouttabCoachname().localized(),
        "captainName": R.string.localizable.abouttabTeamcaptainname().localized(),
        "musicType": R.string.localizable.abouttabMusictype().localized(),
        "country": R.string.localizable.abouttabShowPlaceOfResidence().localized()
    ]
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getDataForProfileType(metadataDict: [String: Any?], pageSubType: String?,
                                       languageConfigList: [LanguageConfigListEntity]) {
        var metaData = [[String: String]]()
        var about: String?
        var aboutAreaTitle = ""
        var socialNetworks = [SocialNetwork]()
        //var locationAddress: String?
        var country: String?
        var city: String?
        
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = ProfileFieldEnum(rawValue: key) else {
                continue
            }
            switch field {
            case .about:
                about = handleStringData(value: value)
                if let pageSubType = pageSubType, let subType = PageProfileSubType(rawValue: pageSubType) {
                    if subType == .sportTeam {
                        aboutAreaTitle = R.string.localizable.abouttabProfilesportteamAbout().localized()
                    } else if subType == .band {
                        aboutAreaTitle = R.string.localizable.abouttabProfilebandAbout().localized()
                    }
                }
            case .city:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([profileTitleLocalizations[key]!: valueStr])
                    city = valueStr
                }
            case .country:
                if let valueStr = handleStringData(value: value),
                    let localizedStr = valueStr.getLocalizedString(languageConfigList: languageConfigList, type: key) {
                    metaData.append([profileTitleLocalizations[key]!: localizedStr])
                    country = localizedStr
                }
            case .fullName, .title, .horoscope, .realName, .playerNickName, .weight, .height,
                 .stadiumName, .coachName, .captainName:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([profileTitleLocalizations[key]!: valueStr])
                }
            case .age:
                if let age = value as? Int {
                    var hideYearAndAge = false
                    if let hideYearAndAgeValue = metadataDict[ProfileFieldEnum.hideYearAndAge.rawValue] as? Bool {
                        hideYearAndAge = hideYearAndAgeValue
                    }
                    if !hideYearAndAge {
                        metaData.append([profileTitleLocalizations[key]!: "\(age)"])
                    }
                }
            case .votingNumber:
                if let age = value as? Int {
                    metaData.append([profileTitleLocalizations[key]!: "\(age)"])
                }
            case .sportTeam:
                if let sportTeam = handleStringData(value: value) {
                    if sportTeam == SportTeamTypeEnum.nationalTeam.rawValue {
                        metaData.append([profileTitleLocalizations[key]!:
                            R.string.localizable.abouttabNationalTeam().localized()])
                    } else if sportTeam == SportTeamTypeEnum.clubTeam.rawValue {
                        metaData.append([profileTitleLocalizations[key]!:
                            R.string.localizable.abouttabClubTeam().localized()])
                    }
                }
            case .socialNetwork:
                if let array = handleSocialNetworksData(value: value) {
                    socialNetworks.append(contentsOf: array)
                }
            case .dateOfBirth:
                var hideYearAndAge = false
                if let hideYearAndAgeValue = metadataDict[ProfileFieldEnum.hideYearAndAge.rawValue] as? Bool {
                    hideYearAndAge = hideYearAndAgeValue
                }
                if !hideYearAndAge {
                    if let valueStr = handleDateData(value: value,
                                                     inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                     outputDateFormat: Constants.DateFormater.DateMonthYear) {
                        metaData.append([profileTitleLocalizations[key]!: valueStr])
                    }
                } else {
                    if let valueStr = handleDateData(value: value,
                                                     inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                     outputDateFormat: Constants.DateFormater.DateMonth) {
                        metaData.append([profileTitleLocalizations[key]!: valueStr])
                    }
                }
            case .ripDate:
                if let valueStr = handleDateData(value: value,
                                                inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                outputDateFormat: Constants.DateFormater.DateMonthYear) {
                    metaData.append([profileTitleLocalizations[key]!: valueStr])
                }
            case .sportType, .skillLevel, .musicType:
                if let valueStr = handleDataWithLocalizationFromApi(value: value,
                                                                languageConfigList: languageConfigList, type: key) {
                    metaData.append([profileTitleLocalizations[key]!: valueStr])
                }
            case .establishedYear:
                if let valueStr = handleDateData(value: value,
                                                inputDateFormat: Constants.DateFormater.StandardWithMilisecond,
                                                outputDateFormat: Constants.DateFormater.YearOnly) {
                   metaData.append([profileTitleLocalizations[key]!: valueStr])
                }
            case .occupations, .sportTypes, .nationalities:
                guard let array = value as? [String], !array.isEmpty else {
                    continue
                }
                let strings = array.map({
                    return handleDataWithLocalizationFromApi(value: $0,
                                                             languageConfigList: languageConfigList,
                                                             type: key) ?? "" })
                metaData.append([profileTitleLocalizations[key]!: strings
                    .joined(separator: Constants.DefaultValue.InforTabMetadataSeparatorString)])
//            case .stadiumGPS:
//                if let string = handleStringData(value: value) {
//                    locationAddress = string
//                }
            case .gender:
                if let pageSubType = pageSubType, let subType = PageProfileSubType(rawValue: pageSubType),
                    let gender = handleStringData(value: value) {
                    
                    if gender == Gender.male.rawValue {
                        aboutAreaTitle = R.string.localizable.abouttabProfileAboutmale().localized()
                    } else if gender == Gender.female.rawValue {
                        aboutAreaTitle = R.string.localizable.abouttabProfileAboutfemale().localized()
                    }
                    
                    switch subType {
                    case .star:
                        if gender == Gender.male.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileStarMale().localized()])
                        } else if gender == Gender.female.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileStarFemale().localized()])
                        } else {
                            metaData.append([profileTitleLocalizations[key]!: gender])
                        }
                    case .sportPlayer:
                        if gender == Gender.male.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileSportPlayerMale().localized()])
                        } else if gender == Gender.female.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileSportPlayerFemale().localized()])
                        } else {
                            metaData.append([profileTitleLocalizations[key]!: gender])
                        }
                    case .guest:
                        if gender == Gender.male.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileGuestMale().localized()])
                        } else if gender == Gender.female.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileGuestFemale().localized()])
                        } else {
                            metaData.append([profileTitleLocalizations[key]!: gender])
                        }
                    case .talent:
                        if gender == Gender.male.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileTalentMale().localized()])
                        } else if gender == Gender.female.rawValue {
                            metaData.append([profileTitleLocalizations[key]!:
                                R.string.localizable.abouttabProfileTalentFemale().localized()])
                        } else {
                            metaData.append([profileTitleLocalizations[key]!: gender])
                        }
                    case .band:
                        metaData.append([profileTitleLocalizations[key]!:
                            R.string.localizable.abouttabProfileBandGender().localized()])
                    case .sportTeam:
                        metaData.append([profileTitleLocalizations[key]!:
                            R.string.localizable.abouttabProfileSportTeamGender().localized()])
                    default:
                        metaData.append([profileTitleLocalizations[key]!: gender])
                    }
                }
            default:
                break
            }
        }
        
        if country != nil {
            var index = 0
            for var dict in metaData {
                guard let countryStr = dict[profileTitleLocalizations[ProfileFieldEnum.country.rawValue]!] else {
                    index += 1
                    continue
                }
                
                if let city = city {
                    dict = [profileTitleLocalizations[ProfileFieldEnum.country.rawValue]!: "\(city), \(countryStr)"]
                } else {
                    dict = [profileTitleLocalizations[ProfileFieldEnum.country.rawValue]!: "\(countryStr)"]
                }
                metaData[index] = dict
                break
            }
            
            // Remove city
            if city != nil {
                var cityIndex = 0
                for var dict in metaData {
                    guard dict[profileTitleLocalizations[ProfileFieldEnum.city.rawValue]!] != nil else {
                        cityIndex += 1
                        continue
                    }
                    break
                }
                metaData.remove(at: cityIndex)
            }
        }
        
        if !metaData.isEmpty {
            self.metadata = metaData
        }
//        if let locationAddress = locationAddress {
//            self.location = locationAddress
//        }
        if let aboutText = about {
            self.about = PageInforAbout(title: aboutAreaTitle, aboutText: aboutText)
        }
        if !socialNetworks.isEmpty {
            self.socialNetworks = socialNetworks
        }
    }
    
    private enum ShowFieldEnum: String {
        case socialNetwork
        case englishTitle
        case arabicTitle
        case showLanguage
        case dialect
        case genre
        case censorshipClass
        case subtitlingDubbing
        case country
        case yearDebuted
        case sequelNumber
        case duration
        case about
        case seasonNumber
        case subGenre
        case liveRecorded
        case city
        case stadiumGPS
        case stadiumName
    }
    
    private let showTitleLocalizations = [
        "englishTitle": R.string.localizable.abouttabEnglishtitle().localized(),
        "arabicTitle": R.string.localizable.abouttabArabicTitle().localized(),
        "showLanguage": R.string.localizable.abouttabShowlanguage().localized(),
        "dialect": R.string.localizable.abouttabDialect().localized(),
        "genre": R.string.localizable.abouttabGenre().localized(),
        "censorshipClass": R.string.localizable.abouttabCensorshipClass().localized(),
        "subtitlingDubbing": R.string.localizable.abouttabSubtitlingDubbing().localized(),
        "country": R.string.localizable.abouttabMovieCountry().localized(),
        "yearDebuted": R.string.localizable.abouttabYearDebuted().localized(),
        "sequelNumber": R.string.localizable.abouttabSequelNumber().localized(),
        "duration": R.string.localizable.abouttabDuration().localized(),
        "seasonNumber": R.string.localizable.abouttabSeason().localized(),
        "liveRecorded": R.string.localizable.abouttabShowLiveRecorded().localized(),
        "city": R.string.localizable.abouttabCity().localized(),
        "stadiumName": R.string.localizable.abouttabStadiumname().localized()
    ]
    
    // swiftlint:disable:next cyclomatic_complexity
    private func getDataForShowType(metadataDict: [String: Any?], pageSubType: String?,
                                    languageConfigList: [LanguageConfigListEntity]) {
        var metaData = [[String: String]]()
        var about: String?
        var socialNetworks = [SocialNetwork]()
//        var locationAddress: String?
        var subGenre: String?
        
        for key in metadataDict.keys {
            guard let value = metadataDict[key], let field = ShowFieldEnum(rawValue: key) else {
                continue
            }
            switch field {
            case .about:
                about = handleStringData(value: value)
            case .englishTitle, .arabicTitle, .showLanguage, .censorshipClass, .subtitlingDubbing, .sequelNumber,
                .stadiumName, .seasonNumber:
                if let valueStr = handleStringData(value: value) {
                    metaData.append([showTitleLocalizations[key]!: valueStr])
                }
            case .yearDebuted:
                if let valueStr = value as? Int {
                    metaData.append([showTitleLocalizations[key]!: "\(valueStr)"])
                }
            case .duration:
                guard let valueStr = handleStringData(value: value) else {
                    continue
                }
                if let pageSubType = pageSubType, let subType = PageShowSubType(rawValue: pageSubType) {
                    switch subType {
                    case .movie:
                        metaData.append([R.string.localizable.abouttabDurationShowMovie().localized(): valueStr])
                    case .news:
                        metaData.append([R.string.localizable.abouttabDurationShowNew().localized(): valueStr])
                    case .play:
                        metaData.append([R.string.localizable.abouttabDurationShowPlay().localized(): valueStr])
                    case .match:
                        metaData.append([R.string.localizable.abouttabDurationShowMatch().localized(): valueStr])
                    default:
                        metaData.append([R.string.localizable.abouttabDuration().localized(): valueStr])
                    }
                }
            case .socialNetwork:
                if let array = handleSocialNetworksData(value: value) {
                    socialNetworks.append(contentsOf: array)
                }
            case .dialect, .genre:
                if let valueStr = handleDataWithLocalizationFromApi(value: value,
                                                                  languageConfigList: languageConfigList, type: key) {
                    metaData.append([showTitleLocalizations[key]!: valueStr])
                }
            case .country:
                guard let valueStr = handleStringData(value: value),
                    let localizedText = valueStr.getLocalizedString(languageConfigList: languageConfigList,
                                                                    type: key) else {
                    continue
                }
                if let pageSubType = pageSubType, let subType = PageShowSubType(rawValue: pageSubType) {
                    switch subType {
                    case .match, .play:
                        metaData.append([R.string.localizable.abouttabCountry().localized(): localizedText])
                    default:
                        metaData.append([R.string.localizable.abouttabMovieCountry().localized(): localizedText])
                    }
                }
            case .subGenre:
                if let valueStr = handleArrayData(value: value, separator:
                    Constants.DefaultValue.InforTabMetadataGenreSeparatorString) {
                    subGenre = valueStr
                }
            case .city:
                if let valueStr = handleArrayData(value: value, separator:
                    Constants.DefaultValue.InforTabMetadataGenreSeparatorString) {
                    metaData.append([showTitleLocalizations[key]!: valueStr])
                }
            case .liveRecorded:
                if let liveRecorded = handleStringData(value: value) {
                    if liveRecorded == LiveRecorded.live.rawValue {
                        metaData.append([showTitleLocalizations[key]!:
                            R.string.localizable.abouttabLive().localized()])
                    } else if liveRecorded == LiveRecorded.recorded.rawValue {
                        metaData.append([showTitleLocalizations[key]!:
                            R.string.localizable.abouttabRecorded().localized()])
                    }
                }
            case .stadiumGPS:
                break
//                if let string = handleStringData(value: value) {
//                    locationAddress = string
//                }
            }
        }
        
        if let subGenre = subGenre {
            var index = 0
            for var dict in metaData {
                if let genre = dict[showTitleLocalizations[ShowFieldEnum.genre.rawValue]!] {
                    let string = "\(genre), \(subGenre)"
                    dict = [showTitleLocalizations[ShowFieldEnum.genre.rawValue]!: string]
                    metaData[index] = dict
                    break
                }
                index += 1
            }
        }
        
        if !metaData.isEmpty {
            self.metadata = metaData
        }
//        if let locationAddress = locationAddress {
//            self.location = locationAddress
//        }
        if let aboutText = about {
            var aboutAreaTitle = ""
            if let pageSubType = pageSubType, let subType = PageShowSubType(rawValue: pageSubType) {
                switch subType {
                case .movie:
                    aboutAreaTitle = R.string.localizable.abouttabShowMovieAbout().localized()
                case .series:
                    aboutAreaTitle = R.string.localizable.abouttabShowSeriesAbout().localized()
                case .program:
                    aboutAreaTitle = R.string.localizable.abouttabShowProgramAbout().localized()
                case .news:
                    aboutAreaTitle = R.string.localizable.abouttabShowNewsAbout().localized()
                case .play:
                    aboutAreaTitle = R.string.localizable.abouttabShowPlayAbout().localized()
                case .match:
                    aboutAreaTitle = R.string.localizable.abouttabShowMatchAbout().localized()
                default:
                    aboutAreaTitle = ""
                }
            }
            
            self.about = PageInforAbout(title: aboutAreaTitle, aboutText: aboutText)
        }
        if !socialNetworks.isEmpty {
            self.socialNetworks = socialNetworks
        }
    }
    
    private func handleArrayData(value: Any?, separator: String) -> String? {
        if let array = value as? [String] {
            if !array.isEmpty {
                return array.joined(separator: separator)
            }
        }
        return nil
    }
    
    private func handleDictionaryData(value: Any?, key: String) -> String? {
        if let dict = value as? [String: Any?], let string = dict[key] as? String {
            return string
        }
        return nil
    }
    
    private func handleSocialNetworksData(value: Any?) -> [SocialNetwork]? {
        if let socialNetworksDict = value as? [[String: String?]] {
            var socialNetworks = [SocialNetwork]()
            for dict in socialNetworksDict {
                let socialNetwork = SocialNetwork(dictionary: dict)
                socialNetworks.append(socialNetwork)
            }
            return socialNetworks
        }
        return nil
    }
    
    private func handleDateData(value: Any?, inputDateFormat: String, outputDateFormat: String) -> String? {
        if let dateStr = value as? String {
            let date = Date.dateFromString(string: dateStr, format: inputDateFormat)
            return date.toDateString(format: outputDateFormat)
        }
        return nil
    }
    
    private func handleStringData(value: Any?) -> String? {
        if let valueStr = value as? String {
            return valueStr.isEmpty ? nil : valueStr
        }
        return nil
    }
    
    private let dataFields = (
        id: "id",
        raw: "raw",
        code: "code",
        names: "names"
    )
    
    private func handleDataWithLocalizationFromApi(
        value: Any?, languageConfigList: [LanguageConfigListEntity], type: String) -> String? {
        // If value is dictionary
        guard let dict = value as? [String: Any?],
            let rawDict = dict[dataFields.raw] as? [String: Any?],
            let code = rawDict[dataFields.code] as? String,
            let name = dict[dataFields.names] as? String else {
                
                // If value is string
                guard let stringValue = value as? String else {
                    return nil
                }
                
                if let localizedString = stringValue.getLocalizedString(languageConfigList: languageConfigList,
                                                                        type: type) {
                    return localizedString
                }
                return stringValue
        }
        
        if let localizedString = code.getLocalizedString(languageConfigList: languageConfigList, type: type) {
            return localizedString
        }
        
        // If value is not found, return data from page detail api
        return name
    }
}
