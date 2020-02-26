//
//  VideoPlaylistCarouselItemView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import MisterFusion

class VideoPlaylistCarouselItemView: UIView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var likeCommentCountLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var iconPlaylistImageView: UIImageView!
    @IBOutlet private weak var interestView: InterestView!
    
    private var videoPlaylist: VideoPlaylist!
    var disposeBag = DisposeBag()
    let didTapPlaylist = PublishSubject<VideoPlaylist>()
    var accentColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.videoPlaylistCarouselItemView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        disposeBag = DisposeBag()
    }
    
    func bindData(videoPlaylist: VideoPlaylist, accentColor: UIColor?) {
        self.videoPlaylist = videoPlaylist
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        setThumbnailImageview()
        setInterest()
        setTitle()
        updateSocialCount()
        showTotalLabel()
        setUpTapViewToOpenVideoPlaylist(views: thumbnailImageView, titleLabel, countLabel, iconPlaylistImageView)
    }
    
    private func setThumbnailImageview() {
        self.thumbnailImageView.clipsToBounds = true
        guard let thumbnailUrl = videoPlaylist.defaultVideo?.videoThumbnail else {
            thumbnailImageView.image = R.image.iconPhotoPlaceholder()
            return
        }
        thumbnailImageView.setSquareImage(imageUrl: thumbnailUrl,
                                               placeholderImage: R.image.iconPhotoPlaceholder())
    }
    
    private func setUpTapViewToOpenVideoPlaylist(views: UIView...) {
        for view in views {
            view.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer()
            view.addGestureRecognizer(tapGesture)
            tapGesture.rx.event
                .asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.didTapPlaylist.onNext(self.videoPlaylist)
                })
                .disposed(by: disposeBag)
        }
    }
    private func showTotalLabel() {
        countLabel.text = R.string.localizable.commonVideoTitleCount("\(videoPlaylist.total)")
        countLabel.isUserInteractionEnabled = true
        
    }
    
    private func updateSocialCount() {
        var array = [String]()
        
        if videoPlaylist.numberOfLikes > 0 {
            let textNumberOfLike = R.string.localizable.cardLikecountTitle("\(videoPlaylist.numberOfLikes)")
            array.append(textNumberOfLike)
        }
        if videoPlaylist.numberOfComments > 0 {
            let textNumberOfComments = R.string.localizable.cardCommentcountTitle("\(videoPlaylist.numberOfComments)")
            array.append(textNumberOfComments)
        }
        
        guard !array.isEmpty else { return }
        
        self.likeCommentCountLabel.text = array.map({ "\($0)" })
            .joined(separator: Constants.DefaultValue.MetadataSeparatorString)
    }
    
    private func setInterest() {
        guard let interest = videoPlaylist.interests else {
            interestView.bindInterests(interests: [""], isExpanded: false)
            return
        }
        interestView.bindInterests(interests: interest, isExpanded: videoPlaylist.isInterestExpanded)
        interestView.setInterestLabelFont(font: Constants.DefaultValue.interestLabelFont!)
        interestView.applyAccentColor(accentColor: accentColor)
        interestView.reLayoutConstraintsForPlaylistCarousel()
    }
    
    private func setTitle() {
        self.titleLabel.text = videoPlaylist.title ?? ""
    }
}
