//
//  SchedulerDaySelectionCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import iCarousel
import RxSwift

class SchedulerDaySelectionCell: BaseTableViewCell {
    
    @IBOutlet private weak var icarousel: iCarousel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    var didSelectedDay = PublishSubject<Int>()
    
    private var listOfDay = [String]()
    private var currentSelectedIndex = 0
   
    override func prepareForReuse() {
        super.prepareForReuse()
        listOfDay = [String]()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.icarousel.reloadData()
        })
    }
    
    // MARK: Public
    func bindData() {
        configButtonLeftRight()
        createListOfDayForm()
        setupCarousel()
    }
    
    // MARK: Private
    
    private func setupCarousel() {
        if Constants.DefaultValue.shouldRightToLeft {
            icarousel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        icarousel.dataSource = self
        icarousel.delegate = self
        icarousel.type = .linear
        icarousel.isPagingEnabled = true
    }
    
    private func configButtonLeftRight() {
        if Constants.DefaultValue.shouldRightToLeft {
            leftButton.setImage(R.image.iconRightArrow(), for: .normal)
            rightButton.setImage(R.image.iconLeftArrow(), for: .normal)
        }
    }
    
    private func createListOfDayForm() {
        let days = Date().get8Dates()
        for index in 0...(days.count - 1) {
            let day = days[index].getNameOfDay()
            listOfDay.append(day)
        }
    }
    
    private func createDayView() -> SchedulerDaySelectionItemView {
        return SchedulerDaySelectionItemView(frame: CGRect(x: 0, y: 0, width: icarousel.frame.size.width,
                                                               height: icarousel.frame.size.height))
    }

    // MARK: IBAction
    @IBAction func buttonLeftTouch() {
        currentSelectedIndex -= 1
        currentSelectedIndex = currentSelectedIndex < 0 ? 0 : currentSelectedIndex
        icarousel.scrollToItem(at: currentSelectedIndex, animated: true)
        didSelectedDay.onNext(currentSelectedIndex)
    }
    
    @IBAction func buttonRightTouch() {
        currentSelectedIndex += 1
        currentSelectedIndex = currentSelectedIndex > listOfDay.count ?  listOfDay.count : currentSelectedIndex
        icarousel.scrollToItem(at: currentSelectedIndex, animated: true)
        didSelectedDay.onNext(currentSelectedIndex)
    }
}

extension SchedulerDaySelectionCell: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return listOfDay.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIView
        if let view = view { itemView = view } else {
            itemView = createDayView()
            if Constants.DefaultValue.shouldRightToLeft {
                itemView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
        }
        (itemView as? SchedulerDaySelectionItemView)?.bindData(day: listOfDay[index])
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .count {
            return 1
        }
        return value
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if carousel.currentItemIndex != currentSelectedIndex {
            currentSelectedIndex = carousel.currentItemIndex
            didSelectedDay.onNext(currentSelectedIndex)
        }
    }
}
