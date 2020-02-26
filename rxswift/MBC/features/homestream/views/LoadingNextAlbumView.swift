//
//  LoadingNextAlbumView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/5/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import KDCircularProgress
import TTTAttributedLabel
import MisterFusion
import SKPhotoBrowser

class LoadingNextAlbumView: UIView, SKPhotoProtocol {

    open var index: Int = 0
    open var scrollEnable: Bool = false
    open var underlyingImage: UIImage!
    open var customView: UIView?
    open var caption: String?
    open var shouldCachePhotoURLImage: Bool = false
    open var photoURL: String!
    
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var progressView: KDCircularProgress!
	@IBOutlet private weak var coverImageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nextAlbumLabel: UILabel!

	private var progressColor = Colors.unselectedTabbarItem.color()
	var progressFinish = PublishSubject<Void>()
	var disposeBag = CompositeDisposable()
    
    open func checkCache() { }
    
    open func loadUnderlyingImageAndNotify() {
        self.backgroundColor = UIColor.orange
        print("\nSET ORANGE NE")
    }
    
    open func loadUnderlyingImageComplete() {
    }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
        
        self.customView = self
        
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.loadingNextAlbumView.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
	}
	
	func bindData(album: Album) {
        nextAlbumLabel.text = R.string.localizable.commonNextAlbumTitle()
		if let title = album.title {
			titleLabel.text = title
		}
		if let cover = album.cover {
			coverImageView.setImage(from: cover, resolution: .ar16x9)
		}
	}
	
	private func configProgressView() {
		progressView.trackColor = Colors.black.color()
		progressView.progressColors = [progressColor]
		progressView.angle = 0
	}
	
	func startUpdateProgess() {
		configProgressView()
		progressView.animate(toAngle: 360, duration: Components.instance.configurations.nextAlbumLoadingTime,
							 completion: { [weak self] _ in
			self?.progressFinish.onNext(())
		})
	}
}
