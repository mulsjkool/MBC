//
//  StarPageListingCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class StarPageListingCell: BaseTableViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var occupationsLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    
    let didTapThumbnail = PublishSubject<Star>()
    let didTapTitle = PublishSubject<Star>()
    let didTapOccupations = PublishSubject<Star>()
    
    private var star: Star!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
    }
    
    func bindData(star: Star, isSearchingPage: Bool = false) {
        self.star = star
        bindThumbnail(image: star.photo)
        bindAppTitle(title: star.title)
        if isSearchingPage {
            bindPageMetadata(metadata: star.metadata)
        } else {
            bindOccupationsLabel(occupations: star.occupations)
        }
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
        titleLabel.text = title ?? ""
    }
    
    private func bindOccupationsLabel(occupations: [String]?) {
        occupationsLabel.text = ""
        if let arrString = occupations, !arrString.isEmpty {
            occupationsLabel.text = arrString.joined(separator:
                Constants.DefaultValue.UserProfileAddressSeparatorString)
        }
    }
    
    private func bindPageMetadata(metadata: String?) {
        occupationsLabel.text = metadata ?? ""
    }
    
    private func setupEvents() {
        titleLabel.isUserInteractionEnabled = true
        let titleTapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(titleTapGesture)
        
        titleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapTitle.onNext(self.star)
            })
            .disposed(by: disposeBag)
        
        thumbnailImageView.isUserInteractionEnabled = true
        let thumbnailTapGesture = UITapGestureRecognizer()
        thumbnailImageView.addGestureRecognizer(thumbnailTapGesture)
        
        thumbnailTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapThumbnail.onNext(self.star)
            })
            .disposed(by: disposeBag)
        
        occupationsLabel.isUserInteractionEnabled = true
        let occupationsTapGesture = UITapGestureRecognizer()
        occupationsLabel.addGestureRecognizer(occupationsTapGesture)
        
        occupationsTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapOccupations.onNext(self.star)
            })
            .disposed(by: disposeBag)
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        guard let photo = star.photo, photo.isAGif else { return (isVideo: false, shouldResume: false) }
        
        let gifHeight = thumbnailImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + thumbnailImageView.convert(thumbnailImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? thumbnailImageView.resumeGifAnimation() : thumbnailImageView.pauseGifAnimation()
        return (isVideo: false, shouldResume: false) /// TODO: To be updated
    }
}
