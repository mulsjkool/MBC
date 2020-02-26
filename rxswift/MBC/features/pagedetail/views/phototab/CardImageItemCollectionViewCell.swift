//
//  CardImageItemCollectionViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import MisterFusion
import UIKit
import RxSwift

class CardImageItemCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak private var imageview: UIImageView!
    @IBOutlet weak private var imageViewPlay: UIImageView!
    @IBOutlet weak private var lbSeeMore: UILabel!
	@IBOutlet weak private var viewSeeMore: UIView!
    @IBOutlet weak private var totalLabel: UILabel!
    @IBOutlet weak private var viewCount: UIView!
    var disposeBag = DisposeBag()
    var inlinePlayer: InlineTHEOPlayer!
    var video: Video? {
        didSet {
            guard let theVideo = video else { return }
            imageview.backgroundColor = Colors.black.color()
            if inlinePlayer == nil { inlinePlayer = InlineTHEOPlayer(inlineOfView: contentView) }
            inlinePlayer.video = theVideo
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageview.handleGifReuse()
        video = nil
        disposeBag = DisposeBag()
    }
    
    public func setImage(image: Media, shouldShowGifMark: Bool = true) {
        self.imageview.setImage(from: image, resolution: .ar16x9, gifSupport: !shouldShowGifMark)
        
        if inlinePlayer != nil && inlinePlayer.theoPlayer != nil, !inlinePlayer.theoPlayer.isDestroyed {
            inlinePlayer.prepareForReuse()
            inlinePlayer = nil
        }
	}
	
	public func getImageView() -> UIImageView {
		return self.imageview
	}
	
	public func showViewSeeMoreWithText(seeMoreNumber: String) {
		self.lbSeeMore.text = seeMoreNumber
		self.viewSeeMore.isHidden = false
	}
    
    public func hideImagePlay(showImage: Bool) {
        imageViewPlay.isHidden = showImage
        viewCount.isHidden = showImage
    }
    
    public func showTotalLabel(counter: Int) {
        totalLabel.text = R.string.localizable.commonPhotosTitleCount("\(counter)")
    }
	
	func resetLayout() {
		self.viewSeeMore.isHidden = true
		self.imageview.contentMode = .scaleAspectFill
	}
    
    // set the video to play / pause. if the video has ended, return false to give the chance to other videos
    func playVideo(_ toPlay: Bool) -> Bool {
        guard inlinePlayer != nil, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
}
