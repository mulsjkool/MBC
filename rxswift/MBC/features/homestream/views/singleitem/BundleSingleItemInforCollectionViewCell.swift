//
//  BundleSingleItemInforCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class BundleSingleItemInforCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak private var typeImageView: UIImageView!
    @IBOutlet weak private var bundleTitleLabel: UILabel!
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var authorView: AvatarFullScreenView!
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var itemTitleLabel: UILabel!
    @IBOutlet weak private var likeCountLabel: UILabel!
    @IBOutlet weak private var likeCommentCountSeparatedLabel: UILabel!
    @IBOutlet weak private var commentCountLabel: UILabel!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var itemTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var gradientTopView: UIView!
    @IBOutlet weak private var gradientBottomView: UIView!
    @IBOutlet weak private var inforView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
    }
    
    var timestampTapped: PublishSubject<Void> {
        return authorView.timestampTapped
    }
    var authorAvatarTapped: PublishSubject<Void> {
        return authorView.authorAvatarTapped
    }
    var authorNameTapped: PublishSubject<Void> {
        return authorView.authorNameTapped
    }
    let didChangeInterestView = PublishSubject<Void>()
    let bundleTitleTapped = PublishSubject<Void>()
    let itemTitleTapped = PublishSubject<Void>()
    var thumbnailTapped = PublishSubject<Void>()
    var commentCountTapped = PublishSubject<Void>()
    var likeCountTapped = PublishSubject<Void>()
    var didFillGradient = false
    
    private var feed: Feed!
    
    func bindData(feed: Feed, bundleTitle: String?) {
        self.feed = feed
        if !didFillGradient {
            fillGradient()
            didFillGradient = true
        }
        bindAuthor()
        bindThumnail()
        bindBundleTitle(bundleTitle: bundleTitle)
        bindTypeImageView()
        bindInterestAndLabel()
        bindItemTitle()
        bindLikeAndCommentNo()
        setupEvents()
    }
    
    private func fillGradient() {
        layoutIfNeeded()
        Common.fillGradientFor(view: gradientTopView,
                               colors: Constants.DefaultValue.gradientTopForBundleSingleItem,
                               locations: Constants.DefaultValue.gradientLocationTopForBundleSingleItem)
        Common.fillGradientFor(view: gradientBottomView,
                               colors: Constants.DefaultValue.gradientBottomForBundleSingleItem,
                               locations: Constants.DefaultValue.gradientLocationBottomForBundleSingleItem)
    }
    
    private func bindThumnail() {
        thumbnailImageView.handleGifReuse()
        guard let thumbnail = feed.thumbnail else {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
            return
        }
        thumbnailImageView.setSquareImage(imageUrl: thumbnail)
    }
    
    private func bindAuthor() {
        guard let feed = feed, let author = feed.author, let authorView = authorView else { return }
        authorView.bindData(author, publishedDate: feed.publishedDate, contentType: feed.type,
                            subType: feed.subType, isFullScreen: false, shouldUseFollower: false,
                            defaultAvatarImage: R.image.iconNoLogo())
        authorView.bindContentTypeForAppCard(contentType: feed.type, subType: feed.subType)
        authorView.setAllTextColor(color: UIColor.white)
    }
    
    private func bindBundleTitle(bundleTitle: String?) {
        bundleTitleLabel.text = bundleTitle ?? ""
        itemTitleLabelTopConstraint.constant = bundleTitleLabel.text!.isEmpty ? 0 :
            Constants.DefaultValue.defaultMarginTitle
    }
    
    private func bindItemTitle() {
        itemTitleLabel.text = feed.title ?? ""
    }
    
    private func bindInterestAndLabel() {
        if let feed = feed, let interestView = interestView {
            interestView.bindInterests(interests: feed.interests, isExpanded: feed.isInterestExpanded)
            interestView.bindLabel(label: feed.label, isExpanded: feed.isInterestExpanded)
            interestView.applyColor(accentColor: Colors.white.color(), textColor: Colors.dark.color())
            interestView.disposeBag.addDisposables([
                interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                    self.interestViewHeightConstraint.constant = viewHeight
                    self.layoutIfNeeded()
                    self.didChangeInterestView.onNext(())
                }),
                interestView.didExpand.subscribe(onNext: { _ in
                    feed.isInterestExpanded = true
                })
            ])
            interestView.reLayoutConstraints()
        }
    }

    private func bindTypeImageView() {
        if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType) {
            switch type {
            case .image:
                typeImageView.isHidden = false
                typeImageView.image = R.image.iconBundlePhoto()
            case .video:
                typeImageView.isHidden = false
                typeImageView.image = R.image.iconBundleVideo()
            default:
                typeImageView.isHidden = true
            }
        } else {
            typeImageView.isHidden = true
        }
    }
    
    private func bindLikeAndCommentNo() {
        let commentCount = feed.numOfComments ?? 0
        if commentCount > 0 {
            commentCountLabel.text = R.string.localizable.cardCommentcountTitle("\(commentCount)").localized()
        } else {
            commentCountLabel.text = ""
        }
        
        let likeCount = feed.numOfLikes ?? 0
        if likeCount > 0 {
            likeCountLabel.text = R.string.localizable.cardLikecountTitle("\(likeCount)").localized()
        } else {
            likeCountLabel.text = ""
        }
        likeCommentCountSeparatedLabel.isHidden = (likeCount == 0 || commentCount == 0)
    }
    
    private func setupEvents() {
        bundleTitleLabel.isUserInteractionEnabled = true
        let bundleTitleTapGesture = UITapGestureRecognizer()
        bundleTitleLabel.addGestureRecognizer(bundleTitleTapGesture)
        
        bundleTitleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.bundleTitleTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        itemTitleLabel.isUserInteractionEnabled = true
        let itemTitleTapGesture = UITapGestureRecognizer()
        itemTitleLabel.addGestureRecognizer(itemTitleTapGesture)
        
        itemTitleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.itemTitleTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        inforView.isUserInteractionEnabled = true
        let thumbnailTapGesture = UITapGestureRecognizer()
        inforView.addGestureRecognizer(thumbnailTapGesture)
        
        thumbnailTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.thumbnailTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        likeCountLabel.isUserInteractionEnabled = true
        let likeCountTapGesture = UITapGestureRecognizer()
        likeCountLabel.addGestureRecognizer(likeCountTapGesture)
        
        likeCountTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.likeCountTapped.onNext(())
            })
            .disposed(by: disposeBag)
        
        commentCountLabel.isUserInteractionEnabled = true
        let commentCountTapGesture = UITapGestureRecognizer()
        commentCountTapGesture.cancelsTouchesInView = false
        commentCountLabel.addGestureRecognizer(commentCountTapGesture)
        
        commentCountTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.commentCountTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
