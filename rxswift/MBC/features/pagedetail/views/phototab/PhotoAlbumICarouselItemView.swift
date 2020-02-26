//
//  PhotoAlbumICarouselItemView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/18/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import Kingfisher
import UIKit
import MisterFusion

class PhotoAlbumICarouselItemView: UIView {

	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var imageview: UIImageView!
	@IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var likeCommentCountLabel: UILabel!
    @IBOutlet private weak var interestView: InterestView!
    
    private var album: Album!
	var didTapAlbum = PublishSubject<Album>()
	var disposeBag = DisposeBag()
    var accentColor: UIColor?
    
	func bindData(album: Album, accentColor: UIColor?) {
		self.album = album
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
		setCoverImageview()
		setTitle()
        showTotalLabel()
        setInterest()
        updateSocialCount()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.photoAlbumICarouselItemView.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
	}
	
    private func showTotalLabel() {
        totalLabel.text = R.string.localizable.commonPhotosTitleCount("\(album.total)")
    }
    
	private func setCoverImageview() {
		self.imageview.clipsToBounds = true
        if let image = self.album.cover {
            self.imageview.setImage(from: image, resolution: .ar16x9, gifSupport: false)
        }
		let coverTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToOpenPhotoFullscreen))
		self.imageview.addGestureRecognizer(coverTapGesture)
	}
	
	private func setTitle() {
		self.articleTitleLabel.text = self.album.title ?? ""
		let titleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToOpenPhotoFullscreen))
		self.articleTitleLabel.addGestureRecognizer(titleTapGesture)
	}
	
	@objc
	private func tapToOpenPhotoFullscreen() {
		didTapAlbum.onNext(album)
	}
	
	private func setInterest() {
		guard let cover = album.cover, let interest = cover.interests else {
            interestView.bindInterests(interests: [""], isExpanded: false)
			return
		}
        interestView.bindInterests(interests: interest, isExpanded: cover.isInterestExpanded)
        interestView.setInterestLabelFont(font: Constants.DefaultValue.interestLabelFont!)
        interestView.applyAccentColor(accentColor: accentColor)
        interestView.reLayoutConstraintsForPlaylistCarousel()
	}
    
    private func updateSocialCount() {
        guard let cover = album.cover else {
            self.likeCommentCountLabel.text = ""
            return
        }
        var array = [String]()
        if cover.numberOfLikes >= 0 {
            let textNumberOfLike = R.string.localizable.cardLikecountTitle("\(cover.numberOfLikes)")
            array.append(textNumberOfLike)
        }
        if cover.numberOfComments >= 0 {
            let textNumberOfComments = R.string.localizable.cardCommentcountTitle("\(cover.numberOfComments)")
            array.append(textNumberOfComments)
        }
        
        guard !array.isEmpty else { return }
        
        self.likeCommentCountLabel.text = array.map({ "\($0)" })
            .joined(separator: Constants.DefaultValue.MetadataSeparatorString)
    }

}
