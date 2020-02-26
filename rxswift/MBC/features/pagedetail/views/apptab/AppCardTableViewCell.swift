//
//  AppCardTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class AppCardTableViewCell: BaseCardTableViewCell {
    @IBOutlet weak private var appImageView: UIImageView!
    @IBOutlet weak private var btnShare: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    private var app: App!
    let didTapTitle = PublishSubject<App>()
    let didTapAppPhoto = PublishSubject<App>()
    
    override func bindData(feed: Feed, accentColor: UIColor?) {
        super.bindData(feed: feed, accentColor: accentColor)
        self.app = self.feed as? App
        bindDescription()
        bindTitle()
        bindCTAButtonTitle()
        showAppImage()
        setLikeComment()
        setupEvents()
    }
    
    private func bindTitle() {
        titleLabel.text = app.title ?? ""
        titleLabelTopConstraint.constant = (titleLabel.text?.isEmpty)! ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
    }
    
    private func bindCTAButtonTitle() {
        btnShare.setTitle(R.string.localizable.appCtaButtonTitle(), for: .normal)
    }
    
    private func showAppImage() {
        if let photo = app.photo {
            appImageView.setImage(from: photo, resolution: .ar16x16)
        } else {
            appImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
    }
    
    private func setupEvents() {
        titleLabel.isUserInteractionEnabled = true
        let titleTapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(titleTapGesture)
        
        titleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapTitle.onNext(self.app)
            })
            .disposed(by: disposeBag)
        
        appImageView.isUserInteractionEnabled = true
        let appImageTapGesture = UITapGestureRecognizer()
        appImageView.addGestureRecognizer(appImageTapGesture)
        
        appImageTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapAppPhoto.onNext(self.app)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        self.didTapAppPhoto.onNext(self.app)
    }
    override func getTrackingObjects() -> [IAnalyticsTrackingObject] {
        return [AnalyticsApp(app: app)] + analyticsCampaigns
    }
}
