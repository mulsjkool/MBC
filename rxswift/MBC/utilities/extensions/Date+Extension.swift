//
//  NSDate+Extension.swift
//  ShiftMeApp
//
//  Created by Dao Le Quang on 12/22/15.
//  Copyright © 2015 Shift Me App. All rights reserved.
//

import Foundation

extension Date {
    
    static var nameOfDays: [String] {
        return [ R.string.localizable.dayOfWeekSun(), R.string.localizable.dayOfWeekMon(),
                 R.string.localizable.dayOfWeekTue(), R.string.localizable.dayOfWeekWed(),
                 R.string.localizable.dayOfWeekThu(), R.string.localizable.dayOfWeekFri(),
                 R.string.localizable.dayOfWeekSat()]
    }
    
    var milliseconds: Double {
        return self.timeIntervalSince1970 * 1000
    }

    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    func getIndexInWeek() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    func getNameOfDays() -> [String] {
        let dayIndex = self.getIndexInWeek() - 1
        let count = Date.nameOfDays.count
        var days = [String]()
        for index in dayIndex..<count { days.append(Date.nameOfDays[index % count]) }
        return days
    }
    
    func getNameOfDay() -> String {
        let dayIndex = self.getIndexInWeek() - 1
        return Date.nameOfDays[dayIndex]
    }

    func getDatesInAWeek() -> [Date] {
        return self.makeArrayDateWith(numOfDays: 7)
    }
    
    func get8Dates() -> [Date] {
        return self.makeArrayDateWith(numOfDays: 8)
    }
    
    private func makeArrayDateWith(numOfDays: Int) -> [Date] {
        var dates = [Date]()
        let startOfDay = self.startOfDay
        for index in 0..<numOfDays {
            if let date = Date.addDaysFrom(currentDate: startOfDay, count: index) { dates.append(date) }
        }
        return dates
    }
    
    static func addMinuteFrom(currrentDate: Date, minutes: Int) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: minutes, to: currrentDate)
    }
    
    static func addDaysFrom(currentDate: Date, count: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = count
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        return futureDate
    }
    
    static func dateFromString(string: String, format: String, UTCTime: Bool = true) -> Date {
        var date = Date(timeIntervalSince1970: 0)
        do {
            date = try Date.parseDateFrom(string: string, format: format, UTCTime: UTCTime)
        } catch _ {
            debugPrint("Parse time error : \(string)")
        }
        return date
    }
	
	static func dateFromTimestamp(miniSecond: Int) -> Date {
		return Date(timeIntervalSince1970: Double(miniSecond))
	}

    static func dateFromTimestamp(miniSecond: Double) -> Date {
        return Date(timeIntervalSince1970: miniSecond / 1000)
    }
    
    static func parseDateFrom(string: String, format: String = "yyyyMMdd HH:mm", UTCTime: Bool = true) throws -> Date {
        guard string.length > 0 else { throw DateConvertingError.emptyInput }
        guard format.length > 0 else { throw DateConvertingError.invalidFormat }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        if UTCTime {
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
        }
        
        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            throw DateConvertingError.invalidFormat
        }
    }
    
    static func dateWith(day: Int, month: Int, year: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }

    func dateFrom(hour: Int = NSNotFound, minute: Int = NSNotFound, second: Int = NSNotFound,
                  UTCTime: Bool = false) -> Date {
        var myCalendar = Calendar(identifier: .gregorian)
        if let timeZone = TimeZone(secondsFromGMT: 0), UTCTime {
            myCalendar.timeZone = timeZone
        }
        var components = myCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = hour == NSNotFound ? self.hour : hour
        components.minute = minute == NSNotFound ? self.minute : minute
        components.second = second == NSNotFound ? self.second: second

        return myCalendar.date(from: components)!
    }

    func isGreaterThanDate(dateToCompare: Date, dateOnly: Bool = false) -> Bool {
        let date1 = dateOnly ? self.dateFrom(hour: 0, minute: 0, second: 0) : self
        let date2 = dateOnly ? dateToCompare.dateFrom(hour: 0, minute: 0, second: 0) : dateToCompare

        //Declare Variables
        var isGreater = false

        //Compare Values
        if date1.compare(date2) == .orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(dateToCompare: Date, dateOnly: Bool = false) -> Bool {
        let date1 = dateOnly ? self.dateFrom(hour: 0, minute: 0, second: 0) : self
        let date2 = dateOnly ? dateToCompare.dateFrom(hour: 0, minute: 0, second: 0) : dateToCompare

        var isLess = false
        if date1.compare(date2) == .orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare) == .orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }

    var hour: Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let minute = myCalendar.component(.hour, from: self)
        return minute
    }

    var minute: Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let minute = myCalendar.component(.minute, from: self)
        return minute
    }

    var second: Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let minute = myCalendar.component(.second, from: self)
        return minute
    }
    
    var year: Int {
        let myCalendar = Calendar(identifier: .gregorian)
        return myCalendar.component(.year, from: self)
    }
    
    var month: Int {
        let myCalendar = Calendar(identifier: .gregorian)
        return myCalendar.component(.month, from: self)
    }
    
    var day: Int {
        let myCalendar = Calendar(identifier: .gregorian)
        return myCalendar.component(.day, from: self)
    }
    
    var time: Time {
        return Time(self)
    }
    
    func toDateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func getCardTimestamp() -> String {
        let timeInterval = Date().timeIntervalSince(self)
    
        // 1 - 59 seconds
        if timeInterval < 60 {
           return R.string.localizable.commonTimestampRightnow().localized()
        }
        // 1 minute
        if timeInterval < (60 * 2) {
            return R.string.localizable.commonTimestampAMinute().localized()
        }
        // 2 minutes
        if timeInterval < (60 * 3) {
            return R.string.localizable.commonTimestamp2Minutes().localized()
        }
        // 3 - 10 minutes
        if timeInterval < (60 * 11) {
            let minutes = Int(timeInterval / 60)
            return R.string.localizable.commonTimestamp310Minutes("\(minutes)").localized()
        }
        // 11 - 59 minutes
        if timeInterval < (60 * 60) {
            let minutes = Int(timeInterval / 60)
            return R.string.localizable.commonTimestamp1159Minutes("\(minutes)").localized()
        }
        // 1 hour
        if timeInterval < (60 * 60 * 2) {
            return R.string.localizable.commonTimestamp1Hour().localized()
        }
        // 2 hours
        if timeInterval < (60 * 60 * 3) {
            return R.string.localizable.commonTimestamp2Hours().localized()
        }
        // 3-10 hours
        if timeInterval < (60 * 60 * 11) {
            let hours = Int(timeInterval / (60 * 60))
            return R.string.localizable.commonTimestamp310Hours("\(hours)").localized()
        }
        // 11-23 hours
        if timeInterval < (60 * 60 * 24) {
            let hours = Int(timeInterval / (60 * 60))
            return R.string.localizable.commonTimestamp1123Hours("\(hours)").localized()
        }
        // 1 day, HH:MM AM/PM
        if timeInterval < (60 * 60 * 24 * 2) {
            // swiftlint:disable:next line_length
            return "\(R.string.localizable.commonTimestamp1Day().localized()) \(self.toDateString(format: Constants.DateFormater.OnlyTime12h))"
        }
        // 2 days, HH:MM AM/PM
        if timeInterval < (60 * 60 * 24 * 3) {
            // swiftlint:disable:next line_length
            return "\(R.string.localizable.commonTimestamp2Days().localized()) \(self.toDateString(format: Constants.DateFormater.OnlyTime12h))"
        }
        // 3-6 days, HH:MM AM/PM
        if timeInterval < (60 * 60 * 24 * 7) {
            let days = Int(timeInterval / (60 * 60 * 24))
            // swiftlint:disable:next line_length
            return "\(R.string.localizable.commonTimestamp36Days("\(days)").localized()) \(self.toDateString(format: Constants.DateFormater.OnlyTime12h))"
        }
        // 1 week+
        return self.toDateString(format: Constants.DateFormater.FullDateDisplayWithTime)
    }
}
