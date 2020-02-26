//
//  PostCardMultiImagesTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/7/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import TTTAttributedLabel
import Kingfisher
import RxSwift
import UIKit

class PostCardMultiImagesTableViewCell: BaseCardTableViewCell {

	@IBOutlet weak private var collectionImages: UICollectionView!
	@IBOutlet weak private var constraintHeightOfCollectionImage: NSLayoutConstraint!
	@IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var labelTitleTopConstraint: NSLayoutConstraint!
    private var arrayImage: [AnyObject] = []
	private var imageCount: Int = 0
	private var widthOfFirstImage: CGFloat = 0
	private var heigthOfFirstImage: CGFloat = 0
	private var widthOfLeftImage: CGFloat = 0
	private var heigthOfLeftImage: CGFloat = 0
	private var totalHeightOfCollectionView: CGFloat = 0
    private var isHideButtonPlay: Bool = true
    
    var videoPlayerTapped = PublishSubject<Video>()
    var didSelectImageAtIndex = PublishSubject<(Int, String)>() // index and id of image
    
    // Ipad
    @IBOutlet weak private var defaultImageView: UIImageView!
    private let colectionViewDefaultHeight: CGFloat = 136
    @IBOutlet weak private var defaultImageViewConstraintHeight: NSLayoutConstraint!
    private let defaultImageViewDefaultHeight: CGFloat = 456
    @IBOutlet weak private var viewImageconstraintHeight: NSLayoutConstraint!
    var inlinePlayer: InlineTHEOPlayer?
    // MARK: Public
	override func bindData(feed: Feed, accentColor: UIColor?) {
        super.bindData(feed: feed, accentColor: accentColor)
        
        if Constants.Singleton.isiPad {
            bindImageForIpad()
        } else {
            calculatorHeightOfCollectionView()
        }
        configCollectionView()
		bindTitle()
		bindDescription()
		setLikeComment()
        titleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        titleLabel.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.titleTapped.onNext(())
            })
            .disposed(by: disposeBag)
	}
    
    func getTitleLabel() -> UILabel {
        return titleLabel
    }
    
    func getImageCount() -> Int {
        return imageCount
    }
    
    func bindTitle() {
        if let video = video {
            self.titleLabel.text = video.title ?? ""
        } else {
            if let images = imagesList, images.count == 1, feed is Post {
                titleLabel.text = ""
            } else {
                self.titleLabel.text = feed.title ?? ""
                if self.titleLabel.text == "" {
                    self.titleLabel.text = R.string.localizable.commonLabelImageDefaultTitle(feed.author?.name ?? "")
                }
            }
        }
        if let topConstraint = labelTitleTopConstraint, let text = titleLabel.text {
            topConstraint.constant = text.isEmpty ? 0
                : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
        }
    }
	
	func calculatorHeightOfCollectionView() {
        if let images = imagesList {
            arrayImage = images
            imageCount = images.count > 4 ? 4 : images.count
        } else if let theVideo = video {
            arrayImage = [theVideo]
            imageCount = 1
        } else { imageCount = 0 }
		
        let screenWidth = Constants.DeviceMetric.screenWidth
        if imageCount == 1 {
            widthOfFirstImage = screenWidth
            
            var ratio = Constants.DefaultValue.ratio16H16W
            if feed is Article || imagesList == nil
                || imagesList!.isEmpty && video != nil { // single video post or article, we need 16/9
                ratio = Constants.DefaultValue.ratio9H16W
            }
            heigthOfFirstImage = widthOfFirstImage * ratio
            widthOfLeftImage = 0
            heigthOfLeftImage = 0
            totalHeightOfCollectionView = heigthOfFirstImage
        } else if imageCount == 2 {
            widthOfFirstImage = screenWidth / 2
            heigthOfFirstImage = widthOfFirstImage
            widthOfLeftImage = widthOfFirstImage
            heigthOfLeftImage = heigthOfFirstImage
            totalHeightOfCollectionView = heigthOfFirstImage
        } else if imageCount > 2 {
            widthOfFirstImage = screenWidth
            heigthOfFirstImage = widthOfFirstImage * Constants.DefaultValue.ratio9H16W
            widthOfLeftImage = floor(widthOfFirstImage / (CGFloat)(imageCount - 1))
            heigthOfLeftImage = widthOfLeftImage
            totalHeightOfCollectionView = heigthOfFirstImage + heigthOfLeftImage
        }

        self.constraintHeightOfCollectionImage.constant = self.totalHeightOfCollectionView.rounded()
        self.collectionImages.reloadData()
	}
    
    func calculatorHeightOfCollectionViewUnderBundleContent() {
        isHideButtonPlay = false
        let screenWidth = Constants.DeviceMetric.screenWidth
        widthOfFirstImage = screenWidth
        
        var ratio = Constants.DefaultValue.ratio16H16W
        if feed is Article || imagesList == nil
            || imagesList!.isEmpty && video != nil { // single video post or article, we need 16/9
            ratio = Constants.DefaultValue.ratio9H16W
        }
        heigthOfFirstImage = widthOfFirstImage * ratio
        widthOfLeftImage = 0
        heigthOfLeftImage = 0
        totalHeightOfCollectionView = heigthOfFirstImage
        
        self.constraintHeightOfCollectionImage.constant = self.totalHeightOfCollectionView.rounded()
        self.collectionImages.reloadData()
    }
    
    var videoCell: CardImageItemCollectionViewCell? {
        guard imageCount == 1 else { return nil }
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView(collectionImages, cellForItemAt: indexPath)
        if arrayImage[indexPath.row] is Video, cell is CardImageItemCollectionViewCell {
            // swiftlint:disable:next force_cast
            return (cell as! CardImageItemCollectionViewCell)
        }
        
        return nil
    }
    
    func playVideo(_ toPlay: Bool, currentTime: Double) {
        if let cell = videoCell, self.video != nil {
            cell.video?.currentTime.value = currentTime
            cell.video?.hasEnded.value = false
            collectionImages.reloadData()
        }
    }
    
    // MARK: Private
   private func playVideoforIpad(_ toPlay: Bool) -> Bool {
        guard let inlinePlayer = self.inlinePlayer, let theVideo = video, !theVideo.hasEnded.value else { return false }
        return inlinePlayer.resumePlaying(toResume: toPlay, autoNext: false)
    }
    
    private func configCollectionView() {
        collectionImages.dataSource = self
        collectionImages.delegate = self
        collectionImages.register(R.nib.cardImageItemCollectionViewCell(),
                                  forCellWithReuseIdentifier:
            R.reuseIdentifier.cardImageItemCollectionViewCellId.identifier)
        collectionImages.reloadData()
    }
    
    private func bindImageForIpad() {
        guard defaultImageView != nil else { return }
        defaultImageView.image = nil
        defaultImageViewConstraintHeight.constant = defaultImageViewDefaultHeight
        viewImageconstraintHeight.constant = defaultImageViewDefaultHeight
        if let images = imagesList {
            arrayImage = images
            imageCount = images.count > 4 ? 4 : images.count
        } else if let theVideo = video {
            arrayImage = [theVideo]
            imageCount = 1
        } else { imageCount = 0 }
        if imageCount >= 1 {
             if let theVideo = arrayImage.first as? Video {
                // TODO: add video here
                bindVideoForIpad(video: theVideo)
            } else if let defaultImage = arrayImage.first as? Media {
                if let inlinePlayer = inlinePlayer, inlinePlayer.theoPlayer != nil,
                    !inlinePlayer.theoPlayer.isDestroyed {
                    inlinePlayer.prepareForReuse()
                    self.inlinePlayer = nil
                }
                defaultImageView.setImage(from: defaultImage, resolution: .ar16x16)
            }
            arrayImage.removeFirst()
            imageCount -= 1
        }
        constraintHeightOfCollectionImage.constant = imageCount > 0 ? colectionViewDefaultHeight : 0
    }
    
    private func bindVideoForIpad(video: Video) {
        defaultImageView.image = nil
        defaultImageViewConstraintHeight.constant = defaultImageViewDefaultHeight * Constants.DefaultValue.ratio9H16W
        viewImageconstraintHeight.constant = defaultImageViewDefaultHeight * Constants.DefaultValue.ratio9H16W

        defaultImageView.backgroundColor = Colors.black.color()
        if inlinePlayer == nil { inlinePlayer = InlineTHEOPlayer(inlineOfView: defaultImageView) }
        if let inlinePlayer = inlinePlayer {
            inlinePlayer.video = video
            inlinePlayer.feed = feed
        }
    }
    
    private func getMediaIndexOfPostFrom(media: Media) -> Int? {
        if self.feed is Article { return 0 }
        guard let feed = (self.feed as? Post), let medias = feed.medias else { return nil }
        return medias.index(where: { item -> Bool in item.id == media.id })
    }
	
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        updateGifAutoPlay(yOrdinate: yOrdinate, viewPortHeight: viewPortHeight)
        if Constants.Singleton.isiPad {
            return updateVideoAutoPlayforiPad(yOrdinate: yOrdinate,
                                              viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
        }
        return updateVideoAutoPlay(yOrdinate: yOrdinate,
                                   viewPortHeight: viewPortHeight, isAVideoPlaying: isAVideoPlaying)
    }
    
    private func updateGifAutoPlay(yOrdinate: CGFloat, viewPortHeight: CGFloat) {
        guard let images = imagesList, !images.isEmpty else { return }
        
        if images.count == 2 { return }
        
        guard let firstImg = images.first, firstImg.isAGif,
            let gifCell = collectionImages.cellForItem(at: IndexPath(item: 0, section: 0))
                as? CardImageItemCollectionViewCell else { return }
        
        let gifHeight = gifCell.frame.size.height
        let yOrdinateToGif = yOrdinate + gifCell.convert(gifCell.bounds, to: self).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? gifCell.getImageView().resumeGifAnimation() : gifCell.getImageView().pauseGifAnimation()
    }
    
    private func updateVideoAutoPlay(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        guard video != nil else { return (isVideo: false, shouldResume: false) }
        
        guard let videoCell = collectionImages.cellForItem(at: IndexPath(item: 0, section: 0))
                as? CardImageItemCollectionViewCell else { return (isVideo: false, shouldResume: false) }
        
        if isAVideoPlaying {
            _ = videoCell.playVideo(false)
            videoCell.inlinePlayer?.videoWillTerminate()
            return (isVideo: true, shouldResume: true)
        }
        
        let videoHeight = videoCell.frame.size.height
        let yOrdinateToVideo = yOrdinate + videoCell.convert(videoCell.bounds, to: self).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        if !shouldResume {
            self.video?.hasEnded.value = false
            videoCell.inlinePlayer?.videoWillTerminate()
        }
        return (isVideo: true, shouldResume: videoCell.playVideo(shouldResume))
    }
    
    private func updateVideoAutoPlayforiPad(yOrdinate: CGFloat,
                                     viewPortHeight: CGFloat,
                                     isAVideoPlaying: Bool) -> (isVideo: Bool, shouldResume: Bool) {
        guard video != nil else { return (isVideo: false, shouldResume: false) }
        if isAVideoPlaying {
            if let inlinePlayer = self.inlinePlayer, let theVideo = video, !theVideo.hasEnded.value {
                inlinePlayer.resumePlaying(toResume: false, autoNext: false)
                inlinePlayer.videoWillTerminate()
            }
            return (isVideo: true, shouldResume: true)
        }
        
        let videoHeight = defaultImageView.frame.size.height
        let yOrdinateToVideo = yOrdinate + defaultImageView.convert(defaultImageView.bounds, to: self).origin.y
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: videoHeight,
                                                        yOrdinateToMedia: yOrdinateToVideo,
                                                        viewPortHeight: viewPortHeight)
        if !shouldResume {
            self.video?.hasEnded.value = false
            self.inlinePlayer?.videoWillTerminate()
        }
        return (isVideo: true, shouldResume: playVideoforIpad(shouldResume))
    }
    
    private func iphoneCellForRow(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                R.reuseIdentifier.cardImageItemCollectionViewCellId.identifier,
                                                             for: indexPath) as? CardImageItemCollectionViewCell {
                cell.resetLayout()
                cell.hideImagePlay(showImage: isHideButtonPlay)
                cell.showTotalLabel(counter: arrayImage.count)
                if let video = arrayImage[indexPath.row] as? Video {
                    video.interests = interests
                    video.label = label
                    cell.video = video
                    cell.inlinePlayer.feed = feed
                    cell.disposeBag.addDisposables([
                        cell.inlinePlayer.videoPlayerTapped.subscribe(onNext: { [weak self] video in
                            self?.videoPlayerTapped.onNext(video)
                        })
                    ])
                    return cell
                }
                if let image = arrayImage[indexPath.row] as? Media {
                    
                    if indexPath.row == 3 && arrayImage.count > 4 {
                        cell.showViewSeeMoreWithText(seeMoreNumber: "+\(arrayImage.count - imageCount)")
                    }
                    var showGifLogo = arrayImage.count == 2
                    if arrayImage.count > 2 { showGifLogo = indexPath.row > 0 }
                    
                    cell.setImage(image: image, shouldShowGifMark: showGifLogo)
                    return cell
                }
            }
            return UICollectionViewCell()
    }
    
    private func iPadCellForRow(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                R.reuseIdentifier.cardImageItemCollectionViewCellId.identifier,
                                                             for: indexPath) as? CardImageItemCollectionViewCell {
            if let image = arrayImage[indexPath.row] as? Media {
                
                if indexPath.row == 2 && arrayImage.count > 3 {
                    cell.showViewSeeMoreWithText(seeMoreNumber: "+\(arrayImage.count - imageCount)")
                } else {
                    cell.resetLayout()
                }
//                var showGifLogo = arrayImage.count == 2
//                if arrayImage.count > 2 { showGifLogo = indexPath.row > 0 }
//
//                cell.setImage(image: image, shouldShowGifMark: showGifLogo)
                cell.setImage(image: image, shouldShowGifMark: false)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension PostCardMultiImagesTableViewCell: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imageCount
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.Singleton.isiPad {
            return CGSize(width: colectionViewDefaultHeight, height: colectionViewDefaultHeight)
        }
		if indexPath.row == 0 {
			return CGSize(width: widthOfFirstImage, height: heigthOfFirstImage)
		}
		
		return CGSize(width: widthOfLeftImage, height: heigthOfLeftImage )
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if Constants.Singleton.isiPad {
            return iPadCellForRow( collectionView, cellForItemAt: indexPath)
        }
        return iphoneCellForRow( collectionView, cellForItemAt: indexPath)
	}
	
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.row
        var id: String?
        if  feed != nil && feed is Post {
            if arrayImage[index] is Video {
                index = 0
            } else if let media = arrayImage[index] as? Media {
                index = getMediaIndexOfPostFrom(media: media) ?? indexPath.row
                id = media.id
            }
        } else if let article = feed as? Article {
            id = article.photo.id
        }
        if let id = id { didSelectImageAtIndex.onNext((index, id)) }
    }
    
}
