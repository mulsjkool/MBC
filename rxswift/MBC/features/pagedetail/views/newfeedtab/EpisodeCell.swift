//
//  EpisodeCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/19/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class EpisodeCell: BaseCardTableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var seasonLabel: UILabel!
    @IBOutlet weak private var genreLabel: UILabel!
    @IBOutlet weak private var timestampLabel: UILabel!
    @IBOutlet weak private var shahidButton: UIButton!
    @IBOutlet weak private var seasonSeparatorLabel: UILabel!
    @IBOutlet weak private var genreSeparatorLabel: UILabel!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var seasonSeparatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var genreSeparatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    
    private let defaultSeparatorWidth: CGFloat = 10.0
    let onStartInAppBrowser = PublishSubject<URL>()

    private var post: Post {
        return (feed as? Post)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        shahidButton.titleLabel?.font = Fonts.Primary.semiBold.toFontWith(size: 12)

        let margin: CGFloat = Constants.DefaultValue.shahibButtonTextMargin / 2
        if Constants.DefaultValue.shouldRightToLeft {
            shahidButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: margin)
            shahidButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
        } else {
            shahidButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
            shahidButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: margin)
        }
    }

    func bindData(post: Post, accentColor: UIColor?, season: String?, genre: String?) {
        super.bindData(feed: post, accentColor: accentColor)
        bindTitle(title: post.episodeTitle)
        bindSeason(season: season)
        bindGenre(genre: genre)
        bindTimestamp(date: post.publishedDate)
        bindThumbnail(imageUrl: post.episodeThumbnail)
        setupEvents()
    }
    
    private func bindTitle(title: String?) {
        titleLabel.text = title ?? ""
        titleLabelTopConstraint.constant = titleLabel.text!.isEmpty ? 0 :
            Constants.DefaultValue.titleAndDescriptionLabelTopMargin
    }
    
    private func bindSeason(season: String?) {
        seasonLabel.text = season ?? ""
        seasonSeparatorWidthConstraint.constant = seasonLabel.text!.isEmpty ? 0 : defaultSeparatorWidth
        seasonSeparatorLabel.isHidden = seasonLabel.text!.isEmpty
    }
    
    private func bindGenre(genre: String?) {
        genreLabel.text = genre ?? ""
        genreSeparatorWidthConstraint.constant = genreLabel.text!.isEmpty ? 0 : defaultSeparatorWidth
        genreSeparatorLabel.isHidden = genreLabel.text!.isEmpty
    }
    
    private func bindTimestamp(date: Date?) {
        timestampLabel.text = (date != nil) ? date!.getCardTimestamp() : ""
    }
    
    private func bindThumbnail(imageUrl: String?) {
        if let imageUrl = imageUrl {
            thumbnailImageView.setSquareImage(imageUrl: imageUrl, gifSupport: true)
        } else {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
    }

    func setupEvents() {
        let titleTapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(titleTapGesture)
        titleLabel.isUserInteractionEnabled = true
        titleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.titleTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        let timestampTapGesture = UITapGestureRecognizer()
        timestampLabel.addGestureRecognizer(timestampTapGesture)
        timestampLabel.isUserInteractionEnabled = true
        timestampTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.timestampTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        playButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if let script = self.post.codeSnippet, let url = URL(string: script) {
                self.onStartInAppBrowser.onNext(url)
            }
        }).disposed(by: disposeBag)
        
        shahidButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if let script = self.post.codeSnippet, let url = URL(string: script) {
                self.onStartInAppBrowser.onNext(url)
            }
        }).disposed(by: disposeBag)
    }
}
