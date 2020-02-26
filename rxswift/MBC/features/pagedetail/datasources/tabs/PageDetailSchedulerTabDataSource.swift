//
//  PageDetailSchedulerTabDataSource.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailSchedulerTabDelegate: PageDetailTabDelegate {
    func getDataReadyForScheduler() -> Bool
    func getItemList() -> ItemList
    func getCurrentSchedulerDay() -> Int
    func setCurrentSchedulerDay(index: Int)
    func reloadCellIn(section: Int)
    func pushToPageDetail(pageUrl: String, pageId: String)
}

class PageDetailSchedulerTabDataSource: PageDetailTabDataSource {
    
    weak var delegate: PageDetailSchedulerTabDelegate?
    
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: Scheduler - Invalid")
    }
    
    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = delegate else { return dummyCell }
        let itemList = delegate.getItemList()
        
        if indexPath.section == 0 {
            return createSchedulerSelectDayCell(tableView: tableView)
        }
        
        let index = delegate.getCurrentSchedulerDay()
        if index < itemList.count {
            if let schedulersOnDay = itemList.list[index] as? SchedulersOnDay,
                schedulersOnDay.list.count > indexPath.row {
                let scheduler = schedulersOnDay.list[indexPath.row]
                scheduler.rowIndex = indexPath.row
                return createSchedulerCell(tableView: tableView, schedule: scheduler)
            }
        }
        
        return UITableViewCell()
    }
    
    private func createSchedulerSelectDayCell(tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.schedulerDaySelectionCellid.identifier) as? SchedulerDaySelectionCell {
            cell.bindData()
            cell.disposeBag.addDisposables([
                cell.didSelectedDay.subscribe(onNext: { [weak self] dayIndex in
                    self?.delegate?.setCurrentSchedulerDay(index: dayIndex)
                    self?.delegate?.reloadCellIn(section: 1)
                })
            ])
            return cell
        }
        return dummyCell
    }
    
    private func createSchedulerCell(tableView: UITableView, schedule: Schedule) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.scheduleTableViewCellid.identifier)
            as? ScheduleTableViewCell {
            cell.bindData(schedule: schedule)
            cell.disposeBag.addDisposables([
                cell.didSelectedSchedule.subscribe(onNext: { [weak self] schedule in
                    if let id = schedule.showId, !id.isEmpty {
                        self?.delegate?.pushToPageDetail(pageUrl: "", pageId: id)
                    }
                })
            ])
            return cell
        }
        return dummyCell
    }
}
