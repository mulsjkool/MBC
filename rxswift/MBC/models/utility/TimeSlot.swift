//
//  TimeSlot.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/21/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class TimeSlot {
    var startTime: TimeInterval!
    var endTime: TimeInterval!
    private let formatTime = "hh:mma"
    
    func getTimeSlotString() -> String {
        let date = Date().startOfDay
        let start = Date.addMinuteFrom(currrentDate: date,
                                       minutes: Int(startTime / 60))
        if let start = start {
           return "\(start.toDateString(format: formatTime))"
        }
        return ""
    }
}
