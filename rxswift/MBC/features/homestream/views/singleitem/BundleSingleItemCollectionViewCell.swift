//
//  BundleSingleItemCollectionViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen on 3/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class BundleSingleItemCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var moreItemLabel: UILabel!
    
    private var accentColor: UIColor!
    var thumbnailTapped = PublishSubject<Void>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.handleGifReuse()
    }
    
    func bindData(thumbnail: String?, selected: Bool, accentColor: UIColor?, moreItemNumber: Int) {
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        if let thumbnail = thumbnail {
            imageView.setSquareImage(imageUrl: thumbnail)
        } else {
            imageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
        if selected {
            imageView.borderWidth = Constants.DefaultValue.bundleCarouselImageViewBorderWidth
            imageView.borderColor = self.accentColor
        } else {
            imageView.borderWidth = 0.0
        }
        moreItemLabel.text = (moreItemNumber == 0) ? "" : "+\(moreItemNumber)"
        setupEvents()
    }
    
    func setupEvents() {
        imageView.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer()
        imageView.addGestureRecognizer(imageTapGesture)
        
        imageTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.thumbnailTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func select(isSelected: Bool) {
        if isSelected {
            imageView.borderWidth = Constants.DefaultValue.bundleCarouselImageViewBorderWidth
            imageView.borderColor = accentColor
        } else {
            imageView.borderWidth = 0.0
        }
    }
}
