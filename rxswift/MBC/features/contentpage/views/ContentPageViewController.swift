//
//  ContentPageViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//
// TODO: resume or pause Video
import UIKit
import RxSwift

class ContentPageViewController: BaseViewController {

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var sendMessageView: SendMessageView!
    @IBOutlet weak private var messageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak private var sendMessageHeightConstraint: NSLayoutConstraint!
	
	private let articleTaggedPagesReuseCellString = "articleTaggedPages"
	private let emptyAdsHeight: CGFloat = 1.1
	
	private var adsCells = [IndexPath: AdsContainer]() // caching ads
    private var heightAtIndexPathDict = [String: CGFloat]()
    var viewModel: ContentPageViewModel!
    private var imagesIndexs: [Int: Int] = [:]
    private var currentVideoIndex: Int = 0
	private var isMoreComment: Bool = false
	private var keyboardHeight: CGFloat = 0
	private var hasAdsSponsored: Bool = false
	private var hasLoadedFirst: Bool = false
	private var hasReceivedItems: Bool = false
	private var hasReceivedComments: Bool = false
	private var isHideMessageCell: Bool = false {
		didSet {
			processHideMessageCell()
		}
	}
	
	var isShowComment: Bool = false
    var shouldAutoPlay: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.alpha = 0.0
        setupUI()
        bindEvents()
        getContentPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        
        Common.resetVideoPlayingStatusFor(table: tableView)
        updateGifAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        pauseVideosWhenLeaving()
    }
	
	deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}
	
	override func listenToggleScroll(toggleSubject: BehaviorSubject<(Bool, Bool)>) {
		disposeBag.addDisposables([
			toggleSubject.subscribe(onNext: { [unowned self] hasAds, canScroll in
				self.hasAdsSponsored = hasAds
				self.tableView.isScrollEnabled = canScroll
			})
		])
	}
    
    func pauseVideosWhenSwipedOutOfBundle() {
        pauseVideosWhenLeaving()
    }
    
    // MARK: Private functions
    
    private func pauseVideosWhenLeaving() {
        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            if cell is ArticleVideoCell {
                _ = (cell as? ArticleVideoCell)?.inlinePlayer.resumePlaying(toResume: false, autoNext: false)
            }
            if cell is VideoHeaderCell {
                _ = (cell as? VideoHeaderCell)?.inlinePlayer.resumePlaying(toResume: false, autoNext: false)
            }
            if cell is PostImageCell {
                _ = (cell as? PostImageCell)?.videoCell?.inlinePlayer.resumePlaying(toResume: false, autoNext: false)
            }
        }
    }
    
    private func getContentPage() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.getContent()
        })
    }
    
    private func getComments() {
        viewModel.getComments()
    }
    
    private func setupUI() {
        if !self.isUnderBundleContent { showHideNavigationBar(shouldHide: false) }
        
        self.addBackButton()
        setupTableView()
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartGetItem.subscribe(onNext: { _ in }),
            viewModel.onWillStopGetItem.subscribe(onNext: { [weak self] _ in
				self?.hasReceivedItems = true
				self?.loadDataScrollToComment()
            }),
            viewModel.onWillStopGetComments.subscribe(onNext: { [weak self] isLoadMore in
				self?.hasReceivedComments = true
				self?.isMoreComment = isLoadMore
				self?.loadDataScrollToComment()
            }),
			viewModel.onWillErrorComments.subscribe(onNext: { [weak self] _ in
				self?.hasReceivedComments = true
				self?.isMoreComment = false
				self?.loadDataScrollToComment()
			}),
            viewModel.onWillStopGetTaggedPages.subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }),
            sendMessageView.successSendComments.subscribe(onNext: { [weak self] comment in
                self?.reloadComments(comment: comment)
            }),
			sendMessageView.onDidErrorSendComments.subscribe(onNext: { [weak self] in
				self?.showMessage(message: R.string.localizable.errorSendComment())
			}),
            viewModel.onDidGetError.subscribe(onNext: { [weak self] _ in
                self?.showMessage(message: R.string.localizable.errorDataNotAvailable())
            }),
            viewModel.onWillStopGetRelatedContents.subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }),
            viewModel.onWillStopGetVideoPlaylist.subscribe(onNext: { [weak self] _ in
               self?.getIndexOfCurrentVideo()
            })
        ])
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                guard let `self` = self else { return }
                
                var paddingBottom: CGFloat = 0.0
                if self.tabBarController != nil && !self.hidesBottomBarWhenPushed {
                    paddingBottom = Constants.DeviceMetric.tabbarHeight
                }
                self.messageViewBottomConstraint.constant = keyboardVisibleHeight > paddingBottom ?
                    (keyboardVisibleHeight - paddingBottom) : keyboardVisibleHeight
                
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) { self.view.layoutIfNeeded() }
            })
            .disposed(by: disposeBag)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
	
	private func loadDataScrollToComment() {
		if self.hasLoadedFirst { self.setupData(); return }

		if hasReceivedItems && hasReceivedComments {
			self.setupData()
			self.bindMessageData()
			if self.isShowComment { self.isHideMessageCell = true }
			
			self.tableView.alpha = 1.0
			self.hasLoadedFirst = true
		}
	}
	
	private func scrollToCommentSection() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
			self.tableView.scrollToRow(at: IndexPath(row: 0, section: ContentPageTableViewSection.inputMessage.rawValue),
									   at: .bottom, animated: false)
		}
	}
	
	@objc
	func keyboardWillShow(_ notification: Notification) {
		if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			self.keyboardHeight = keyboardFrame.cgRectValue.height
		}
		if !isHideMessageCell { isHideMessageCell = true }
	}
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        if isHideMessageCell { isHideMessageCell = false }
    }
    
    private func getIndexOfCurrentVideo() {
        guard let post = (viewModel.feed as? Post), let sType = post.subType,
            let subType = FeedSubType(rawValue: sType), subType == .video else { return }
        if let video = post.medias?.first as? Video, let videos = viewModel.videos {
            let index = videos.index(where: { $0.id == video.id })
            currentVideoIndex = index ?? currentVideoIndex
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.DefaultValue.estimatedTableRowHeight
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.separatorStyle = .none
        
        tableView.register(R.nib.articleParagraphTextCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.articleParagraphTextCell.identifier)
        tableView.register(R.nib.articleParagraphImageCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.articleParagraphImageCell.identifier)
        tableView.register(R.nib.articleHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.articleHeaderCell.identifier)
        tableView.register(R.nib.articleEmbeddedCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.articleEmbeddedCell.identifier)
        tableView.register(R.nib.headerCommentViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.headerCommentViewCellId.identifier)
        tableView.register(R.nib.commentViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.commentViewCellId.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: articleTaggedPagesReuseCellString)
        tableView.register(R.nib.articleVideoCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.articleVideoCell.identifier)
        tableView.register(R.nib.postTextCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.postTextCell.identifier)
        tableView.register(R.nib.postImageCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.postImageCell.identifier)
        tableView.register(R.nib.videoHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.videoHeaderCell.identifier)
        tableView.register(R.nib.embedHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.embedHeaderCell.identifier)
        tableView.register(R.nib.appHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.appHeaderCell.identifier)
        tableView.register(R.nib.bannerAdsViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.bannerAdsViewCell.identifier)
        tableView.register(R.nib.relatedContentCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.relatedContentCell.identifier)
        tableView.register(R.nib.relatedContentSectionHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.relatedContentSectionHeaderCell.identifier)
        tableView.register(R.nib.episodeHeaderCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.episodeHeaderCell.identifier)
		tableView.register(R.nib.loadMoreCommentCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.loadMoreCommentCell.identifier)
		tableView.register(R.nib.inputMessageViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.inputMessageViewCell.identifier)
    }
    
	private func setupData() {
		guard let feed = viewModel.feed else { return }
        title = feed.title ?? ""
        
		if viewModel.contentPageType == .postText {
			title = ""
		} else if let post = feed as? Post, viewModel.contentPageType == .postEpisode {
            title = post.episodeTitle ?? ""
		}
		Components.analyticsService.logEvent(trackingObject: AnalyticsContent(feed: feed))
		tableView.reloadData()
		Components.analyticsService.logCells(visibleCells: tableView.visibleCells)
	}
    
    private func reloadComments(comment: Comment) {
        viewModel.addComment(comment: comment)
        let indexPath = IndexPath(item: 0, section: ContentPageTableViewSection.comments.rawValue)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .fade)
		tableView.reloadSections(IndexSet(integer: ContentPageTableViewSection.headerComment.rawValue), with: .fade)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
        
    private func bindMessageData() {
        guard let feed = viewModel.feed else { return }
        self.sendMessageView.bindData(authorId: feed.author?.authorId,
                                      contentId: feed.contentId, contentType: feed.contentType)
    }
    
    private func paragraphTextCell(indexPath: IndexPath) -> UITableViewCell {
        guard let article = viewModel.feed as? Article, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.articleParagraphTextCell.identifier) as? ArticleParagraphTextCell else {
            return UITableViewCell()
        }
        
        let paragraph = article.paragraphs[indexPath.row]
        cell.tag = getTagForArticleParagraphCell(indexPath: indexPath)
        cell.author = article.author
        cell.bindData(paragraph: paragraph,
                      numberOfItem: article.paragraphs.count - numberOfAdOnArticleParagraphSection(),
                      paragraphViewOption: article.paragraphViewOption)
        return cell
    }
    
    private func paragraphImageCell(indexPath: IndexPath) -> UITableViewCell {
        guard let article = viewModel.feed as? Article, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.articleParagraphImageCell.identifier) as? ArticleParagraphImageCell else {
                return UITableViewCell()
        }
        
        let paragraph = article.paragraphs[indexPath.row]
        cell.tag = getTagForArticleParagraphCell(indexPath: indexPath)
        cell.author = article.author
        cell.bindData(paragraph: paragraph, accentColor: viewModel.pageAccentColor(),
                      numberOfItem: article.paragraphs.count - numberOfAdOnArticleParagraphSection(),
                      paragraphViewOption: article.paragraphViewOption)
        trackIndexForImages(indexPath: indexPath)
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didTapButtonTaggedPages.subscribe(onNext: { [unowned self] media in
                self.viewModel.getTaggedPages(media: media)
            }),
            cell.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.navigator?.pushPageDetail(pageUrl: menuPage.externalUrl, pageId: menuPage.id)
            }),
            cell.photoTapped.subscribe(onNext: { [unowned self] imageId in
                self.showFullscreenImage(article, accentColor: self.viewModel.pageAccentColor(), pageId: "",
                                         imageId: imageId ?? "")
            })
        ])
        return cell
    }
    
    private func paragraphEmbeddedCell(indexPath: IndexPath) -> UITableViewCell {
        guard let article = viewModel.feed as? Article, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.articleEmbeddedCell.identifier) as? ArticleEmbeddedCell else {
                return UITableViewCell()
        }
        
        let paragraph = article.paragraphs[indexPath.row]
        cell.tag = getTagForArticleParagraphCell(indexPath: indexPath)
        cell.author = article.author
        cell.bindData(paragraph: paragraph,
                      numberOfItem: article.paragraphs.count - numberOfAdOnArticleParagraphSection(),
                      paragraphViewOption: article.paragraphViewOption)
        cell.disposeBag.addDisposables([
            cell.didUpdateWebView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.openInAppBrowser(url: url)
            })
        ])
        return cell
    }
    
    private func paragraphVideoCell(indexPath: IndexPath) -> UITableViewCell {
        guard let article = viewModel.feed as? Article, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.articleVideoCell.identifier) as? ArticleVideoCell else {
                return UITableViewCell()
        }
        
        let paragraph = article.paragraphs[indexPath.row]
        cell.tag = getTagForArticleParagraphCell(indexPath: indexPath)
        cell.bindData(paragraph: paragraph, accentColor: viewModel.pageAccentColor(),
                      numberOfItem: article.paragraphs.count - numberOfAdOnArticleParagraphSection(),
                      paragraphViewOption: article.paragraphViewOption)
        trackIndexForImages(indexPath: indexPath)
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didTapButtonTaggedPages.subscribe(onNext: { [unowned self] media in
                self.viewModel.getTaggedPages(media: media)
            })
        ])
        if let inlinePlayer = cell.inlinePlayer {
            cell.disposeBag.addDisposables([
                inlinePlayer.videoPlayerTapped.subscribe(onNext: { [weak self] video in
                    if let author = article.author, let uuid = article.uuid {
                        self?.navigator?.pushVideoPlaylistFrom(pageId: author.authorId, contentId: uuid,
                                                               videoId: video.id)
                    }
                })
            ])
        }
        return cell
    }
    
    private func numberOfAdOnArticleParagraphSection() -> Int {
        guard let article = viewModel.feed as? Article else {
                return 0
        }
        var numberOfAds: Int = 0
        for i in 0...(article.paragraphs.count - 1) {
            let paragraph = article.paragraphs[i]
            if paragraph.type == .ads || paragraph.type == .unknown {
                numberOfAds += 1
            }
        }
        return numberOfAds
    }
    
    private func getTagForArticleParagraphCell(indexPath: IndexPath) -> Int {
        guard let article = viewModel.feed as? Article else {
            return 0
        }
        var numberOfAds: Int = 0
        for i in 0...indexPath.row {
            let paragraph = article.paragraphs[i]
            if paragraph.type == .ads || paragraph.type == .unknown {
                numberOfAds += 1
            }
        }
        return indexPath.row - numberOfAds
    }
    
	private func bannerAdsCell(isArticle: Bool, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.bannerAdsViewCell.identifier) as? BannerAdsViewCell else { return UITableViewCell() }
		if isArticle { cell.hideBottomLine() }
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds, isHideBottom: isArticle) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath] {
				ads.requestAds(adsType: .banner, viewController: self, universalUrl: viewModel.feed?.universalUrl ?? "")
				ads.disposeBag.addDisposables([
					ads.loadAdSuccess.subscribe(onNext: { [unowned self] row in
						if let index = row { self.tableView.reloadRows(at: [index], with: .fade) }
                    }),

                    ads.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                        self?.openInAppBrowser(url: URL(string: urlString)!)
                    })
				])
			}
		}
        return cell
    }
    
    private func articleHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let article = viewModel.feed as? Article, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.articleHeaderCell.identifier) as? ArticleHeaderCell else {
                return UITableViewCell()
        }
        
        cell.bindData(article: article, accentColor: viewModel.pageAccentColor())
        cell.selectionStyle = .none
        cell.disposeBag.addDisposables([
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didTapToOpenPhotoFullScreen.subscribe(onNext: { [unowned self] _ in
                self.showFullscreenImage(article, accentColor: self.viewModel.pageAccentColor(), imageIndex: 0)
            }),
            cell.didTapButtonTaggedPages.subscribe(onNext: { [unowned self] photo in
                self.viewModel.getTaggedPages(media: photo)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.actionCommentTapped()
            }),
            cell.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.navigator?.pushPageDetail(pageUrl: menuPage.externalUrl, pageId: menuPage.id)
            })
        ])
        return cell
    }
    
    private func postTextHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel.feed as? Post, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.postTextCell.identifier) as? PostTextCell else {
            return UITableViewCell()
        }
        cell.bindData(post: post, accentColor: viewModel.pageAccentColor())
        cell.disposeBag.addDisposables([
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
				self.actionCommentTapped()
            })
        ])
        
        return cell
    }
    
    private func postImageHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel.feed as? Post, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.postImageCell.identifier) as? PostImageCell else {
                return UITableViewCell()
        }
        cell.bindData(post: post, accentColor: viewModel.pageAccentColor())
        if self.isUnderBundleContent && !Constants.Singleton.isiPad {
            cell.calculatorHeightOfCollectionViewUnderBundleContent()
        }
        cell.disposeBag.addDisposables([
            cell.didSelectImageAtIndex.subscribe(onNext: { [unowned self] imageIndex, _ in
                self.navigator?.presentFullscreenImage(feed: post, imageIndex: imageIndex, viewController: self,
                                                       accentColor: self.viewModel.pageAccentColor())
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.actionCommentTapped()
            }),
            cell.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.navigator?.pushPageDetail(pageUrl: menuPage.externalUrl, pageId: menuPage.id)
            })
        ])
        
        return cell
    }
    
    private func videoHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel.feed as? Post, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.videoHeaderCell.identifier) as? VideoHeaderCell else {
                return UITableViewCell()
        }
		cell.bindData(post: post, accentColor: viewModel.pageAccentColor(), videoAdsType: .midRoll)
        cell.disposeBag.addDisposables([
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.actionCommentTapped()
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.inlinePlayer.endVideoEvent.subscribe(onNext: { [unowned self] video in
                self.playNextVideoFrom(video: video)
            }),
            cell.inlinePlayer.videoPlayerTapped.subscribe(onNext: { [unowned self] video in
                guard let videos = self.viewModel.videos else { return }
                if let videoData = videos.first(where: { $0.id == video.id }) {
                    videoData.currentTime.value = video.currentTime.value
                }
                self.navigator?.pushVideoPlaylistFrom(videos: videos, videoIndex: self.currentVideoIndex,
                                                      videoId: video.id)
            })
        ])
        
        return cell
    }
    
    private func playNextVideoFrom(video: Video) {
        guard let videos = viewModel.videos, let index = videos.index(where: { $0.id == video.id }),
            index < videos.count - 1 else { return }
        let nextVideo = videos[index + 1]
        self.currentVideoIndex = index + 1
        viewModel.pageUrl = nextVideo.universalUrl
        viewModel.contentId = nextVideo.contentId ?? ""
        viewModel.currentVideoTime = 0
        getContentPage()
        getComments()
    }
    
    private func embedHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel.feed as? Post, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.embedHeaderCell.identifier) as? EmbedHeaderCell else {
                return UITableViewCell()
        }
        cell.bindData(post: post, accentColor: viewModel.pageAccentColor())
        cell.disposeBag.addDisposables([
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didUpdateWebView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.openInAppBrowser(url: url)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.actionCommentTapped()
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            })
        ])
        
        return cell
    }
    
    private func appHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let app = viewModel.feed as? App, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.appHeaderCell.identifier) as? AppHeaderCell else {
                return UITableViewCell()
        }
        cell.bindData(app: app, accentColor: viewModel.pageAccentColor())
        cell.disposeBag.addDisposables([
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.actionCommentTapped()
            }),
            cell.whitePageButtonTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.pushAppWhitePage(app: app)
            })
        ])
        
        return cell
    }
    
    private func taggedPagesCell(taggedPages: [MenuPage]) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: articleTaggedPagesReuseCellString) {
            for subView in cell.contentView.subviews where subView is TaggedPagesView {
                subView.removeFromSuperview()
            }
            let rect = CGRect(x: 0, y: 0, width: Constants.DeviceMetric.screenWidth,
                              height: Constants.DefaultValue.taggedCellHeight)
            let taggedPagedView = TaggedPagesView(frame: rect)
            taggedPagedView.resetPages()
            taggedPagedView.bindData(tagedPages: taggedPages)
            cell.contentView.addSubview(taggedPagedView)
            taggedPagedView.disposeBag.addDisposables([
                taggedPagedView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                    self.navigator?.pushPageDetail(pageUrl: menuPage.externalUrl, pageId: menuPage.id)
                })
            ])
            return cell
        }
        return createDummyCellWith(title: "Cell for tagged pages")
    }
    
    private func headerCommentCell(comments: [Comment]) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.headerCommentViewCellId.identifier) as? HeaderCommentViewCell {
            cell.bindData(comments: comments)
            return cell
        }
        return createDummyCellWith(title: "Cell for header comment")
    }
	
	private func loadMoreCommentCell() -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.loadMoreCommentCell.identifier) as? LoadMoreCommentCell else {
			return createDummyCellWith(title: "Cell for load more comment")
		}
		return cell
	}
	
	private func inputMessageCell() -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.inputMessageViewCell.identifier) as? InputMessageViewCell else {
				return createDummyCellWith(title: "Cell for input message")
		}
		disposeBag.addDisposables([
			cell.onInputMessage.subscribe(onNext: { [weak self] in self?.isHideMessageCell = true })
		])
		return cell
	}
    
    private func relatedContentCell(indexPath: IndexPath) -> UITableViewCell {
        guard let relatedContents = viewModel.relatedContents,
            let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.relatedContentCell.identifier) as? RelatedContentCell else {
                return UITableViewCell()
        }
        let feed = relatedContents[indexPath.row - 1]
        cell.bindData(feed: feed, accentColor: viewModel.pageAccentColor())
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didChangeInterestView.subscribe(onNext: { _ in
                self.reloadCell()
            }),
            cell.authorNameTapped.subscribe(onNext: { _ in
                self.navigator?.pushPageDetail(pageUrl: feed.author?.universalUrl ?? "",
                                               pageId: feed.author?.authorId ?? "")
            }),
            cell.authorAvatarTapped.subscribe(onNext: { _ in
                self.navigator?.pushPageDetail(pageUrl: feed.author?.universalUrl ?? "",
                                               pageId: feed.author?.authorId ?? "")
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: feed, isShowComment: true)
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: feed)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType),
                    type == .image {
                    self.navigator?.presentFullscreenImage(feed: post, imageIndex: 0, viewController: self,
                                                           accentColor: self.viewModel.pageAccentColor())
                } else {
                    self.navigator?.navigateToContentPage(feed: feed)
                }
            }),
            cell.relatedContentThumbnailTapped.subscribe(onNext: { [unowned self] _ in
                if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType),
                    type == .image {
                    self.navigator?.presentFullscreenImage(feed: post, imageIndex: 0, viewController: self,
                                                           accentColor: self.viewModel.pageAccentColor())
                } else {
                    self.navigator?.navigateToContentPage(feed: feed)
                }
            })
        ])
        return cell
    }
    
    private func relatedContentHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.relatedContents != nil, let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.relatedContentSectionHeaderCell.identifier) as? RelatedContentSectionHeaderCell else {
                    return UITableViewCell()
        }
        return cell
    }
    
    private func commentCell(comment: Comment) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.commentViewCellId.identifier) as? CommentViewCell {
            cell.bindData(comment: comment, accentColor: viewModel.pageAccentColor())
            cell.disposeBag.addDisposables([
                cell.expandedText.subscribe(onNext: { [unowned self] _ in
                    self.reloadCell()
                }),
                cell.authorAvatarTapped.subscribe(onNext: { _ in
                    
                }),
                cell.authorNameTapped.subscribe(onNext: { _ in
                    
                }),
                cell.successRemoveComment.subscribe(onNext: { [unowned self] comment in
                    self.remove(comment: comment)
                })
            ])
            return cell
        }
        return createDummyCellWith(title: "Cell for comments")
    }
    
    private func episodeHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel.feed as? Post, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.episodeHeaderCell.identifier) as? EpisodeHeaderCell else {
                return UITableViewCell()
        }
        cell.bindData(post: post, accentColor: viewModel.pageAccentColor())
        cell.disposeBag.addDisposables([
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.actionCommentTapped()
            }),
            cell.onStartInAppBrowserWithShahidEmbedded.subscribe(onNext: { [unowned self] url, appstore in
                self.openInAppBrowserWithShahidEmbedded(url: url, appStore: appstore)
            })
        ])
        return cell
    }
    
    private func trackIndexForImages(indexPath: IndexPath) {
        if imagesIndexs.index(forKey: indexPath.row) == nil {
            imagesIndexs[indexPath.row] = 0
            imagesIndexs.updateValue(imagesIndexs.count, forKey: indexPath.row)
        }
    }
    
    private func remove(comment: Comment) {
        if let index = viewModel.index(comment: comment) {
            let indexPath = IndexPath(row: index, section: ContentPageTableViewSection.comments.rawValue)
            viewModel.removeComment(at: index)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadSections(IndexSet(integer: ContentPageTableViewSection.headerComment.rawValue), with: .fade)
        }
    }
    
    private func reloadCell() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func updateGifAnimation() {
        Common.repeatCall { [weak self] in
            guard let strongSelf = self else { return }
            guard strongSelf.shouldAutoPlay else { return }
            strongSelf.scrollViewDidScroll(strongSelf.tableView)
        }
    }
    
    override func backButtonPressed() {
        super.backButtonPressed()
        if viewModel.contentPageType == .postVideo {
            guard let post = viewModel.feed as? Post, let sType = post.subType,
                let subType = FeedSubType(rawValue: sType),
                subType == .video else { return }
            if let video = post.medias?.first as? Video {
                didBackFromVideoContentPage.onNext(video)
            }
        }
    }
	
	private func processHideMessageCell() {
		if self.hasLoadedFirst {
			tableView.reloadSections(IndexSet(integer: ContentPageTableViewSection.inputMessage.rawValue), with: .fade)
		}
		sendMessageHeightConstraint.constant = isHideMessageCell ? Constants.DefaultValue.inputMessageHeightCell : 0
		self.view.layoutIfNeeded()
		if isHideMessageCell { sendMessageView.forceEditing() }
		if isShowComment {
			isShowComment = false
			scrollToCommentSection()
		}
	}
	
	private func actionCommentTapped() {
		if !self.isHideMessageCell {
			self.isShowComment = true
			self.isHideMessageCell = true
		}
	}
}

private enum ContentPageTableViewSection: Int {
    case header = 0
    case ads = 1
    case paragraph = 2
    case tags = 3
    case headerComment = 4
    case comments = 5
	case loadMoreComment = 6
	case inputMessage = 7
    case relatedContent = 8
}

extension ContentPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ContentPageTableViewSection.header.rawValue {
            let numberOfRows = (viewModel.feed != nil) ? 1 : 0
            return numberOfRows
        }
        if section == ContentPageTableViewSection.ads.rawValue {
			return 1
        }
        if section == ContentPageTableViewSection.paragraph.hashValue, let article = viewModel.feed as? Article {
            return article.paragraphs.count
        }
        if section == ContentPageTableViewSection.tags.rawValue, let feed = viewModel.feed, feed.hasTag2Page {
            if let post = feed as? Post, let subtypeStr = post.subType,
                let subtype = FeedSubType(rawValue: subtypeStr), subtype == .image {
                return 0
            }
            return 1
        }
        if section == ContentPageTableViewSection.headerComment.rawValue {
            return 1
        }
        if section == ContentPageTableViewSection.comments.rawValue {
            return viewModel.comments.count
        }
		if section == ContentPageTableViewSection.loadMoreComment.rawValue {
			return 1
		}
		if section == ContentPageTableViewSection.inputMessage.rawValue {
			return 1
		}
        if section == ContentPageTableViewSection.relatedContent.rawValue,
            let relatedContents = viewModel.relatedContents {
            if self.isUnderBundleContent {
                return min(Constants.DefaultValue.defaultNumberOfRelatedContents, relatedContents.count) + 1
            }
            return relatedContents.count + 1
        }
        return 0
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == ContentPageTableViewSection.header.rawValue {
            switch viewModel.contentPageType {
            case .postText:
                return postTextHeaderCell(indexPath: indexPath)
            case .postImage:
                return postImageHeaderCell(indexPath: indexPath)
            case .postVideo:
                return videoHeaderCell(indexPath: indexPath)
            case .postEmbed:
                return embedHeaderCell(indexPath: indexPath)
            case .article:
                return articleHeaderCell(indexPath: indexPath)
            case .app:
                return appHeaderCell(indexPath: indexPath)
            case .postEpisode:
                return episodeHeaderCell(indexPath: indexPath)
            case .bundle:
                break // should never happen
            }
        }
        if indexPath.section == ContentPageTableViewSection.ads.rawValue {
            return bannerAdsCell(isArticle: false, indexPath: indexPath)
        }
        if indexPath.section == ContentPageTableViewSection.paragraph.rawValue,
            let article = viewModel.feed as? Article {
            let paragraph = article.paragraphs[indexPath.row]
            
            switch paragraph.type {
            case .text:
                return paragraphTextCell(indexPath: indexPath)
            case .image:
                return paragraphImageCell(indexPath: indexPath)
            case .embed:
                return paragraphEmbeddedCell(indexPath: indexPath)
            case .video:
                return paragraphVideoCell(indexPath: indexPath)
            case .ads:
				return bannerAdsCell(isArticle: true, indexPath: indexPath)
            default:
                return UITableViewCell()
            }
        }
        if indexPath.section == ContentPageTableViewSection.tags.rawValue, let feed = viewModel.feed,
            let tags = feed.tags {
            return taggedPagesCell(taggedPages: tags)
        }
        if indexPath.section == ContentPageTableViewSection.headerComment.rawValue {
            return headerCommentCell(comments: viewModel.comments)
        }
        if indexPath.section == ContentPageTableViewSection.comments.rawValue, !viewModel.comments.isEmpty {
            return commentCell(comment: viewModel.comments[indexPath.row])
        }
		if indexPath.section == ContentPageTableViewSection.loadMoreComment.rawValue {
			return loadMoreCommentCell()
		}
		if indexPath.section == ContentPageTableViewSection.inputMessage.rawValue {
			return inputMessageCell()
		}
        if indexPath.section == ContentPageTableViewSection.relatedContent.rawValue {
            if indexPath.row == 0 {
                return relatedContentHeaderCell(indexPath: indexPath)
            }
            return relatedContentCell(indexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == ContentPageTableViewSection.headerComment.rawValue {
            return Constants.DefaultValue.headerCommentHeight
        }
        if indexPath.section == ContentPageTableViewSection.tags.rawValue {
            return Constants.DefaultValue.taggedCellHeight
        }
        
        if let height = heightAtIndexPathDict["\(indexPath.section)-\(indexPath.row)"] {
            return height
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == ContentPageTableViewSection.headerComment.rawValue {
            return Constants.DefaultValue.headerCommentHeight
        }
        if indexPath.section == ContentPageTableViewSection.tags.rawValue {
            return Constants.DefaultValue.taggedCellHeight
        }
		if indexPath.section == ContentPageTableViewSection.inputMessage.rawValue {
			return isHideMessageCell ? 0 : Constants.DefaultValue.inputMessageHeightCell
		}
		if indexPath.section == ContentPageTableViewSection.loadMoreComment.rawValue {
			return isMoreComment ? Constants.DefaultValue.loadMoreCommentHeightCell : 0
		}
		
		if indexPath.section == ContentPageTableViewSection.paragraph.rawValue,
			let article = viewModel.feed as? Article {
			let paragraph = article.paragraphs[indexPath.row]
			if paragraph.type == .ads {
				if let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height {
					return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
						+ Constants.DefaultValue.paddingBannerAdsCellTop - Constants.DefaultValue.defaultMargin
				}
				return 0
			}
		}

		if indexPath.section == ContentPageTableViewSection.ads.rawValue {
			if let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height {
				return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
					+ Constants.DefaultValue.paddingBannerAdsCellTop
			}
			return emptyAdsHeight
		}
		
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != ContentPageTableViewSection.headerComment.rawValue &&
            indexPath.section != ContentPageTableViewSection.tags.rawValue {
            heightAtIndexPathDict["\(indexPath.section)-\(indexPath.row)"] = cell.frame.size.height
        }
        if cell is ArticleParagraphImageCell || cell is PostImageCell || cell is RelatedContentCell {
            updateGifAnimation()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == ContentPageTableViewSection.loadMoreComment.rawValue { viewModel.getComments() }
		if isHideMessageCell { isHideMessageCell = false }
		self.view.endEditing(true)
		tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ContentPageViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.isUnderBundleContent { return }
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        Components.analyticsService.logCells(visibleCells: tableView.visibleCells)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Common.shouldBypassAnimation() { return }
        
        let visibleCells = tableView.visibleCells
        Constants.Singleton.isAInlineVideoPlaying = false
		let overlapHeight = isHideMessageCell ? keyboardHeight + Constants.DefaultValue.inputMessageHeightCell : 0
        for cell in visibleCells {
            if cell is ArticleVideoCell {
                let result = Common.setAnimationFor(cell: (cell as? ArticleVideoCell)!,
                                                    viewPort: view,
                                                    isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying,
													overlapHeight: overlapHeight)
                if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
                continue
            }
            if cell is ArticleParagraphImageCell {
                _ = Common.setAnimationFor(cell: (cell as? ArticleParagraphImageCell)!, viewPort: view)
                continue
            }
            if cell is ArticleHeaderCell {
                _ = Common.setAnimationFor(cell: (cell as? ArticleHeaderCell)!, viewPort: view)
                continue
            }
            if cell is PostImageCell {
                _ = Common.setAnimationFor(cell: (cell as? PostImageCell)!, viewPort: view)
                continue
            }
            if cell is VideoHeaderCell {
                let result = Common.setAnimationFor(cell: (cell as? VideoHeaderCell)!,
                                                    viewPort: view,
                                                    isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying,
													overlapHeight: overlapHeight)
                if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
                continue
            }
            if cell is RelatedContentCell {
                _ = Common.setAnimationFor(cell: (cell as? RelatedContentCell)!, viewPort: view)
                continue
            }
        }
    }
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y <= 0 && isUnderBundleContent && hasAdsSponsored {
			tableView.isScrollEnabled = false
		}
	}
}
