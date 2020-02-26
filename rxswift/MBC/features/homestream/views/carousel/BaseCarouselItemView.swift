//
//  BaseCarouselItemView.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxSwift

class BaseCarouselItemView: BaseCollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var isInfoComponent: Bool = false
    var willShowMetadata: Bool = true
    private var defaultImageIndex = 0
    var feed: Feed!
    var thumbnailTapped = PublishSubject<(Feed, Int)>()
    var titleTapped = PublishSubject<(Feed, Int)>()
    
    func bindData(_ feed: Feed) {
        self.feed = feed
        setImage()
        setTitle()
        setupEvents()
    }
    
    func bindData(_ feed: Feed, isInfoComponent: Bool = false, willShowMetadata: Bool = true) {
        self.isInfoComponent = isInfoComponent
        self.willShowMetadata = willShowMetadata
        bindData(feed)
    }
    
    func getImageView() -> UIImageView {
        return imageView
    }
    
    func getTitleLabel() -> UILabel {
        return titleLabel
    }
    
    private func setImage() {
        self.imageView.handleGifReuse()
        
        if let bundle = feed as? BundleContent {
            if let thumbnail = bundle.thumbnail {
                imageView.setSquareImage(imageUrl: thumbnail)
            } else {
                imageView.image = R.image.iconPhotoPlaceholder()
            }
            return
        }
        
        if let playlist = feed as? Playlist {
            if let thumbnail = playlist.thumbnail {
                imageView.setSquareImage(imageUrl: thumbnail)
            } else {
                imageView.image = R.image.iconPhotoPlaceholder()
            }
            return
        }
        
        if let page = feed as? Page {
            let placeholder = isInfoComponent ? R.image.iconDefaultPoster() : nil
            if let image = page.poster {
                self.imageView.setImage(from: image, resolution: .ar27x40, gifSupport: false, placeholder: placeholder)
            } else {
                let color = page.headerColor ?? Colors.defaultPageCarouselHeaderColor.color()
                self.imageView.image = nil
                self.imageView.backgroundColor = color
            }
            self.imageView.addRemoveVideoWatermark(toRemove: true)
            return
        }
        
        if let app = feed as? App {
            if let photo = app.photo {
                self.imageView.setImage(from: photo, resolution: .ar16x16, gifSupport: false)
            } else {
                self.imageView.image = R.image.iconPhotoPlaceholder()
            }
            self.imageView.addRemoveVideoWatermark(toRemove: true)
            return
        }
        
        guard let image = self.image else {
            self.imageView.image = R.image.iconPhotoPlaceholder()
            return
        }
        
        self.imageView.setImage(from: image, resolution: .ar16x9, gifSupport: false)
        let isVideo = (feed as? Post)?.postSubType == .video
        self.imageView.addRemoveVideoWatermark(toRemove: !isVideo)
    }
    
    private func setTitle() {
        if let page = feed as? Page {
            self.titleLabel.text = page.name ?? ""
            return
        }
        self.titleLabel.text = feed.title ?? ""
    }
    
    private var image: Media? {
        if feed is Post {
            guard let post = (feed as? Post), let images = post.medias, let sType = post.postSubType else { return nil }
            
            if sType == .video, let video = images.first as? Video, let videoThumbnail = video.videoThumbnail {
                return Media(withImageUrl: videoThumbnail)
            }
            
            guard let defaultImageId = post.defaultImageId,
                let defaultIndex = images.index(where: { $0.id == defaultImageId }) else { return nil }
            defaultImageIndex = defaultIndex
            return images[defaultIndex]
        }
        if feed is Article {
            return (feed as? Article)?.photo
        }
        if feed is Page {
            return (feed as? Page)?.poster
        }
        return nil
    }
    
    private func setupEvents() {
        imageView.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer()
        imageView.addGestureRecognizer(imageTapGesture)
        
        imageTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.thumbnailTapped.onNext((self.feed, self.defaultImageIndex))
            })
            .disposed(by: disposeBag)
        
        titleLabel.isUserInteractionEnabled = true
        let titleTapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(titleTapGesture)
        
        titleTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.thumbnailTapped.onNext((self.feed, self.defaultImageIndex))
            })
            .disposed(by: disposeBag)
    }
}
