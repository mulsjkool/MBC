//
//  EpisodeHeaderCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class EpisodeHeaderCell: BaseCardTableViewCell {
    
    @IBOutlet weak private var thumbnailImageview: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var shahidButton: UIButton!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var episodeDescriptionLabelTopConstraint: NSLayoutConstraint!
    
    private let labelTopMargin: CGFloat = 12.0
    
    let onStartInAppBrowserWithShahidEmbedded = PublishSubject<(URL, String?)>()
    
    private var post: Post? {
        return feed as? Post
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

    func bindData(post: Post, accentColor: UIColor?) {
        super.bindData(feed: post, accentColor: accentColor)
        bindTitle(title: post.episodeTitle)
        bindEpisodeDescription(description: post.description)
        bindThumbnail(imageUrl: post.episodeThumbnail)
        setupEvents()
    }
    
    private func bindTitle(title: String?) {
        titleLabel.text = title ?? ""
        titleLabelTopConstraint.constant = titleLabel.text!.isEmpty ? 0 : labelTopMargin
    }
    
    private func bindEpisodeDescription(description: String?) {
        descriptionLabel.text = description ?? ""
        episodeDescriptionLabelTopConstraint.constant = titleLabel.text!.isEmpty ? 0 : labelTopMargin
    }
    
    private func bindThumbnail(imageUrl: String?) {
        if let imageUrl = imageUrl {
            thumbnailImageview.setSquareImage(imageUrl: imageUrl, gifSupport: true)
        } else {
            thumbnailImageview.image = Constants.DefaultValue.defaulNoLogoImage
        }
    }
    
    func setupEvents() {
        playButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if let post = self.post, let script = post.codeSnippet, let url = URL(string: script) {
                self.onStartInAppBrowserWithShahidEmbedded.onNext((url, post.appStore))
            }
        }).disposed(by: disposeBag)
        
        shahidButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            if let post = self.post, let script = post.codeSnippet, let url = URL(string: script) {
                self.onStartInAppBrowserWithShahidEmbedded.onNext((url, post.appStore))
            }
        }).disposed(by: disposeBag)
    }
}
