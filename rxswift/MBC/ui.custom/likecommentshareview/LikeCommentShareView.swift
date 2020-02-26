//
//  ViewLikeCommentShare.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxSwift
import TTTAttributedLabel

class LikeCommentShareView: UIView {

	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var lBNumberLikeComment: TTTAttributedLabel!
    @IBOutlet weak private var btnLike: UIButton!
    @IBOutlet weak private var btnShare: UIButton!
    @IBOutlet weak private var btnComment: UIButton!
    
    let commentTapped = PublishSubject<Likable>()
    let shareTapped = PublishSubject<Likable>()
    
    private var likeSubscription: Disposable?
    private let bag = DisposeBag()
    private var likeStatusDisposeBag = DisposeBag()
    
    var feed: Feed? {
        didSet {
            if feed == nil { return }
            media = nil
            updateCountAndRegister()
            setupRxForUpdatingLikeStatus()
        }
    }
    
    var media: Media? {
        didSet {
            if media == nil { return }
            feed = nil
            updateCountAndRegister()
            setupRxForUpdatingLikeStatus()
        }
    }
    
    private let likedBorderWidth = CGFloat(32)
    private let likedBorderWidthTag = 101
    
    private var likeBorderView: UIView!
    private var unlikeImage = R.image.iconActionbarLike()
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
    
	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.likeCommentShareView.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        lBNumberLikeComment.activeLinkAttributes = nil
        lBNumberLikeComment.linkAttributes = nil
        lBNumberLikeComment.font = Fonts.Primary.regular.toFontWith(size: 10)
        lBNumberLikeComment.text = ""
	}
	
	private func updateSocialCount() {
        setupLikeButton()
        
        lBNumberLikeComment.text = ""
        var array = [String]()
        let numberOfLike = numLikes ?? 0
        let numberOfComments = numComments ?? 0
        var hasComment = false
        
        let textNumberOfLike = R.string.localizable.cardLikecountTitle("\(numberOfLike)")
        let textNumberOfComments = R.string.localizable.cardCommentcountTitle("\(numberOfComments)")
        
        if numberOfLike > 0 {
            array.append(textNumberOfLike)
        }
        if numberOfComments > 0 {
            array.append(textNumberOfComments)
            hasComment = true
        }
        
        guard !array.isEmpty else { return }
        
        self.lBNumberLikeComment.text = array.map({ "\($0)" })
            .joined(separator: Constants.DefaultValue.MetadataSeparatorString)
        if hasComment { addEventCommentCount(textNumberOfComments: textNumberOfComments) }
	}
    
    var numLikes: Int? {
        if feed != nil { return feed!.numOfLikes }
        if media != nil { return media!.numberOfLikes }
        return nil
    }
    
    var numComments: Int? {
        if feed != nil { return feed!.numOfComments }
        if media != nil { return media!.numberOfComments }
        return nil
    }
	
	func setBackgroundColor(_ color: UIColor) {
		containerView.backgroundColor = color
	}
	
	func setTextColorForCountComment(_ color: UIColor) {
        guard let text = lBNumberLikeComment.text, !text.isEmpty else { return }
        lBNumberLikeComment.isHidden = false
        lBNumberLikeComment.textColor = color
	}
    
    func setupImagesForSingleCardCell() {
        unlikeImage = R.image.iconActionbarLikeWhite()
        btnLike.setImage(R.image.iconActionbarLikeWhite(), for: .normal)
        btnShare.setImage(R.image.iconActionbarShareWhite(), for: .normal)
        btnComment.setImage(R.image.iconActionbarCommentWhite(), for: .normal)
    }
    
    func removeLikeAndCommentButton() {
        btnLike.removeFromSuperview()
        btnComment.removeFromSuperview()
        lBNumberLikeComment.isHidden = true
    }
    
    // MARK: Private functions
    private func setupLikeButton() {
        guard feed != nil || media != nil else { print("WARNING -- YOU'VE NOT SETUP CORRECTLY -- WARNING"); return }
        guard let btLike = btnLike, let imageView = btLike.imageView else { return }
        
        if btnLike.viewWithTag(likedBorderWidthTag) == nil {
            likeBorderView = UIView(frame: CGRect(x: 0, y: 0, width: likedBorderWidth, height: likedBorderWidth))
            likeBorderView.cornerRadius = likedBorderWidth * 0.5
            // accent color?
            likeBorderView.backgroundColor = Colors.redActiveTabbarItem.color()
            likeBorderView.tag = likedBorderWidthTag
            likeBorderView.isUserInteractionEnabled = false
            likeBorderView.isExclusiveTouch = false
            
            btnLike.insertSubview(likeBorderView, belowSubview: imageView)
            likeBorderView.translatesAutoresizingMaskIntoConstraints = false
            btnLike.mf.addConstraints(
                likeBorderView.centerX |==| btnLike.centerX,
                likeBorderView.centerY |==| btnLike.centerY |-| 1,
                likeBorderView.width |==| likedBorderWidth,
                likeBorderView.height |==| likedBorderWidth
            )
        } else { likeBorderView = btnLike.viewWithTag(likedBorderWidthTag) }
        
        updateLikeButton(feed != nil ? feed!.liked : media!.liked)
    }
    
    private func updateLikeButton(_ hasLiked: Bool) {
        if hasLiked {
            btnLike.setImage(R.image.iconActionbarLikeWhite(), for: .normal)
            likeBorderView.isHidden = false
        } else {
            likeBorderView.isHidden = true
            btnLike.setImage(unlikeImage, for: .normal)
        }
    }
    
    private func updateCountAndRegister() {
        updateSocialCount()
        if likeSubscription == nil {
            if feed != nil {
                likeSubscription = feed!.onToggleLikeSubject.subscribe(onNext: { [unowned self] likable in
                    self.updateLikeButton(likable.liked)
                })
            } else {
                likeSubscription = media!.onToggleLikeSubject.subscribe(onNext: { [unowned self] likable in
                    self.updateLikeButton(likable.liked)
                })
            }
            likeSubscription!.disposed(by: bag)
        }
    }
    
    private func setupRxForUpdatingLikeStatus() {
        likeStatusDisposeBag = DisposeBag()
        if feed != nil {
            feed!.didReceiveLikeStatus.subscribe(onNext: { [unowned self] likeStatus in
                self.updateLikeButton(likeStatus)
            }).disposed(by: likeStatusDisposeBag)
        } else {
            media!.didReceiveLikeStatus.subscribe(onNext: { [unowned self] likeStatus in
                self.updateLikeButton(likeStatus)
            }).disposed(by: likeStatusDisposeBag)
        }
    }
    
    private func commentResponse() {
        if let feed = self.feed { self.commentTapped.onNext(feed); return }
        if let media = self.media { self.commentTapped.onNext(media); return }
    }
    
    private func addEventCommentCount(textNumberOfComments: String) {
        if let range = lBNumberLikeComment.text?.rangesOf(searchString: textNumberOfComments)[0] {
            lBNumberLikeComment.addLink(to: Constants.DefaultValue.CustomUrlForCommentCount, with: range)
            lBNumberLikeComment.delegate = self
        }
    }
    
    // MARK: - Action method
    @IBAction func didTapLikeButton(_ sender: Any) {
        guard feed != nil || media != nil else { print("WARNING -- YOU'VE NOT SETUP CORRECTLY -- WARNING"); return }
        if let aFeed = feed, var numLikes = aFeed.numOfLikes {
            aFeed.liked = !aFeed.liked
            if aFeed.liked {
                numLikes += 1
            } else if numLikes > 0 {
                numLikes -= 1
            }
            aFeed.numOfLikes = numLikes
            aFeed.updateLikeStatus()
        }
        if let aMedia = media {
            aMedia.liked = !aMedia.liked
            if aMedia.liked {
                aMedia.numberOfLikes += 1
            } else if aMedia.numberOfLikes > 0 {
                aMedia.numberOfLikes -= 1
            }
            aMedia.updateLikeStatus()
        }
        
        updateCountAndRegister()
    }
    
    @IBAction func didTapCommentButton(_ sender: Any) {
        commentResponse()
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        if let feed = self.feed { self.shareTapped.onNext(feed); return }
        if let media = self.media { self.shareTapped.onNext(media); return }
    }
}

extension LikeCommentShareView: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == Constants.DefaultValue.CustomUrlForCommentCount.absoluteString {
            commentResponse()
        }
    }
}
