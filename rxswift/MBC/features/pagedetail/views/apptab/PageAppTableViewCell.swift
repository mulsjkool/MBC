//
//  PageAppTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/11/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import TTTAttributedLabel

class PageAppTableViewCell: BaseCardTableViewCell {

	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var countLabel: UILabel!
	@IBOutlet weak private var typeLabel: UILabel!
	@IBOutlet weak private var appImageView: UIImageView!
	@IBOutlet weak private var countView: UIView!
    @IBOutlet weak private var marginBottomOfAppImageView: UIView!
    
    let didTapAppPhoto = PublishSubject<App>()
    let didTapAppTitle = PublishSubject<App>()
	private var app: App!
	
    func bindData(app: App, accentColor: UIColor?) {
        super.bindData(feed: app, accentColor: accentColor)
		self.app = app
		showAppImage()
		showTitle()
		showInterest()
		showAppType()
		countView.isHidden = true // TODO: in R2
        setupEvents()
	}
	
	private func showInterest() {
        guard let interest = app.interests, !interest.isEmpty else {
            marginBottomOfAppImageView.isHidden = true
            return
        }
        marginBottomOfAppImageView.isHidden = false
	}
	
	private func showAppType() {
        typeLabel.text = setAppType(subType: app.subType)
	}
	
	private func showAppImage() {
        if let photo = app.photo {
            appImageView.setImage(from: photo, resolution: .ar16x16)
        } else {
            appImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
	}
	
	private func showTitle() {
		titleLabel.text = app.title ?? ""
	}
    
    private func setupEvents() {
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
        
        titleLabel.isUserInteractionEnabled = true
        let titleTapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(titleTapGesture)
        
        titleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapAppTitle.onNext(self.app)
            })
            .disposed(by: disposeBag)
    }
}
