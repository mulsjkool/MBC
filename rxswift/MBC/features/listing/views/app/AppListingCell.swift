//
//  AppListingCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/22/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class AppListingCell: BaseCampaignTableViewCell {
    
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var appTitleLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var participantNumberLabel: UILabel!
    
    let didTapThumbnail = PublishSubject<App>()
    let didTapAppTitle = PublishSubject<App>()
    let didTapAuthorName = PublishSubject<App>()
    private var app: App!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
    }

    func bindData(app: App) {
        self.app = app

        if let mapCampaign = app.mapCampaign {
            bindMapCampaign(mapCampaign: mapCampaign)
        }

        bindThumbnail(image: app.photo)
        bindAppTitle(title: app.title)
        bindType(type: app.type, subType: app.subType)
        binAuthorName(authorName: app.author?.name)
        participantNumberLabel.text = ""
        setupEvents()
    }
    
    private func bindThumbnail(image: Media?) {
        if let image = image {
            thumbnailImageView.setImage(from: image, resolution: .ar16x16, gifSupport: true)
        } else {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
    }
    
    private func bindAppTitle(title: String?) {
        appTitleLabel.text = title ?? ""
    }
    
    private func bindType(type: String?, subType: String?) {
        guard let type = type, let feedType = FeedType(rawValue: type), feedType == .app,
            let subType = subType, let appSubType = AppSubType(rawValue: subType) else {
            typeLabel.text = ""
            return
        }
        typeLabel.text = appSubType.localizedContentType()
    }
    
    private func binAuthorName(authorName: String?) {
        authorNameLabel.text = authorName ?? ""
    }
    
    private func setupEvents() {
        authorNameLabel.isUserInteractionEnabled = true
        let authorNameTapGesture = UITapGestureRecognizer()
        authorNameLabel.addGestureRecognizer(authorNameTapGesture)
        
        authorNameTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapAuthorName.onNext(self.app)
            })
            .disposed(by: disposeBag)
        
        thumbnailImageView.isUserInteractionEnabled = true
        let thumbnailTapGesture = UITapGestureRecognizer()
        thumbnailImageView.addGestureRecognizer(thumbnailTapGesture)
        
        thumbnailTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapThumbnail.onNext(self.app)
            })
            .disposed(by: disposeBag)
        
        appTitleLabel.isUserInteractionEnabled = true
        let appTitleTapGesture = UITapGestureRecognizer()
        appTitleLabel.addGestureRecognizer(appTitleTapGesture)
        
        appTitleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapAppTitle.onNext(self.app)
            })
            .disposed(by: disposeBag)
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        guard let photo = app.photo, photo.isAGif else { return (isVideo: false, shouldResume: false) }
        
        let gifHeight = thumbnailImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + thumbnailImageView.convert(thumbnailImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? thumbnailImageView.resumeGifAnimation() : thumbnailImageView.pauseGifAnimation()
        return (isVideo: false, shouldResume: false) /// TODO: To be updated
    }
}

extension AppListingCell: IAnalyticsTrackingCell {

    func getTrackingObjects() -> [IAnalyticsTrackingObject] {
        return [AnalyticsApp(app: app)] + analyticsCampaigns
    }

}
