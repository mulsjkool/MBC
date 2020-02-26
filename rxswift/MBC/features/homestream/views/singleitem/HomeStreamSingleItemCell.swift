//
//  HomeStreamSingleItemCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/18/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import TTTAttributedLabel
import MisterFusion
import RxSwift
import UIKit

class HomeStreamSingleItemCell: BaseCardTableViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var inforView: UIView!
    @IBOutlet weak private var gradientTopView: UIView!
    @IBOutlet weak private var gradientExpandBottomView: UIView!
    @IBOutlet weak private var gradientBottomView: UIView!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    private var gradientViewTag: Int = 100
    private var gradientTopLayer = CAGradientLayer()
    private var gradientExpandBottomLayer = CAGradientLayer()
    private var gradientBottomLayer = CAGradientLayer()
    var videoPlayerTapped = PublishSubject<Video>()
    
    var singleImage: Media?
    
    let thumbnailTapped = PublishSubject<Void>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fillGradient()
        }
    }
    
    override func bindData(feed: Feed, accentColor: UIColor?) {
        super.bindData(feed: feed, accentColor: accentColor)
        bindTitleLabel()
        bindDescription()
        applyColors()
        bindThumnail()
        setupEvents()
    }
    
    func getThumbnailImageView() -> UIImageView {
        return thumbnailImageView
    }
    
    func getGradientTopView() -> UIView {
        return gradientTopView
    }
    
    func getGradientBottomView() -> UIView {
        return gradientBottomView
    }
    
    @objc
    private func fillGradient() {
        fillGradientTop()
        fillGradientWhenDescriptionExpend()
        fillGradientBottom()
    }
    
    private func fillGradientTop() {
        var gradientView = gradientTopView.viewWithTag(gradientViewTag)
        if gradientView == nil {
            gradientView = UIView()
            gradientView!.tag = gradientViewTag
            gradientView?.translatesAutoresizingMaskIntoConstraints = false
            gradientTopView.insertSubview(gradientView!, at: 0)
            gradientTopView.mf.addConstraints([
                gradientView!.top |==| gradientTopView.top,
                gradientView!.leading |==| gradientTopView.leading,
                gradientView!.trailing |==| gradientTopView.trailing,
                gradientView!.bottom |==| gradientTopView.bottom
            ])
            
        } else { gradientTopLayer.removeFromSuperlayer() }
        gradientTopLayer = CAGradientLayer()
        gradientTopLayer.frame = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth,
                                     height: gradientTopView.frame.size.height)
        gradientTopLayer.colors = Constants.DefaultValue.gradientTopForSingleItem
        gradientTopLayer.locations = Constants.DefaultValue.gradientLocationTopForSingleItem
        gradientView!.backgroundColor = UIColor.clear
        gradientView!.layer.insertSublayer(gradientTopLayer, at: 0)
    }
    
    private func fillGradientWhenDescriptionExpend() {
        guard isTextExpanded else { return }
        gradientBottomView.isHidden = true
        gradientExpandBottomView.isHidden = false
        var gradientView = gradientExpandBottomView.viewWithTag(gradientViewTag)
        if gradientView == nil {
            gradientView = UIView()
            gradientView!.tag = gradientViewTag
            gradientView?.translatesAutoresizingMaskIntoConstraints = false
            gradientExpandBottomView.insertSubview(gradientView!, at: 0)
            gradientExpandBottomView.mf.addConstraints([
                gradientView!.top |==| gradientExpandBottomView.top,
                gradientView!.leading |==| gradientExpandBottomView.leading,
                gradientView!.trailing |==| gradientExpandBottomView.trailing,
                gradientView!.bottom |==| gradientExpandBottomView.bottom
            ])
            
        } else { gradientExpandBottomLayer.removeFromSuperlayer() }
        gradientExpandBottomLayer = CAGradientLayer()
        gradientExpandBottomLayer.frame = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth,
                                           height: gradientExpandBottomView.frame.size.height)
        gradientExpandBottomLayer.colors = Constants.DefaultValue.gradientBottomForSingleItem
        gradientExpandBottomLayer.locations = Constants.DefaultValue.gradientLocationExpandBottomForSingleItem
        gradientView!.backgroundColor = UIColor.clear
        gradientView!.layer.insertSublayer(gradientExpandBottomLayer, at: 0)
    }
    
    private func fillGradientBottom() {
        guard !isTextExpanded else { return }
        var gradientView = gradientBottomView.viewWithTag(gradientViewTag)
        if gradientView == nil {
            gradientView = UIView()
            gradientView!.tag = gradientViewTag
            gradientView?.translatesAutoresizingMaskIntoConstraints = false
            gradientBottomView.insertSubview(gradientView!, at: 0)
            gradientBottomView.mf.addConstraints([
                gradientView!.top |==| gradientBottomView.top,
                gradientView!.leading |==| gradientBottomView.leading,
                gradientView!.trailing |==| gradientBottomView.trailing,
                gradientView!.bottom |==| gradientBottomView.bottom
            ])
            
        } else { gradientBottomLayer.removeFromSuperlayer() }
        gradientBottomLayer = CAGradientLayer()
        gradientBottomLayer.frame = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth,
                                       height: gradientBottomView.frame.size.height)
        gradientBottomLayer.colors = Constants.DefaultValue.gradientBottomForSingleItem
        gradientBottomLayer.locations = Constants.DefaultValue.gradientLocationBottomForSingleItem
        gradientView!.backgroundColor = UIColor.clear
        gradientView!.layer.insertSublayer(gradientBottomLayer, at: 0)
    }
    
    func setupEvents() {
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
        
        titleLabel.isUserInteractionEnabled = true
        let titleTapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(titleTapGesture)
        
        titleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.titleTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    override func expandCardTextLabel(label: TTTAttributedLabel!) {
        super.expandCardTextLabel(label: label)
        fillGradientWhenDescriptionExpend()
    }
    
    override func bindAuthor() {
        guard let feed = feed else {
            return
        }
        let authorView = getAuthorView()
        authorView.bindData(feed.author, publishedDate: feed.publishedDate, contentType: feed.type,
                                 subType: feed.subType, isFullScreen: false, shouldUseFollower: false,
                                 defaultAvatarImage: R.image.iconNoLogo())
        authorView.bindContentTypeForAppCard(contentType: feed.type, subType: feed.subType)
        authorView.setAllTextColor(color: UIColor.white)
    }
    
    func bindTitleLabel() {
        titleLabel.text = feed.title ?? ""
        titleLabelTopConstraint.constant = (titleLabel.text?.isEmpty)! ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
    }
    
    func bindThumnail() {
        if let post = feed as? Post {
            guard let images = post.medias, !images.isEmpty else { return }
            if let defaultImageId = post.defaultImageId {
                images.filter { $0.id == defaultImageId }.forEach { bindThumnail(image: $0, resolution: .ar27x40) }
            } else {
                bindThumnail(image: images[0], resolution: .ar27x40)
            }
        }
        
        if let article = feed as? Article {
            bindThumnail(image: article.photo, resolution: .ar27x40)
        }
        
        if let app = feed as? App {
            bindThumnail(image: app.photo, resolution: .ar27x40)
        }
    }
    
    func bindThumnail(image: Media?, resolution: ImageResolution) {
        if let image = image {
            thumbnailImageView.setImage(from: image, resolution: resolution)
        } else {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
        singleImage = image
    }
    
    func bindThumnailFrom(imageUrl: String) {
        thumbnailImageView.setSquareImage(imageUrl: imageUrl)
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        guard let firstImg = self.singleImage, firstImg.isAGif else { return (isVideo: false, shouldResume: false) }
        
        let gifHeight = thumbnailImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + thumbnailImageView.convert(thumbnailImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? thumbnailImageView.resumeGifAnimation() : thumbnailImageView.pauseGifAnimation()
        return (isVideo: false, shouldResume: false) /// TODO: To be updated
    }
    
    func applyColors() {
        getInterestView().applyColor(accentColor: Colors.white.color(), textColor: Colors.dark.color())
        applyLikeCommentShareViewColor(textColor: Colors.white.color())
    }

    private func applyLikeCommentShareViewColor(textColor: UIColor) {
        getLikeCommentShareView().setTextColorForCountComment(textColor)
        getLikeCommentShareView().setupImagesForSingleCardCell()
    }
}
