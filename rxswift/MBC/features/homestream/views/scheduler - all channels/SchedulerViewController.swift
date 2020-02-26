//
//  SchedulerViewController.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class SchedulerViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var filterDaysChannelView: FilterDaysChannelView!
    private var viewModel = SchedulerAllChannelsViewModel(interactor: Components.schedulerAllChannelInterator())
    private let timeslotFilterReuseCell = "timeslotFilterReuseCell"
    private let timeslotFilterHeight: CGFloat = 100
    private var schedulerArray = [Schedule]()
    private var estimatedRowHeight: CGFloat = 118
    private var nowButtonHeight: CGFloat = 34
    @IBOutlet private weak var buttonNowHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindEvents()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterDaysChannelView.createDaysOfWeek()
        getDataScheduler()
    }
    
    // MARK: Private functions
    
    private func shouldHideNowButton(should: Bool) {
        buttonNowHeightConstraint.constant = should ? 0 : nowButtonHeight
    }
    
    private func setupUI() {
        self.navigator = Navigator(navigationController: self.navigationController)
        filterDaysChannelView.isHidden = true
        tableViewTopConstraint.constant = 0
        tableView.register(R.nib.channelTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.channelTableViewCellId.identifier)
        initDataTimesSlotFilter()
        shouldHideNowButton(should: true)
    }
    
    private func getDataScheduler() {
        tableViewTopConstraint.constant = 0
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.loadItems()
        })
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartGetListItem.subscribe(onNext: { [weak self] _ in
                self?.filterDaysChannelView.isHidden = true
                
                self?.tableView.reloadData()
            }),
            viewModel.onDidLoadItems.subscribe(onNext: { [weak self] schedulerOnChannels in
                self?.filterDaysChannelView.isHidden = schedulerOnChannels.isEmpty
                self?.showData()
            })
        ])
    }
    
    private func showData() {
        schedulerArray.removeAll()
        tableViewTopConstraint.constant = viewModel.schannelArray.isEmpty ? 0 : timeslotFilterHeight
        for scheduleOnChannel in viewModel.schannelArray {
            let schedulers = scheduleOnChannel.schedules.filter {
                let schedulerStartDate = $0.startTime
                let filterStartDate = filterDaysChannelView.currentTimeSlotSelected.0
                let filterEndDate = filterDaysChannelView.currentTimeSlotSelected.1
                if schedulerStartDate.day == filterStartDate.day && schedulerStartDate.month == filterStartDate.month
                    && schedulerStartDate.year == filterStartDate.year {
                    return schedulerStartDate >= filterStartDate && schedulerStartDate <= filterEndDate
                }
                return false
            }
            if !schedulers.isEmpty { schedulerArray.append(schedulers[0]) }
        }
        tableView.reloadData()
    }
   
    private func initDataTimesSlotFilter() {
        filterDaysChannelView.disposeBag.addDisposables([
            filterDaysChannelView.didSelectedTimeSlot.subscribe(onNext: { [unowned self] _, _ in
                self.showData()
            }),
            filterDaysChannelView.isInTimeSlot.subscribe(onNext: { [unowned self] isInTimeSlot in
                self.shouldHideNowButton(should: isInTimeSlot)
            })
        ])
    }
    
    private func createSchedulerOnChannelCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.channelTableViewCellId.identifier) as? ChannelTableViewCell {
            let scheduler = schedulerArray[indexPath.row]
            cell.bindData(schedule: scheduler)
            cell.disposeBag.addDisposables([
                cell.buttonPrevTouched.subscribe(onNext: { [unowned self] in
                    self.filterDaysChannelView.buttonPrevTouch()
                }),
                cell.buttonNextTouched.subscribe(onNext: { [unowned self] in
                    self.filterDaysChannelView.buttonNextTouch()
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: IBAction
    @IBAction func buttonNowTouch() {
        filterDaysChannelView.showNowTimeSlot()
    }

}

extension SchedulerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewModel.isLoadingData ? Constants.DefaultValue.PlaceHolderLoadingHeight : estimatedRowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isLoadingData ? 2 : schedulerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  viewModel.isLoadingData {
            return Common.createLoadingPlaceHolderCell()
        }
        return createSchedulerOnChannelCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = schedulerArray[indexPath.row]
        let schedulerOnChannels = viewModel.schannelArray.filter { $0.channelId == schedule.channelId }
        guard !schedulerOnChannels.isEmpty else { return }
        showSpecificChannelSchedule(schedulerOnChannel: schedulerOnChannels[0],
                                    daySelectedIndex: filterDaysChannelView.currentDaysSelectedIndex)
    }
}
