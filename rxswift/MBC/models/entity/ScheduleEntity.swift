//
//  ScheduleEntity.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class ScheduleEntity {
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
    var daily: Bool = false
    var channel: ChannelEntity?
    
    // show
    var showId: String?
    
    // channel
    var channelId: String
    var channelTitle: String
    var channelPublishedDate: Date?
    var channelLogo: String?
    
    init(showEntity: ShowEntity, channelType: String, defaultScheduler: Bool,
         label: String?, startTime: Date, endTime: Date, duration: String, channelId: String, channelTitle: String,
         channelPublishedDate: Date?, channelLogo: String?) {
        self.label = label
        self.showId = showEntity.id
        self.title = showEntity.title
        self.season = showEntity.season
        self.sequenceNumber = showEntity.sequenceNumber
    
        if let season = self.season, !season.isEmpty {
            self.season = ScheduleEntity.getConvertBCMSeuelOrSessonNumber(value: season, isSeasion: true)
        }
        
        if let sequenceNumber = self.sequenceNumber, !sequenceNumber.isEmpty {
            self.sequenceNumber = ScheduleEntity.getConvertBCMSeuelOrSessonNumber(value: sequenceNumber,
                                                                                  isSeasion: false)
        }
        
        if showEntity.genre.localeNamesAr.isEmpty && showEntity.genre.localeNamesEn.isEmpty {
            self.genre = showEntity.genre.defaultName
        } else {
            if Components.languageRepository.currentLanguageEnum() == LanguageEnum.arabic {
                self.genre = showEntity.genre.localeNamesAr
            } else {
                self.genre = showEntity.genre.localeNamesEn
            }
        }
        
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.channelType = channelType
        self.defaultScheduler = defaultScheduler
        
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.channelPublishedDate = channelPublishedDate
        self.channelLogo = channelLogo
    }
    
    convenience init(defaultScheduler: Bool, label: String?, startTime: Date, endTime: Date, daily: Bool,
                     channel: ChannelEntity?) {
        let genreShowEntity = GenreShowEntity(id: "", code: "", defaultName: "", localeNamesAr: "", localeNamesEn: "")
        let showEntity = ShowEntity(id: "", title: "", gender: nil, logo: "", season: nil, sequenceNumber: nil,
                                    about: "", poster: "", label: nil, genre: genreShowEntity)
        self.init(showEntity: showEntity, channelType: "", defaultScheduler: defaultScheduler, label: label,
                  startTime: startTime, endTime: endTime, duration: "", channelId: "", channelTitle: "",
                  channelPublishedDate: nil, channelLogo: nil )
        self.daily = daily
        self.channel = channel
    }
    
    private enum SequelOrSeasonNumbers: String {
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case ten = "10"
        case elevent = "11"
        case twelve = "12"
        case thirteen = "13"
        case fourteen = "14"
        case fifteen = "15"
        case sixteen = "16"
        case seventeen = "17"
        case eighteen = "18"
        case nineteen = "19"
        case twenty = "20"
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    static private func getConvertBCMSeuelOrSessonNumber(value: String, isSeasion: Bool) -> String {
        switch value {
        case SequelOrSeasonNumbers.one.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberOne() }
            return R.string.localizable.sequelNumberOne()
        case SequelOrSeasonNumbers.two.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberTwo() }
            return R.string.localizable.sequelNumberTwo()
        case SequelOrSeasonNumbers.three.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberThree() }
            return R.string.localizable.sequelNumberThree()
        case SequelOrSeasonNumbers.four.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberFour() }
            return R.string.localizable.sequelNumberFour()
        case SequelOrSeasonNumbers.five.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberFive() }
            return R.string.localizable.sequelNumberOne()
        case SequelOrSeasonNumbers.six.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberSix() }
            return R.string.localizable.sequelNumberSix()
        case SequelOrSeasonNumbers.seven.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberSeven() }
            return R.string.localizable.sequelNumberSeven()
        case SequelOrSeasonNumbers.eight.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberEight() }
            return R.string.localizable.sequelNumberEight()
        case SequelOrSeasonNumbers.nine.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberNine() }
            return R.string.localizable.sequelNumberNine()
        case SequelOrSeasonNumbers.ten.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberTen() }
            return R.string.localizable.sequelNumberTen()
        case SequelOrSeasonNumbers.elevent.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberElevent() }
            return R.string.localizable.sequelNumberElevent()
        case SequelOrSeasonNumbers.twelve.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberTwelve() }
            return R.string.localizable.sequelNumberTwelve()
        case SequelOrSeasonNumbers.thirteen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberThriteen() }
            return R.string.localizable.sequelNumberThriteen()
        case SequelOrSeasonNumbers.fourteen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberFourteen() }
            return R.string.localizable.sequelNumberFourteen()
        case SequelOrSeasonNumbers.fifteen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberFifteen() }
            return R.string.localizable.sequelNumberFifteen()
        case SequelOrSeasonNumbers.sixteen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberSixteen() }
            return R.string.localizable.sequelNumberSixteen()
        case SequelOrSeasonNumbers.seventeen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberSeventeen() }
            return R.string.localizable.sequelNumberSeventeen()
        case SequelOrSeasonNumbers.eighteen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberEighteen() }
            return R.string.localizable.sequelNumberEighteen()
        case SequelOrSeasonNumbers.nineteen.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberNineteen() }
            return R.string.localizable.sequelNumberNineteen()
        case SequelOrSeasonNumbers.twenty.rawValue:
            if isSeasion { return R.string.localizable.seasonNumberTwenty() }
            return R.string.localizable.sequelNumberTwelve()
        default:
            return value
        }
    }
}
