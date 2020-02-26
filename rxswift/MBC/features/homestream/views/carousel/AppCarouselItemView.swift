//
//  AppCarouselItemView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/8/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class AppCarouselItemView: BaseCarouselItemView {
	@IBOutlet weak private var typeLabel: UILabel!
	@IBOutlet weak private var authorLabel: UILabel!
	@IBOutlet weak private var countLabel: UILabel!

    var authorNameTapped = PublishSubject<Void>()
    
	override func bindData(_ feed: Feed) {
		super.bindData(feed)
		setAppType()
		setupAuthorLabelEvent()
	}
	
    private func setAppType() {
        guard let subtype = (feed as? App)?.subType else { return }
        if let type = AppSubType(rawValue: subtype) {
            typeLabel.text = type.localizedContentType()
        }
    }
	
	private func setAuthor() {
		guard let author = feed.author else { return }
        self.authorLabel.text = author.name
	}

    private func setupAuthorLabelEvent() {
        authorLabel.isUserInteractionEnabled = true
        let authorNameTapGesture = UITapGestureRecognizer()
        authorLabel.addGestureRecognizer(authorNameTapGesture)
        
        authorNameTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.authorNameTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
