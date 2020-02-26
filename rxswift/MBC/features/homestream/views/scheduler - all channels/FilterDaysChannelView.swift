//
//  FilterDaysChannelView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import iCarousel
import RxSwift

class FilterDaysChannelView: BaseView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filterView: UIView!
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var programsLabel: UILabel!
    @IBOutlet private weak var todayLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var iCarouselView: iCarousel!
    private var tableViewExpandedHeight: CGFloat = 343
    private var framWhenExpand = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth, height: 392)
    private var framWhenCollapse = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth, height: 100)
    private var timeslotArray: [TimeSlot]!
    private var labelTimeslotTag: Int = 100
    private var currentTimeSlotSelectedIndex = 0
    var currentTimeSlotSelected = (Date(), Date())
    var currentDaysSelectedIndex = 0
    private var nowTimeSlotIndex = (Int(), Int()) // index of day, index of time slot
    var didSelectedTimeSlot = PublishSubject<(Date, Date)>() //(startDate, endDate)
    var isInTimeSlot = PublishSubject<Bool>()
    var days: [Date]!
    let minutesPerDay: Double = 3600 * 24 / 60
    let minuteInterval = Components.instance.configurations.timeSlotInterval / 60
    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
       let pointForTargetView: CGPoint = self.tableView.convert(point, from: self)
        if  self.tableView.frame.contains(pointForTargetView) {
            return self.tableView .hitTest(pointForTargetView, with: event)
        }
        return super.hitTest(point, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Public
    func getContainerView() -> UIView {
        return containerView
    }
    
    func getICarouselView() -> iCarousel {
        return iCarouselView
    }
    
    func createDaysOfWeek() {
        days = Date().getDatesInAWeek()
        if todayLabel != nil {
            todayLabel.text = days[currentDaysSelectedIndex].getNameOfDay()
            createTimeSlotData()
        }
    }
    
    func showNowTimeSlot() {
        currentDaysSelectedIndex = nowTimeSlotIndex.0
        currentTimeSlotSelectedIndex = nowTimeSlotIndex.1
        iCarouselView.scrollToItem(at: nowTimeSlotIndex.1, animated: true)
        showDataAfterSelectedDay()
    }
    
    // MARK: Private
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.filterDaysChannelView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.clipsToBounds = false
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        configUI()
        configButtonNextPrev()
        createDaysOfWeek()
    }
    
    private func createTimeSlotData() {
        let numberOfTimeSlot = Int(minutesPerDay / minuteInterval)
        timeslotArray = [TimeSlot]()
        var startTime: TimeInterval = 0
        var endTime: TimeInterval = Components.instance.configurations.timeSlotInterval - 1
        
        for index in 0..<numberOfTimeSlot {
            let timeSlot = TimeSlot()
            timeSlot.startTime = startTime
            timeSlot.endTime = endTime
            timeslotArray.append(timeSlot)
            startTime = endTime + 1
            endTime = startTime + Components.instance.configurations.timeSlotInterval - 1
            if isInTimeSlotFrom(date: Date(), timeSlot: timeSlot) {
                currentTimeSlotSelectedIndex = index
                nowTimeSlotIndex.0 = currentDaysSelectedIndex
                nowTimeSlotIndex.1 = currentTimeSlotSelectedIndex
            }
        }
        iCarouselView.reloadData()
        iCarouselView.scrollToItem(at: currentTimeSlotSelectedIndex, animated: false)
        filterScheduler()
    }
    
    private func isInTimeSlotFrom(date: Date, timeSlot: TimeSlot) -> Bool {
        if let startTime = Date.addMinuteFrom(currrentDate: days[currentDaysSelectedIndex], minutes:
            Int(timeSlot.startTime / 60)),
            let endTime = Date.addMinuteFrom(currrentDate: days[currentDaysSelectedIndex],
                                             minutes: Int(timeSlot.endTime / 60)) {
            return date >= startTime && date <= endTime
        }
        return false
    }
    
    private func configUI() {
        tableViewHeightConstraint.constant = 0
        tableView.register(R.nib.contentFilterCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.contentFilterCellId.identifier)
        if Constants.DefaultValue.shouldRightToLeft {
            iCarouselView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            filterView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            programsLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            programsLabel.textAlignment = .right
        }
        iCarouselView.type = .linear
        iCarouselView.isPagingEnabled = true
        iCarouselView.dataSource = self
        iCarouselView.delegate = self
    }
    
    func configButtonNextPrev() {
        if Constants.DefaultValue.shouldRightToLeft {
            nextButton.setImage(R.image.iconLeftArrow(), for: .normal)
            prevButton.setImage(R.image.iconRightArrow(), for: .normal)
        }
    }
    
    private func filterScheduler() {
        let timeSlot = timeslotArray[currentTimeSlotSelectedIndex]
        let currentSelectedDate = days[currentDaysSelectedIndex]
        if isInTimeSlotFrom(date: Date(), timeSlot: timeSlot) {
            nowTimeSlotIndex.0 = currentDaysSelectedIndex
            nowTimeSlotIndex.1 = currentTimeSlotSelectedIndex
            isInTimeSlot.onNext(true)
        } else {
            isInTimeSlot.onNext(false)
        }
        if let startDate = Date.addMinuteFrom(currrentDate: currentSelectedDate, minutes:
            Int(timeSlot.startTime / 60)), let endDate = Date.addMinuteFrom(currrentDate: currentSelectedDate, minutes:
            Int(timeSlot.endTime / 60)) {
            currentTimeSlotSelected.0 = startDate
            currentTimeSlotSelected.1 = endDate
            didSelectedTimeSlot.onNext((startDate, endDate))
        }
    }
    
    private func createTimeSlotView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: iCarouselView.frame.size.width,
                                        height: iCarouselView.frame.size.height))
        let timeSlotLabel = UILabel()
        timeSlotLabel.font = R.font.ltKaffSemiBold(size: 12.0)
        timeSlotLabel.textColor = Colors.dark.color()
        timeSlotLabel.backgroundColor = UIColor.white
        timeSlotLabel.clipsToBounds = true
        timeSlotLabel.textAlignment = .center
        timeSlotLabel.tag = labelTimeslotTag
        timeSlotLabel.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addSubview(timeSlotLabel)
        view.mf.addConstraints([
            timeSlotLabel.top |==| view.top,
            timeSlotLabel.leading |==| view.leading,
            timeSlotLabel.trailing |==| view.trailing,
            timeSlotLabel.width |==| view.width,
            timeSlotLabel.height |==| view.height
        ])
        if Constants.DefaultValue.shouldRightToLeft {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        return view
    }
    
    private func scrollNextTimeSlot(index: Int) {
        if index < timeslotArray.count {
            iCarouselView.scrollToItem(at: index, animated: true)
        }
    }
    
    private func scrollPrevTimeSlot(index: Int) {
        if index >= 0 {
            iCarouselView.scrollToItem(at: index, animated: true)
        }
    }
    
    private func showDataAfterSelectedDay() {
        let dateSelected = days[currentDaysSelectedIndex]
        todayLabel.text = dateSelected.getNameOfDay()
        filterScheduler()
    }
    
    // MARK: IBAction
    @IBAction func buttonSelectDayTouch() {
        Common.generalAnimate(duration: 0.3) {
            // TODO: apply animate
            if self.tableViewHeightConstraint.constant == 0 {
              //  self.containerView.frame = self.framWhenExpand
                self.tableViewHeightConstraint.constant = self.tableViewExpandedHeight
            } else {
              //  self.containerView.frame = self.framWhenCollapse
                self.tableViewHeightConstraint.constant = 0
            }
        }
        
    }
    
    @IBAction func buttonPrevTouch() {
        scrollPrevTimeSlot(index: currentTimeSlotSelectedIndex - 1)
    }
    
    @IBAction func buttonNextTouch() {
        scrollNextTimeSlot(index: currentTimeSlotSelectedIndex + 1)
    }
    
}

extension FilterDaysChannelView: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return timeslotArray == nil ? 0: timeslotArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIView
        if let view = view { itemView = view } else {
            itemView = createTimeSlotView()
        }
        let timeSlot = timeslotArray[index]
        if let labelTimeSlot = itemView.viewWithTag(labelTimeslotTag) as? UILabel {
            labelTimeSlot.text = timeSlot.getTimeSlotString()
        }
        return itemView
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if carousel.currentItemIndex != currentTimeSlotSelectedIndex {
            currentTimeSlotSelectedIndex = carousel.currentItemIndex
            filterScheduler()
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .count {
            return 1
        }
        return value
    }
    
}

extension FilterDaysChannelView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.DefaultValue.totalDayForScheduler
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contentFilterCellId.identifier)
            as? ContentFilterCell {
            let isTextHighlighted: Bool = indexPath.row == 0 ? true : false
            cell.bindData(text: days[indexPath.row].getNameOfDay(), isTextHighlighted: isTextHighlighted)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentDaysSelectedIndex = indexPath.row
        showDataAfterSelectedDay()
        buttonSelectDayTouch()
    }
    
}
