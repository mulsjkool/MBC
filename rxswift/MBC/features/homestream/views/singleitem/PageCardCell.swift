//
//  PageCardCell.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift
import UIKit

class PageCardCell: BaseCampaignTableViewCell {
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var pageTitleLabel: UILabel!
    @IBOutlet weak private var followerNumberLabel: UILabel!
    @IBOutlet weak private var coverContainViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak private var inforContainViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var topMetadataLabel: UILabel!
    @IBOutlet weak private var bottomMetadataLabel: UILabel!
    @IBOutlet weak private var likeContainView: UIView!
    
    var coverTapped = PublishSubject<String?>()
    var posterTapped = PublishSubject<String?>()
    var pageTitleTapped = PublishSubject<Void>()
    
    private var model: Page!
    
    func bindData(model: Page) {
        self.model = model
        bindCoverAndPoster()
        setupEvents()
    }
    
    private func bindCoverAndPoster() {
        var willDisplayCover = false
        var willDisplayPoster = false
        if let coverImage = model.cover {
            willDisplayCover = true
            coverImageView.setImage(from: coverImage, resolution: .ar16x9, gifSupport: false)
            
        }
        if let posterImage = model.poster {
            willDisplayPoster = true
            posterImageView.setImage(from: posterImage, resolution: .ar27x40, gifSupport: false)
        }
        // With Cover and Poster
        if !willDisplayCover || !willDisplayPoster {
            // With Cover / No Poster
            if willDisplayCover {
                self.inforContainViewRightConstraint.constant = Constants.DefaultValue.defaultMargin
            }
            // No Cover / With Poster
            else if willDisplayPoster {
                self.coverContainViewLeftConstraint.constant = Constants.DeviceMetric.screenWidth
            }
            // No Cover / No Poster
            else {
                self.inforContainViewRightConstraint.constant = Constants.DefaultValue.defaultMargin
                self.coverContainViewLeftConstraint.constant = Constants.DeviceMetric.screenWidth
            }
        }
        layoutIfNeeded()
        
        pageTitleLabel.text = model.title ?? ""
//        topMetadataLabel.text = model.topMetadata ?? ""
//        bottomMetadataLabel.text = model.bottomMetadata ?? ""
        
        // Apply header color
        if let headerColorValue = model.headerColor {
            backgroundColor = headerColorValue
        }
        
        // Apply accent color
//        if let accentColorValue = model.accentColor {
            // Like button: If not yet liked, apply accent color
            //            likeContainView.backgroundColor = accentColor
//        }
    }
    
    private func setupEvents() {
        coverImageView.isUserInteractionEnabled = true
        let coverTapGesture = UITapGestureRecognizer()
        coverImageView.addGestureRecognizer(coverTapGesture)
        
        coverTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.coverTapped.onNext(self.model.cover?.originalLink)
            })
            .disposed(by: disposeBag)
        
        posterImageView.isUserInteractionEnabled = true
        let posterTapGesture = UITapGestureRecognizer()
        posterImageView.addGestureRecognizer(posterTapGesture)
        
        posterTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.posterTapped.onNext(self.model.poster?.originalLink)
            })
            .disposed(by: disposeBag)
        
        pageTitleLabel.isUserInteractionEnabled = true
        let pageTitleTapGesture = UITapGestureRecognizer()
        pageTitleLabel.addGestureRecognizer(pageTitleTapGesture)
        
        pageTitleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.pageTitleTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

extension PageCardCell: IAnalyticsTrackingCell {

    func getTrackingObjects() -> [IAnalyticsTrackingObject] {
        return [AnalyticsGeneralPage(page: model)] + analyticsCampaigns
    }

}
