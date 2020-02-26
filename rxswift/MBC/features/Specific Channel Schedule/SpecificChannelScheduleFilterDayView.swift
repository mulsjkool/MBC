//
//  SpecificChannelScheduleFilterDayView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import iCarousel
import RxSwift

class SpecificChannelScheduleFilterDayView: FilterDaysChannelView {
    
    @IBOutlet private weak var logoImageView: UIImageView!
    private var currentSelectedIndex: Int = 0
    var didSelectedDayIndex = PublishSubject<Int>()
    private var iCarouselView: iCarousel! {
        return self.getICarouselView()
    }
    
    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.iCarouselView.reloadData()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func numberOfItems(in carousel: iCarousel) -> Int {
        return days != nil ? days.count: 0
    }
    
    override func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption,
                           withDefault value: CGFloat) -> CGFloat {
        if option == .count {
            return 1
        }
        return value
    }
    
    override func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIView
        if let view = view { itemView = view } else {
            itemView = createDayView()
            if Constants.DefaultValue.shouldRightToLeft {
                itemView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
        }
        (itemView as? SchedulerDaySelectionItemView)?.bindData(day: days[index].getNameOfDay())
        return itemView
    }
    
    override func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if carousel.currentItemIndex != currentSelectedIndex {
            currentSelectedIndex = carousel.currentItemIndex
            filterScheduler()
        }
    }
    
    // MARK: Public
    
    func binData(logo: String?) {
        showLogo(logo: logo)
    }
    
    func scrollTo(index: Int) {
        iCarouselView.scrollToItem(at: index, animated: true)
    }
    
    // MARK: Private
    private func showLogo(logo: String?) {
        logoImageView.setSquareImage(imageUrl: logo)
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.specificChannelScheduleFilterDayView.name, owner: self, options: nil)
        let containerView = self.getContainerView()
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
    
    private func filterScheduler() {
        didSelectedDayIndex.onNext(currentSelectedIndex)
    }
    
    private func configUI() {
      //  iCarouselView = getICarouselView()
        iCarouselView.type = .linear
        iCarouselView.isPagingEnabled = true
        iCarouselView.dataSource = self
        iCarouselView.delegate = self
        iCarouselView.clipsToBounds = true
        if Constants.DefaultValue.shouldRightToLeft {
            iCarouselView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
    
    private func createDayView() -> SchedulerDaySelectionItemView {
        return SchedulerDaySelectionItemView(frame: CGRect(x: 0, y: 0, width: iCarouselView.frame.size.width,
                                                           height: iCarouselView.frame.size.height))
    }
    
    // MARK: IBAction
    @IBAction override func buttonNextTouch() {
        if currentSelectedIndex + 1 < days.count {
            scrollTo(index: currentSelectedIndex + 1)
        }
    }
    
    @IBAction override func buttonPrevTouch() {
        if currentSelectedIndex - 1 >= 0 {
            scrollTo(index: currentSelectedIndex - 1)
        }
    }
    
}
