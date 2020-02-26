//
//  BundleCarouselCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class BundleCarouselCollectionViewCell: BaseCarouselItemView {
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var contentNoLabel: UILabel!
    @IBOutlet weak private var shadowView: UIView!
    @IBOutlet weak private var borderView: UIView!
    
    var authorNameTapped = PublishSubject<Void>()
    private var accentColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = getImageView()
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        if let shadowView = shadowView {
            shadowView.layer.cornerRadius = shadowView.frame.size.height / 2
            shadowView.clipsToBounds = true
        }
        if let borderView = borderView {
            borderView.layer.cornerRadius = shadowView.frame.size.height / 2
            borderView.clipsToBounds = true
        }
    }
    
    func bindData(_ feed: Feed, accentColor: UIColor? = nil) {
        super.bindData(feed)
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        bindAuthorName()
        bindContentNo()
        setupAuthorLabelEvent()
    }
    
    func highligh() {
        guard !(feed is Playlist), let bundle = feed as? BundleContent, bundle.ishighlighted else {
            showImageViewBorder(willShow: false)
            return
        }
        showImageViewBorder(willShow: true)
    }
    
    // MARK: Private functions

    private func bindAuthorName() {
        guard let authorNameLabel = authorNameLabel else { return }
        guard let author = feed.author else {
            authorNameLabel.text = ""
            return
        }
        authorNameLabel.text = author.name
    }
    
    func bindContentNo() {
        var contentNo = 0
        if let bundle = feed as? BundleContent {
            contentNo = bundle.items.isEmpty ? bundle.numOfContent : bundle.items.count
            contentNoLabel.text = R.string.localizable.bundleContentNo("\(contentNo)").localized()
        }
        if let playlist = feed as? Playlist {
            contentNo = playlist.items.isEmpty ? playlist.numOfContent : playlist.items.count
            contentNoLabel.text = R.string.localizable.commonVideoTitleCount("\(contentNo)").localized()
        }
    }
    
    private func setupAuthorLabelEvent() {
        guard let authorNameLabel = authorNameLabel else { return }
        authorNameLabel.isUserInteractionEnabled = true
        let authorNameTapGesture = UITapGestureRecognizer()
        authorNameLabel.addGestureRecognizer(authorNameTapGesture)
        
        authorNameTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.authorNameTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func showImageViewBorder(willShow: Bool) {
        guard let borderView = borderView else { return }
        if willShow {
            borderView.borderWidth = Constants.DefaultValue.bundleCarouselImageViewBorderWidth
            borderView.borderColor = accentColor
        } else {
            borderView.borderWidth = 0.0
        }
    }
}
