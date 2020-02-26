//
//  ChannelTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 3/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class ChannelTableViewCell: ScheduleTableViewCell {
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var prevButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    var buttonNextTouched = PublishSubject<Void>()
    var buttonPrevTouched = PublishSubject<Void>()
    
    override func bindData(schedule: Schedule) {
        super.bindData(schedule: schedule)
        showLogoChannel()
        configButtonNextPrev()
    }
    
    // MARK: Private
    private func showLogoChannel() {
        guard let logo = self.schedule.channelLogo else {
            logoImageView.image = nil
            return
        }
        logoImageView.setSquareImage(imageUrl: logo)
    }
    
    private func configButtonNextPrev() {
        if Constants.DefaultValue.shouldRightToLeft {
            nextButton.setImage(R.image.iconLeftArrow(), for: .normal)
            prevButton.setImage(R.image.iconRightArrow(), for: .normal)
        }
    }
    
    // MARK: IBAction
    @IBAction func buttonPrevTouch() {
        buttonPrevTouched.onNext(())
    }
    
    @IBAction func buttonNextTouch() {
        buttonNextTouched.onNext(())
    }
}
