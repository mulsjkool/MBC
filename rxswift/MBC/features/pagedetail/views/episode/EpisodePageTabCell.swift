//
//  EpisodePageTabCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class EpisodePageTabCell: BaseTableViewCell {
    
    @IBOutlet weak private var thumbnailImageView: UIImageView!
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
    @IBOutlet weak private var likeShareCommentview: LikeCommentShareView!
    
    private var post: Post!
    private let defaultSeparatorWidth: CGFloat = 10.0
    
    let onStartInAppBrowserWithShahidEmbedded = PublishSubject<(URL, String?)>()
    let titleTapped = PublishSubject<Void>()
    let thumbnailTapped = PublishSubject<Void>()
    let timestampTapped = PublishSubject<Void>()
    var commentTapped: Observable<Likable> {
        return self.likeShareCommentview.commentTapped.asObservable()
    }
    var shareTapped: Observable<Likable> {
        return self.likeShareCommentview.shareTapped.asObservable()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if Constants.DefaultValue.shouldRightToLeft {
            shahidButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                                        right: Constants.DefaultValue.shahibButtonTextMargin)
            shahidButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                                        right: Constants.DefaultValue.shahibButtonImageMargin)
        } else {
            shahidButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constants.DefaultValue.shahibButtonTextMargin,
                                                        bottom: 0, right: 0)
            shahidButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: Constants.DefaultValue.shahibButtonImageMargin,
                                                        bottom: 0, right: 0)
        }
    }
    
    func bindData(post: Post, accentColor: UIColor?, season: String?, genre: String?) {
        self.post = post
        bindTitle(title: post.episodeTitle)
        bindSeason(season: season)
        bindGenre(genre: genre)
        bindTimestamp(date: post.publishedDate)
        bindLikeShareComment()
        bindThumbnail(imageUrl: post.episodeThumbnail)
        setupEvents()
    }
    
    private func bindTitle(title: String?) {
        titleLabel.text = title ?? ""
        titleLabelTopConstraint.constant = titleLabel.text!.isEmpty ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
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
    
    private func bindLikeShareComment() {
        if let post = post { likeShareCommentview.feed = post }
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
            self.thumbnailTapped.onNext(())
        }).disposed(by: disposeBag)
        
        shahidButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if let script = self.post.codeSnippet, let url = URL(string: script) {
                self.onStartInAppBrowserWithShahidEmbedded.onNext((url, self.post.appStore))
            }
        }).disposed(by: disposeBag)
    }
}
