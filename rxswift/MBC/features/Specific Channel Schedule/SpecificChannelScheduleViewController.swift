//
//  SpecificChannelScheduleViewController.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class SpecificChannelScheduleViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nowButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var specificChannelScheduleFilterDayView: SpecificChannelScheduleFilterDayView!
    
    private let buttonNowHeight: CGFloat = 34
    private var schedulerOnChannel: SchedulerOnChannel!
    private var schedulerOndays: [SchedulersOnDay] = [SchedulersOnDay(), SchedulersOnDay(), SchedulersOnDay(),
                                                       SchedulersOnDay(), SchedulersOnDay(), SchedulersOnDay(),
                                                       SchedulersOnDay()]
    private var currentDaySelectedIndex: Int = 0
    private let nowIndex: Int = 0
    private var checkSchedulerShowTimeTimer: Timer?
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: Scheduler - Invalid")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showTitle()
        specificChannelScheduleFilterDayView.binData(logo: schedulerOnChannel.channelLogo)
        specificChannelScheduleFilterDayView.scrollTo(index: currentDaySelectedIndex)
        beginCheckSchedulerShowTime()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        endCheckSchedulerShowTime()
    }
    
    func bindData(schedulerOnChannel: SchedulerOnChannel, daySelectedIndex: Int) {
        self.schedulerOnChannel = schedulerOnChannel
        self.currentDaySelectedIndex = daySelectedIndex
        sortSchedulersForDays(schedules: schedulerOnChannel.schedules)
    }
    
    // MARK: Private
    private func beginCheckSchedulerShowTime() {
        self.checkSchedulerShowTimeTimer = Timer.scheduledTimer(
            timeInterval: Constants.DefaultValue.checkSchedulerShowTimeInterval, target: self,
            selector: #selector(checkSchedulerShowTime),
            userInfo: nil, repeats: true)
    }
    
    private func endCheckSchedulerShowTime() {
        self.checkSchedulerShowTimeTimer?.invalidate()
        self.checkSchedulerShowTimeTimer = nil
    }
    
    @objc
    private func checkSchedulerShowTime() {
        guard  currentDaySelectedIndex < self.schedulerOndays.count else {
            endCheckSchedulerShowTime()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { // 1
            let schedulerOnday = self.schedulerOndays[self.currentDaySelectedIndex]
            let now = Date()
            var rowIndex: Int?
            var isNeedScrollToShowTime = false
            for scheduler in schedulerOnday.list {
                scheduler.isOnShowTime = (now >= scheduler.startTime && now <= scheduler.endTime)
                if scheduler.isOnShowTime {
                    rowIndex = scheduler.rowIndex
                    if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows {
                        for indexPath in visibleIndexPaths {
                            isNeedScrollToShowTime = indexPath.row == rowIndex
                        }
                    }
                    break
                }
            }
            DispatchQueue.main.async { // 2
                self.tableView.reloadData()
                if let rowIndex = rowIndex {
                    if isNeedScrollToShowTime {
                        self.tableView.scrollToRow(at: IndexPath(row: rowIndex, section: 1 ),
                                                   at: .middle, animated: true)
                    }
                }
            }
        }
    }

    private func showTitle() {
        titleLabel.text = schedulerOnChannel.channelName
    }
    
    private func sortSchedulersForDays(schedules: [Schedule]) {
        let schedules = schedules.sorted(by: { obj1, obj2 -> Bool in
            obj1.startTime.compare(obj2.startTime) == .orderedAscending
        })

        for schedule in schedules {
            let dayIndex = schedule.startTime.getIndexInWeek()
            let schedulerOnday = schedulerOndays[dayIndex - 1]
            schedulerOnday.list.append(schedule)
        }
    }
    
    private func setupUI() {
        self.navigator = Navigator(navigationController: self.navigationController)
        tableView.register(R.nib.scheduleTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.scheduleTableViewCellid.identifier)
        specificChannelScheduleFilterDayView.disposeBag.addDisposables([
            specificChannelScheduleFilterDayView.didSelectedDayIndex.subscribe(onNext: { [unowned self] selectedDayIndex
                in
                self.currentDaySelectedIndex = selectedDayIndex
                self.shoudlHideNowButton(should: selectedDayIndex == self.nowIndex)
                self.tableView.reloadData()
            })
        ])
    }
    
    private func createSchedulerCell(tableView: UITableView, schedule: Schedule) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.scheduleTableViewCellid.identifier)
            as? ScheduleTableViewCell {
            cell.bindData(schedule: schedule)
            return cell
        }
        return dummyCell
    }
    
    private func shoudlHideNowButton(should: Bool) {
        nowButtonHeightConstraint.constant = should ? 0 : buttonNowHeight
    }
    
    // MARK: IBAction
    @IBAction func buttonNowTouch() {
        specificChannelScheduleFilterDayView.scrollTo(index: nowIndex)
    }
    
    @IBAction func buttonClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SpecificChannelScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulerOndays[currentDaySelectedIndex].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let scheduler = schedulerOndays[currentDaySelectedIndex].list[indexPath.row]
        scheduler.rowIndex = indexPath.row
        return createSchedulerCell(tableView: tableView, schedule: scheduler)
    }
}
