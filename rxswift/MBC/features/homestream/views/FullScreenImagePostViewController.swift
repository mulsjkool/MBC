//
//  FullScreenImagePostViewController.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import iCarousel
import Kingfisher
import MisterFusion
import TTTAttributedLabel
import UIKit
import RxSwift
import SKPhotoBrowser

class FullScreenImagePostViewController: BaseViewController {
	@IBOutlet weak private var avatarView: AvatarFullScreenView!
	@IBOutlet weak private var albumTitle: UILabel!
	@IBOutlet weak private var descriptionLabel: TTTAttributedLabel!
	@IBOutlet weak private var likeCommentShareView: LikeCommentShareView!
	@IBOutlet weak private var collapseButton: UIButton!
    @IBOutlet weak private var taggedPagesView: TaggedPagesView!
    @IBOutlet weak private var seperatorView: UIView!
    @IBOutlet weak private var heightOfTaggedPagesViewConstraint: NSLayoutConstraint!
	@IBOutlet weak private var heightOfDescriptionConstraint: NSLayoutConstraint!
	@IBOutlet weak private var heightOfAvatarViewConstraint: NSLayoutConstraint!
    @IBOutlet weak private var reloadButtonTopConstraint: NSLayoutConstraint!
    
	@IBOutlet weak private var countImageLabel: UILabel!
	@IBOutlet weak private var expandView: UIView!
	@IBOutlet weak private var reloadButton: UIButton!
    @IBOutlet weak private var closeButton: UIButton!
    
    @IBOutlet weak private var photoBrowserWrapperView: UIView!
    private var photoBrowser: SKPhotoBrowser?
    
    private var shoulGetImagesFromPost: Bool = true
    private var idImageSelected = ""
    private var feed: Feed?
    private var currentMedia: Media? {
        didSet {
            setLikeCommentCount(forFeed: false)
        }
    }
    
    static func initFromStoryboard() -> FullScreenImagePostViewController {
        let sb = UIStoryboard(name: "FullScreenPhoto", bundle: nil)
        // swiftlint:disable force_cast
        let id = "story.viewcontroller.fullscreenphoto"
        return sb.instantiateViewController(withIdentifier: id) as! FullScreenImagePostViewController
        // swiftlint:enable force_cast
    }
    
    private var urlMediaItem: String? // case when open fullscreen from cover or poster
	private var medias: ItemList!
	private var imageSelectedIndex: Int = 0
	private var albumId: String?
	private var pageId: String?
	private var pageSize: Int!
	private var author: Author?
	private var customAlbum: Album?
	private var mAccentColor: UIColor?
	private var defaultHeightDescription: CGFloat = 36
	private var defaultHeightAvatarview: CGFloat = 88
    private var defaulHeightTaggedPagesview: CGFloat = 226
	private var isTextExpanded: Bool = false
	private var widthOfItemImageView: CGFloat = Constants.DeviceMetric.screenWidth
	private var heightOfItemImageView: CGFloat = Constants.DeviceMetric.screenHeight
	private var arrayMedia: [Media] = []
	private var nextCircleProgressView: LoadingNextAlbumView?
	private var viewModel = FullScreenImagePostViewModel(interactor: Components.pageDetailInteractor())
	private var indexForCoverOfArticle = 0
	private var lastOrientation: UIDeviceOrientation!
	private var isAllowRotate: Bool = true // ensure no rotate when loading next album
	
    private var adsView: FullScreenAdsView = FullScreenAdsView(frame: UIScreen.main.bounds)
	private var forwardSteps: Int = 0
	private var backwardSteps: Int = 0
	private var previewIndex: Int = 0

    // MARK: Override
    override func viewDidLoad() {
		resetView()
        super.viewDidLoad()
        
        reloadButton.isHidden = true
        closeButton.isHidden = true
        countImageLabel.isHidden = true
        expandView.isHidden = true
        likeCommentShareView.isHidden = true
        
		configView()
		bindEvents()
		if let feed = feed, feed is Post {
			if let pageId = self.pageId, !pageId.isEmpty, let uuid = feed.uuid {
			//viewModel.loadDescription(pageId: pageId, postId: uuid, page: 0, pageSize: images.count)
                viewModel.loadDescription(pageId: pageId, postId: uuid, page: 0, pageSize: 9999)
			} else { updateContent() }
		} else if let feed = self.feed, feed is Article {
			updateContent()
		} else if let pageId = pageId { // load photos from albumId (load item of custom album or defaulAlbum)
			viewModel.loadListDataFrom(pageId: pageId, albumId: albumId, pageSize: pageSize!)
		}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadPhotoBrowser()
        
        closeButton.isHidden = false
        expandView.isHidden = false
        likeCommentShareView.isHidden = false
        self.countImageLabel.isHidden = false
    }
    
    private func reloadPhotoBrowser() {
        let medias = self.arrayMedia
        
        guard !medias.isEmpty else { return }
        
        var items = [SKPhotoProtocol]()
        for media in medias {
            items.append(SKPhoto.photoWithImageURL(media.originalLink))
        }
        var selectedIndex = imageSelectedIndex
        if let customAlbum = self.customAlbum, customAlbum.contentId != nil {
            items.append(createNextCircleProgressView())
            items.insert(SKPhoto.photoWithImageURL(""), at: 0)
            selectedIndex += 1
        }

        if photoBrowser == nil {
            photoBrowser = SKPhotoBrowser(photos: items, initialPageIndex: selectedIndex)
            photoBrowser!.delegate = self
            
            if Constants.DefaultValue.shouldRightToLeft {
                self.photoBrowser!.supportRightToLeft()
            }
            
            photoBrowserWrapperView.addSubview(photoBrowser!.view)
        } else {
            photoBrowser!.photos = items
            photoBrowser!.currentPageIndex = selectedIndex
            photoBrowser!.reloadData()
            loadPhotosForInfiniteLoop(index: selectedIndex)
        }
    }
    
    override var shouldAutorotate: Bool {
        return isAllowRotate
    }

    // MARK: Public
    func bindData(universalLink: String) {
        
    }
    
    func bindData(_ feed: Feed, imageIndex: Int = 0, imageId: String = "", accentColor: UIColor?) {
		self.imageSelectedIndex = imageIndex
        self.idImageSelected = imageId
		self.feed = feed
        shoulGetImagesFromPost = true
		if let author = feed.author {
			self.pageId = author.authorId
		}
        self.mAccentColor = accentColor
	}
	
	func bindData(_ medias: ItemList, pageId: String = "", imageIndex: Int = 0, accentColor: UIColor?) {
		self.imageSelectedIndex = imageIndex
		self.medias = medias
		self.pageId = pageId
        self.mAccentColor = accentColor
	}
	
    func bindCustomAlbumData(customAlbum: PhotoCustomAlbum) {
		self.pageId = customAlbum.pageId
		self.customAlbum = customAlbum.album
		self.author = customAlbum.author
		self.mAccentColor = customAlbum.accentColor
		self.pageSize = customAlbum.album.total
		self.albumId = customAlbum.album.contentId
        shoulGetImagesFromPost = false
	}
    
    func bindDefaultAlbumData(defaultAlbum: PhotoDefaultAlbum) {
		self.imageSelectedIndex = defaultAlbum.imageIndex
		self.pageId = defaultAlbum.pageId
		self.pageSize = defaultAlbum.pageSize
		self.author = defaultAlbum.author
		self.mAccentColor = defaultAlbum.accentColor
	}
	
    func bindDataFrom(imageUrl: String, pageId: String, accentColor: UIColor?, author: Author) {
        self.urlMediaItem = imageUrl
        self.pageId = pageId
        self.pageSize = 100000 // fake pagesize
        self.author = author
        self.mAccentColor = accentColor
    }
    
    func setCurrentImageIndex(_ index: Int) {
        self.countImageLabel.text = "\(index + 1)/\(arrayMedia.count)"
    }
    
    func removeLikeAndCommentButton() {
        likeCommentShareView.removeLikeAndCommentButton()
    }
    
    @objc
    func rotated() {
        let currentOrientation = UIDevice.current.orientation
        guard currentOrientation != lastOrientation, currentOrientation != UIDeviceOrientation.portraitUpsideDown,
            isAllowRotate else {
                return
        }
        
        if UIDeviceOrientationIsLandscape(currentOrientation) {
            widthOfItemImageView = Constants.DeviceMetric.screenHeight
            heightOfItemImageView = Constants.DeviceMetric.screenWidth
        } else if UIDeviceOrientationIsPortrait(currentOrientation) {
            widthOfItemImageView = Constants.DeviceMetric.screenWidth
            heightOfItemImageView = Constants.DeviceMetric.screenHeight
        }
        
        lastOrientation = currentOrientation
    }
    
    // MARK: Private
    private func configExpandView() {
        let size = CGSize(width: Constants.DeviceMetric.screenWidth, height: expandView.frame.size.height)
        Common.fillGradientFor(view: expandView, size: size,
                               colors: Constants.DefaultValue.gradientBottomForSingleItem,
                               locations: Constants.DefaultValue.gradientLocationBottomForSingleItem)
    }
    
    private func resetView() {
        if #available(iOS 11.0, *) { } else {
            reloadButtonTopConstraint.constant += Constants.DeviceMetric.statusBarHeight
        }
        heightOfDescriptionConstraint.constant = defaultHeightDescription
        heightOfAvatarViewConstraint.constant = 0
        heightOfTaggedPagesViewConstraint.constant = 0
        taggedPagesView.isHidden = true
        taggedPagesView.setColorForTitle(color: Colors.unselectedTabbarItem.color())
        seperatorView.isHidden = true
        avatarView.isHidden = true
        expandView.isHidden = true
        collapseButton.setImage(R.image.iconArrowUp(), for: .normal)
        collapseButton.isEnabled = false
        albumTitle.text = ""
        descriptionLabel.text = ""
        reloadButton.isHidden = true
        likeCommentShareView.isHidden = true
    }
    private func resetViewWhenLoadNextAlbum() {
        expandView.isHidden = true
        descriptionLabel.text = ""
        albumTitle.text = ""
        countImageLabel.text = ""
        arrayMedia.removeAll()
        imageSelectedIndex = 0
        reloadButton.isHidden = false
        likeCommentShareView.isHidden = true
    }
    
    private func bindEvents() {
        adsView.disposeBag.addDisposables([
            adsView.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                self?.openInAppBrowser(url: URL(string: urlString)!)
            })
        ])

        disposeBag.addDisposables([
            viewModel.onWillStartGetListItem.subscribe(onNext: { _ in
                print("onWillStartGetListItem")
            }),
            viewModel.onDidLoadItems.subscribe(onNext: { [weak self] _ in
                print("onDidLoadItems")
                self?.updateContent()
            }),
            viewModel.onFinishLoadListItem.subscribe(onNext: { _ in
                print("onFinishLoadListItem")
            }),
            viewModel.onWillStartGetNextAlbum.subscribe(onNext: { [weak self] _ in
                self?.isAllowRotate = false
                self?.resetViewWhenLoadNextAlbum()
            }),
            viewModel.onDidLoadNextAlbum.subscribe(onNext: { [weak self] album in
                print("ON DID LOAD NEXT ALBUM")
                
                self?.updateDataForCircleProgress(album: album)
            }),
            viewModel.onWillStartGetDescription.subscribe(onNext: { _ in
                print("onWillStartGetDescription")
            }),
            viewModel.onDidLoadDescription.subscribe(onNext: { [weak self] album in
                self?.customAlbum = album
                self?.updateContent()
            }),
            viewModel.onWillStartGetTaggedPages.subscribe(onNext: { [weak self] _ in
                self?.setLoadingStateForTaggegPages()
            }),
            viewModel.onDidTaggedPages.subscribe(onNext: { [weak self] media in
                self?.updateTaggedPagesFor(media: media)
            }),
            likeCommentShareView.commentTapped.subscribe(onNext: { [weak self] _ in
                guard let `self` = self, let pageId = self.pageId, let media = self.currentMedia else { return }
                self.showPopupComment(pageId: pageId, contentId: media.uuid, contentType: media.contentType)
            }),
            likeCommentShareView.shareTapped.subscribe(onNext: { [unowned self] data in
                var universalUrl: String? = ""
                if let data = data as? Feed { universalUrl = data.universalUrl }
                if let data = data as? Media { universalUrl = data.universalUrl }
                self.shareURL(strPath: universalUrl!, strTitle: self.albumTitle.text,
                              strDescription: self.descriptionLabel.text, photo: self.currentMedia, video: nil)
            })
        ])
    }
    
    private func setLoadingStateForTaggegPages() {
        taggedPagesView.setLoading()
    }
    
    private func updateNextAlbum(album: Album, isNext: Bool) {
        isAllowRotate = true
        customAlbum = album
        viewModel.medias.clear() // resetData
        if let feed = self.feed, feed is Post {
            shoulGetImagesFromPost = false
        }
        if let mediaList = album.mediaList {
            viewModel.medias = ItemList(items: mediaList)
        }
        arrayMedia = images
        imageSelectedIndex = isNext ? 0 : arrayMedia.count - 1
        setAlbumTitle()
        bindDescription()
        let index: Int = imageSelectedIndex
        currentMedia = arrayMedia[index]
        
        if let currentMedia = currentMedia {
            viewModel.getTaggedPages(media: currentMedia)
        }
        setCurrentImageIndex(index)
        expandView.isHidden = false
        reloadButton.isHidden = true
        likeCommentShareView.isHidden = false
        
        reloadPhotoBrowser()
    }
    
    private func updateDataForCircleProgress(album: Album) {
        if photoBrowser?.currentPageIndex == photoBrowser!.photos.count - 1,
            let circleProgressView = nextCircleProgressView {
            circleProgressView.bindData(album: album)
        } else if photoBrowser?.currentPageIndex == 0 {
            onFinishLoadPreviousAlbum(album: album)
        }
    }
    
    private func loadAlbumData(isNext: Bool) {
        guard let customAlbum = self.customAlbum, let contentId = customAlbum.contentId else { return }
        if photoBrowser?.currentPageIndex == 0 {

        } else if photoBrowser?.currentPageIndex == photoBrowser!.photos.count - 1,
            let circleProgressView = nextCircleProgressView {
            circleProgressView.startUpdateProgess()
        }

        let publishDate = "\(Int((customAlbum.publishedDate.timeIntervalSince1970) * 1000))"
        viewModel.loadNextAlbum(pageId: pageId!,
                                currentAlbumContentId: contentId, publishedDate: publishDate, isNext: isNext)
    }
    
    private func updateContent() {
        if let images = self.customAlbum?.mediaList, !images.isEmpty {
            arrayMedia = images
        } else {
            arrayMedia = images
        }
        if let feed = self.feed, feed is Article, let photo = (feed as? Article)?.photo {
            arrayMedia.insert(photo, at: indexForCoverOfArticle)
        }
        if let url = self.urlMediaItem {
            imageSelectedIndex = getIndexImageFrom(url: url, medias: arrayMedia) ?? imageSelectedIndex
        } else {
            imageSelectedIndex = getIndexOfDefaultImageFrom(medias: arrayMedia) ?? imageSelectedIndex
        }
       
        setAvatar()
        setAlbumTitle()
        setLikeCommentCount(forFeed: true)
        bindDescription()
        likeCommentShareView.setBackgroundColor(UIColor.clear)
        expandView.isHidden = false
        let index: Int = imageSelectedIndex
        currentMedia = arrayMedia[index]
        if let currentMedia = currentMedia {
            viewModel.getTaggedPages(media: currentMedia)
        }
        setCurrentImageIndex(index)
        reloadButton.isHidden = true
        likeCommentShareView.isHidden = false
        
        reloadPhotoBrowser()
    }
    
    private func getIndexOfDefaultImageFrom(medias: [Media]) -> Int? {
        if shoulGetImagesFromPost && !idImageSelected.isEmpty {
            return medias.index(where: { $0.id == idImageSelected })
        }
        guard !shoulGetImagesFromPost, let cover = customAlbum?.cover else { return nil }
        return medias.index(where: { $0.id == cover.id })
    }
    
    private func getIndexImageFrom(url: String, medias: [Media]) -> Int? {
         return medias.index(where: { $0.originalLink == url })
    }
    
	private var images: [Media] {
		if shoulGetImagesFromPost, let feed = self.feed, feed is Post, let array = (feed as? Post)?.medias, !array.isEmpty {
			return array.filter { !$0.originalLink.isEmpty }
		}
		
		if let article = self.feed, article is Article, let paragraphs = (article as? Article)?.paragraphs {
			return paragraphs.filter { $0.media != nil && !$0.media!.originalLink.isEmpty && !($0.media is Video) }
                .map { $0.media! }
		}
		// swiftlint:disable:next force_cast
		return self.viewModel.medias.list.filter { $0 is Media }.map { $0 as! Media }
	}
	
	private var arrayHasTagToPage: [Bool]? {
		if shoulGetImagesFromPost, let feed = self.feed, feed is Post, let array = (feed as? Post)?.medias, !array.isEmpty {
			return array.map { $0.hasTag2Page }
		}
		
        if let article = self.feed, article is Article {
            return arrayMedia.map { $0.hasTag2Page }
        }
		
		if !viewModel.medias.list.isEmpty {
			return viewModel.medias.list.map { ($0 as? Media)?.link != nil ? (($0 as? Media)?.hasTag2Page)! : false }
		}
		return nil
	}
	
    private func getTaggedPageOfImageFrom(_ index: Int) {
        let media = arrayMedia[index]
        guard media.hasTag2Page else {
            taggedPagesView.resetPages()
            heightOfTaggedPagesViewConstraint.constant = 0
            taggedPagesView.isHidden = true
            seperatorView.isHidden = true
            return
        }
        viewModel.getTaggedPages(media: media)
    }
    
    private func updateTaggedPagesFor(media: Media) {
        guard arrayMedia.count > imageSelectedIndex else { return }
        currentMedia = arrayMedia[imageSelectedIndex]
        if currentMedia === media, let taggedPages = media.taggedPages {
            taggedPagesView.bindData(tagedPages: taggedPages, type: .typeFull)
            seperatorView.isHidden = !isTextExpanded
            taggedPagesView.isHidden = !isTextExpanded
            heightOfTaggedPagesViewConstraint.constant = isTextExpanded ? defaulHeightTaggedPagesview : 0
        }
    }
    
	private func configView() {
        //configExpandView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.configExpandView()
        }
		lastOrientation = UIDevice.current.orientation

		NotificationCenter.default.addObserver(self, selector: #selector(FullScreenImagePostViewController.rotated),
											   name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

		// setup title
		let titleLabelTapGesture = UITapGestureRecognizer(target: self,
														  action: #selector(tapViewToExpandOrCollapseDescription))
		albumTitle.addGestureRecognizer(titleLabelTapGesture)
		
		// setup description
		let descriptionTapGesture = UITapGestureRecognizer(target: self,
														   action: #selector(tapViewToExpandOrCollapseDescription))
		descriptionLabel.addGestureRecognizer(descriptionTapGesture)
	}

    private func setLikeCommentCount(forFeed: Bool) {
		if let feed = self.feed, forFeed { likeCommentShareView.feed = feed }
        if let media = self.currentMedia, !forFeed { likeCommentShareView.media = media }
        likeCommentShareView.setTextColorForCountComment(UIColor.white)
	}
	
	private func setAvatar() {
		if let feed = self.feed, let author = feed.author {
            avatarView.bindData(author, publishedDate: publishedDate, contentType: feed.type, subType: feed.subType,
                                isFullScreen: true)
        } else if let author = self.author {
            avatarView.bindData(author, publishedDate: publishedDate, contentType: nil, isFullScreen: true)
        }
	}
	
	private var publishedDate: Date? {
		if let feed = self.feed {
			return feed.publishedDate
		}
		if let album = self.customAlbum { // custom album
			return album.publishedDate
		}
		guard
			albumId == nil, !viewModel.medias.list.isEmpty,
			viewModel.medias.list.count > imageSelectedIndex,
			let media = viewModel.medias.list[imageSelectedIndex] as? Media else { return nil }
		return media.publishedDate
	}
	
	private var authorPageName: String {
		if let feed = self.feed, let author = feed.author {
			return author.name
		}
		if let author = self.author {
			return author.name
		}
		return ""
	}
	
	private func setAlbumTitle() {
		if let album = self.customAlbum { // custom album
			guard let title = album.title, !title.isEmpty else {
				albumTitle.text = authorPageName + " " + R.string.localizable.commonLabelAlbums().localized()
				return
			}
			albumTitle.text = album.title
			return
		}
		
		if let feed = self.feed {
			guard let title = feed.title, !title.isEmpty else {
				albumTitle.text = authorPageName + " " + R.string.localizable.commonLabelAlbums().localized()
				return
			}
			albumTitle.text = title
			return
		}
		
		if albumId == nil { // default album
			albumTitle.text = authorPageName + " " + R.string.localizable.commonLabelAlbums().localized()
		}
	}
	
	private func bindDescription() {
		if let text = descriptionValue {
            descriptionLabel.from(html: text)
            Common.setupDescriptionFor(label: descriptionLabel, whenExpanding: isTextExpanded,
                                       maxLines: Constants.DefaultValue.numberOfLinesForImageDescription,
                                       linkColor: accentColor,
                                       delegate: self)
		}
	}
	
	private func expandCardTextLabel(label: TTTAttributedLabel!) {
		if let text = descriptionValue {
			label.numberOfLines = 0
			label.lineBreakMode = .byWordWrapping
            label.from(html: text)
			shouldExpandViewAvatarAndDescription(isExpand: true)
		}
	}
	
	@objc
	private func tapViewToExpandOrCollapseDescription() {
		shouldExpandViewAvatarAndDescription(isExpand: isTextExpanded)
	}
	
	private func shouldExpandViewAvatarAndDescription(isExpand: Bool) {
        if !isExpand {
            self.isTextExpanded = true
            self.bindDescription()
            collapseButton.setImage(R.image.iconArrowGrayDown(), for: .normal)
            collapseButton.isEnabled = true
            self.heightOfAvatarViewConstraint.constant = self.defaultHeightAvatarview
            self.avatarView.isHidden = false
            
            if let currentMedia = self.currentMedia, currentMedia.hasTag2Page {
                self.heightOfTaggedPagesViewConstraint.constant = self.defaulHeightTaggedPagesview
                self.taggedPagesView.isHidden = false
                self.seperatorView.isHidden = false
            }
            descriptionLabel.numberOfLines = Constants.DefaultValue.numberOfLinesForFullScreenImageExpandedDescription
            expandView.layoutIfNeeded()

            Common.generalAnimate(animation: {
                self.heightOfDescriptionConstraint.constant = self.descriptionLabel.frame.size.height
                self.descriptionLabel.numberOfLines = 0
                self.expandView.layoutIfNeeded()
            })
        } else { self.buttonCollapseTouch() }
	}
	
	private var descriptionValue: String? {
		if shoulGetImagesFromPost, let feed = self.feed, feed is Post, let descriptions = viewModel.descriptionOfImages,
			let medias = descriptions.mediaList,
			arrayMedia.count > imageSelectedIndex {
			let mediaId = arrayMedia[imageSelectedIndex].uuid
            for media in medias where media.uuid == mediaId { currentMedia = media; return media.description }
		}
        if let article = self.feed, article is Article {
            return arrayMedia[imageSelectedIndex].description
        }
		if !viewModel.medias.list.isEmpty && viewModel.medias.list.count > imageSelectedIndex {
			currentMedia = viewModel.medias.list[imageSelectedIndex] as? Media
			return currentMedia?.description
		}
		
		return nil
	}
	
	private var accentColor: UIColor? {
		if mAccentColor != nil {
			return mAccentColor
		}
        return Colors.defaultAccentColor.color()
	}
	
    private func createNextCircleProgressView() -> LoadingNextAlbumView {
        let loadingview = LoadingNextAlbumView(frame: CGRect(x: 0, y: 0, width: widthOfItemImageView,
                                                             height: heightOfItemImageView))
        nextCircleProgressView = loadingview
        onFinishLoadNextAlbum()
        return loadingview
    }
    
    private func onFinishLoadNextAlbum() {
        guard let circleProgressView = nextCircleProgressView else { return }

        disposeBag.insert(
            Observable.combineLatest(
            circleProgressView.progressFinish.take(1), viewModel.onDidLoadNextAlbum.take(1)) { return $1 }
                .subscribe(onNext: { [weak self] album  in
                    if let currentAlbum = self?.customAlbum, currentAlbum.id != album.id {
                        self?.updateNextAlbum(album: album, isNext: true)
                    }
                })
        )
    }
    
    private func onFinishLoadPreviousAlbum(album: Album) {
        if let currentAlbum = customAlbum, currentAlbum.id != album.id {
            updateNextAlbum(album: album, isNext: false)
        }
    }
    
    private func loadPhotosForInfiniteLoop(index: Int) {
        guard !arrayMedia.isEmpty, index == 0 || index == photoBrowser!.photos.count - 1 else { return }
        var items = [SKPhotoProtocol]()
        for media in arrayMedia {
            items.append(SKPhoto.photoWithImageURL(media.originalLink))
        }
        var newIndex = index
        if index == 0 {
            photoBrowser!.insertPhotos(photos: items, at: 0)
            newIndex = items.count
        } else if index == photoBrowser!.photos.count - 1 {
            photoBrowser!.addPhotos(photos: items)
        }
        photoBrowser!.currentPageIndex = newIndex
        photoBrowser!.reloadData()
    }
    
    private func moveToImage(index: Int) {
        imageSelectedIndex = index
        setCurrentImageIndex(index)
        bindDescription()
        getTaggedPageOfImageFrom(index)
        let media = arrayMedia[index]
        Components.analyticsService.logEvent(trackingObject: AnalyticsContent(media: media,
                                                                              author: author?.name ?? "",
                                                                              index: index))
    }
    
    func showAds(_ carouselIndex: Int) {
        let index = carouselIndex
        if index < arrayMedia.count {
            let currentIndex = index + 1
            currentIndex - previewIndex > 0 ? (forwardSteps += 1) : (backwardSteps += 1)
            previewIndex = currentIndex
        }
        if forwardSteps == Constants.DefaultValue.AmountPreviewedImage
            || backwardSteps == Constants.DefaultValue.AmountPreviewedImage {
            adsView.showAds(viewController: self, universalAddress: currentMedia?.universalUrl ?? "")
            forwardSteps = 0
            backwardSteps = 0
        }
    }

    // MARK: IBAction
	@IBAction func buttonCloseTouch() {
        if !Constants.Singleton.isiPad {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        
        UIView.animate(withDuration: Constants.DefaultValue.animateDuration, animations: { [unowned self] in
            self.view.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false)
        })
	}
	
	@IBAction func buttonReloadTouch() {
        if photoBrowser?.currentPageIndex == photoBrowser!.photos.count - 1,
            let circleProgressView = nextCircleProgressView {
            isAllowRotate = true
            circleProgressView.disposeBag.dispose()
            updateContent()
        }
	}
	
	@IBAction func buttonCollapseTouch() {
        Common.generalAnimate(animation: {
            self.heightOfDescriptionConstraint.constant = self.defaultHeightDescription
            self.expandView.layoutIfNeeded()
        })
        isTextExpanded = false
        bindDescription()
        collapseButton.setImage(R.image.iconArrowUp(), for: .normal)
        collapseButton.isEnabled = false
        avatarView.isHidden = true
        heightOfAvatarViewConstraint.constant = 0
        heightOfTaggedPagesViewConstraint.constant = 0
        taggedPagesView.isHidden = true
        seperatorView.isHidden = true
	}
}

extension FullScreenImagePostViewController: TTTAttributedLabelDelegate {
	func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
		if url.absoluteString == Constants.DefaultValue.CustomUrlForMoreText.absoluteString {
			expandCardTextLabel(label: label)
		}
	}
}

extension FullScreenImagePostViewController: SKPhotoBrowserDelegate {
    func didShowPhotoAtIndex(_ browser: SKPhotoBrowser, index: Int) {
        if let customAlbum = self.customAlbum, customAlbum.contentId != nil {
            // Album
            if index == 0 {
                loadAlbumData(isNext: false)
                previewIndex = 0
            } else if index == browser.photos.count - 1 {
                loadAlbumData(isNext: true)
                previewIndex = 0
            } else {
                if imageSelectedIndex != index - 1 {
                    moveToImage(index: index - 1)
                }
            }
        } else {
            let newIndex = index % arrayMedia.count
            moveToImage(index: newIndex)
        }
        browser.setScrollEnable(enable: browser.photos[index].scrollEnable)
        showAds(index)
    }
    
    func didScrollToIndex(_ browser: SKPhotoBrowser, index: Int) {
        guard let customAlbum = self.customAlbum, customAlbum.contentId != nil else {
            loadPhotosForInfiniteLoop(index: index)
            return
        }
    }
    
    func willDismissAtPageIndex(_ index: Int) {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.view.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false)
        })
    }
    
    func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
        return nil
    }
}
