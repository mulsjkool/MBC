//
//  ScheduleTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/12/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class ScheduleTableViewCell: BaseTableViewCell {

    @IBOutlet private weak var lableLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var showTimeLabel: UILabel!
    @IBOutlet private weak var showOnTimeLabel: UILabel!
    @IBOutlet private weak var showTimeView: UIView!
    @IBOutlet private weak var liveLabel: UIView!
    var schedule: Schedule!
    private let normalColor = Colors.dark.color()
    private let showTimeColor = Colors.defaultAccentColor.color()
    private let formatTime = "hh:mma"
    
    var didSelectedSchedule = PublishSubject<Schedule>()
    
    // MARK: Public
    func bindData(schedule: Schedule) {
        self.schedule = schedule
        setBackgroundColorShowTimeView()
        showLabel()
        showTitle()
        showSeason()
        showShowTime()
        showOnShowTime()
    }
    
    // MARK: Private
    private func setBackgroundColorShowTimeView() {
        if liveLabel != nil {
            liveLabel.isHidden = !schedule.isOnShowTime
        }
        if showTimeView != nil {
            if schedule.isOnShowTime {
                showTimeView.backgroundColor = showTimeColor
            } else {
                showTimeView.backgroundColor = normalColor
            }
        }
    }
    
    private func showOnShowTime() {
        guard showOnTimeLabel != nil else { return }
        showOnTimeLabel.text = schedule.startTime.toDateString(format: formatTime)
    }
    private func showLabel() {
        guard let label = schedule.label else {
            lableLabel.text = ""
            lableLabel.isHidden = true
            return
        }
        lableLabel.isHidden = false
        lableLabel.text = label
    }
    
    private func showTitle() {
        titleLabel.text = schedule.title
    }
    
    private func showSeason() {
        var strings = [String]()
        
        if let season = schedule.season, !season.isEmpty {
            strings.append(season)
        }
        if let sequenceNumber = schedule.sequenceNumber, !sequenceNumber.isEmpty {
            strings.append(sequenceNumber)
        }
        if !schedule.genre.isEmpty {
            strings.append(schedule.genre)
        }
        if strings.isEmpty { seasonLabel.text = "" }
        if strings.count == 1 { seasonLabel.text = strings[0] }
        if strings.count > 1 {
            seasonLabel.text = strings.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
        }
    }
    
    private func showShowTime() {
        let startTimeStr = schedule.startTime.toDateString(format: formatTime)
        let endTimeStr = schedule.endTime.toDateString(format: formatTime)
        showTimeLabel.text = "\(startTimeStr) - \(endTimeStr)"
    }
    
    // MARK: IBAction
    
    @IBAction func cellTapped(_ sender: Any) {
        self.didSelectedSchedule.onNext(schedule)
    }
}
