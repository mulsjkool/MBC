//
//  PhotoAlbumsCarouselTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import MisterFusion
import RxSwift
import UIKit
import iCarousel
class PhotoAlbumsCarouselTableViewCell: BaseTableViewCell {

	@IBOutlet private weak var carouselView: iCarousel!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var totalLabel: UILabel!
	@IBOutlet private weak var imageLabel: UILabel!
    var widthOfAlbumItem: CGFloat = 228
    var heightOfAlbumItem: CGFloat = 229
    var albums: ItemList!
    var itemCount: Int = 0
    var selectingMenu = PageMenuEnum.undefine
	//let didTapAlbum = PublishSubject<(String, Int)>()
	let didTapAlbum = PublishSubject<Album>()
    let didTapPlaylist = PublishSubject<VideoPlaylist>()
    var accentColor: UIColor?

    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
	
    // MARK: Public
    func bindData(albums: ItemList, selectingMenu: PageMenuEnum, accentColor: UIColor?) {
		self.albums = albums
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        itemCount = albums.list.count
        self.selectingMenu = selectingMenu
        formatLanguage()
		setTotalLabel(albums.grandTotal)
        if !Constants.Singleton.isiPad {
            setupCarousel()
            carouselView.scrollToItem(at: 0, animated: false)
        }
	}
    
    func createItemViewAt(index: Int, data: Any) -> UIView {
        if data is VideoPlaylist { return createVideoPlaylistItemView(index: index) }
        if data is Album { return createPhotoAlbumItemView(index: index) }
        return UIView()
    }

    // MARK: Private
	private func resetView() {
        if !Constants.Singleton.isiPad { carouselView.isScrollEnabled = true }
		self.totalLabel.isHidden = true
        self.imageLabel.text = ""
	}
	
    private func formatLanguage() {
        if !Constants.DefaultValue.shouldRightToLeft {
            self.imageLabel.textAlignment = .left
            self.totalLabel.textAlignment = .right
        }
        if selectingMenu == .photos { formatLanguageForPhotoTab() } else { formatLanguageForVideoTab() }
    }
    
	private func formatLanguageForPhotoTab() {
		self.imageLabel.text = R.string.localizable.commonLabelImage().localized()
		self.titleLabel.text = R.string.localizable.commonLabelAlbums().localized()
	}
    
    private func formatLanguageForVideoTab() {
        self.imageLabel.text = R.string.localizable.cardTypeVideo().localized()
        self.titleLabel.text = R.string.localizable.commonLabelVideoplaylist().localized()
    }
	
	private func setTotalLabel(_ value: Int) {
		self.totalLabel.text = "(\(value))"
		self.totalLabel.isHidden = false
	}
	
	private func setupCarousel() {
		if albums.list.count == 1 { carouselView.isScrollEnabled = false }
			// duplicate items when have 2 item
		else if albums.list.count == 2 { albums.addAll(list: albums.list) }
		carouselView.delegate = self
		carouselView.dataSource = self
		carouselView.type = .linear
		carouselView.isPagingEnabled = true
        carouselView.centerItemWhenSelected = false
		if Constants.DefaultValue.shouldRightToLeft {
			carouselView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
		}
		// set viewpointOffset to ensure first item always align right(arabic) or left
		let offSet = (Constants.DeviceMetric.screenWidth - widthOfAlbumItem) / 2 - (Constants.DefaultValue.defaultMargin / 2)
		carouselView.viewpointOffset = CGSize(width: CGFloat(offSet), height: CGFloat(0))
        carouselView.reloadData()
	}
	
	@objc
	private func tapOnItemAlbumView(sender: UIGestureRecognizer) {
		if let albumView = sender.view {
			let index: Int = albumView.tag
			if let album = self.albums.list[index] as? Album, album.contentId != nil {
				didTapAlbum.onNext(album)
			}
		}
	}
    
    private func createPhotoAlbumItemView(index: Int) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: widthOfAlbumItem, height: heightOfAlbumItem)
        let albumItemView = PhotoAlbumICarouselItemView(frame: rect)
        if !Constants.Singleton.isiPad {
            if Constants.DefaultValue.shouldRightToLeft {
                albumItemView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
        }
        albumItemView.tag = index
        albumItemView.disposeBag.addDisposables([
            albumItemView.didTapAlbum.subscribe(onNext: { [weak self] album in
                self?.didTapAlbum.onNext(album)
            })
        ])
        return albumItemView
    }
    
    private func createVideoPlaylistItemView(index: Int) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: widthOfAlbumItem, height: heightOfAlbumItem)
        let videoItemView = VideoPlaylistCarouselItemView(frame: rect)
        if !Constants.Singleton.isiPad {
            if Constants.DefaultValue.shouldRightToLeft {
                videoItemView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
        }
        videoItemView.disposeBag.addDisposables([
            videoItemView.didTapPlaylist.subscribe(onNext: { [weak self] videoPlaylist in
                self?.didTapPlaylist.onNext(videoPlaylist)
            })
        ])
        videoItemView.tag = index
        return videoItemView
    }
}

extension PhotoAlbumsCarouselTableViewCell: iCarouselDelegate, iCarouselDataSource {
	func numberOfItems(in carousel: iCarousel) -> Int {
		return itemCount
	}
	
	func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
		var itemView: UIView
        let itemData = self.albums.list[index]
		if let view = view as? PhotoAlbumICarouselItemView { itemView = view } else {
            itemView = createItemViewAt(index: index, data: itemData)
		}
        
        // bind data
        if itemView is VideoPlaylistCarouselItemView, let videoPlaylist = itemData as? VideoPlaylist {
            (itemView as? VideoPlaylistCarouselItemView)?.bindData(videoPlaylist: videoPlaylist,
                                                                   accentColor: accentColor)
        } else if itemView is PhotoAlbumICarouselItemView, let album = itemData as? Album {
            (itemView as? PhotoAlbumICarouselItemView)?.bindData(album: album, accentColor: accentColor)
        }
		return itemView
	}
	
	func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
		switch option {
		case .wrap:
			return 1
		default:
			return value
		}
	}
}
