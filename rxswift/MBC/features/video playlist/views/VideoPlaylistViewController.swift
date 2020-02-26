//
//  VideoPlaylistViewController.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/30/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import THEOplayerSDK

class VideoPlaylistViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    
	private let viewModel = VideoPlaylistViewModel(interactor: Components.videoPlaylistInteractor())
    
    private var isMoreDataAvailable = true
    private var currentVideoIndex: Int = 0
    private var feed: Feed?
    private var titleString: String?
    private var videoId: String?
    private var nextVideoCountDownView = NextVideoCountDownView()
	private var adsCells = [IndexPath: AdsContainer]() // caching ads
	private var hasAdsSponsored: Bool = false
    private var isDefaultPlaylist: Bool = false

    private var scrollingStatus: ScrollingStatus = .autoPlay

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(VideoPlaylistViewController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    var shouldAutoPlay: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTitle()
        setupUI()
        self.perform(#selector(setupView), with: nil, afterDelay: Constants.DefaultValue.durationAfterViewDidLoad)
        
    }
    
    @objc
    private func setupView() {
        bindEvents()
        getDetailPlaylist()
        updateVideoListeners()
        setUpViewCountDown()
        scrollToVideoIndex()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseVideosWhenLeaving()
    }

    override func backButtonPressed() {
        for cell in tableView.visibleCells {
            if let videoCell = cell as? VideoPlaylistTableViewCell {
                videoCell.inlinePlayer.videoWillTerminate()
            }
        }
        super.backButtonPressed()
    }
	
	override func listenToggleScroll(toggleSubject: BehaviorSubject<(Bool, Bool)>) {
		disposeBag.addDisposables([
			toggleSubject.subscribe(onNext: { [unowned self] hasAds, canScroll in
				self.hasAdsSponsored = hasAds
				self.tableView.isScrollEnabled = canScroll
			})
		])
	}
    
    private func showTitle() {
        guard let titleVal = self.titleString else {
            self.title = R.string.localizable.cardTypeVideo()
            return
        }
        if isDefaultPlaylist {
            self.title = String(format: "\(titleVal) %@", R.string.localizable.cardTypeVideo())
        } else {
            self.title = titleVal
        }
    }
    
    private func scrollToVideoIndex() {
        guard !viewModel.itemsList.list.isEmpty else { return }
		self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let indexPath = IndexPath(row: self.currentVideoIndex, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        })
    }
    
    private func updateVideoListeners() {
        VideoFullscreenLandscapeView.shared.shouldLoadNextVideo = true
        disposeBag.addDisposables([
            VideoFullscreenLandscapeView.shared.endVideoEvent.subscribe(onNext: { [weak self] video in
                self?.playNextVideoFrom(currentVideo: video)
            }),
            VideoFullscreenLandscapeView.shared.getNextVideoFromVideo.subscribe(onNext: { [weak self] currentVideo in
                if let strongSelf = self,
                    let currentIndex = self?.viewModel.itemsList.list.index(where: { $0 === currentVideo }) {
                   if currentIndex < strongSelf.viewModel.itemsList.list.count - 1 {
                        guard let indexPath = strongSelf.nextIndexOfVideo(currentIndex: currentIndex) else { return }
                        if let nextVideo = strongSelf.viewModel.itemsList.list[indexPath.row] as? Video {
                            self?.currentVideoIndex = indexPath.row
                            VideoFullscreenLandscapeView.shared.videoloadingNextView.bindData(video: nextVideo)
                             VideoFullscreenLandscapeView.shared.shouldLoadNextVideo =
                                indexPath.row < strongSelf.viewModel.itemsList.list.count - 1
                        }
                   }
                }
            }),
            VideoFullscreenLandscapeView.shared.videoOrientStationChange.subscribe(onNext: { [weak self] modeChanged in
                self?.scrollToIndex(mode: modeChanged)
            })
        ])
    }
    
    private func scrollToIndex(mode: PresentationMode) {
        if mode == .inline {
            self.scrollToVideoIndex()
        }
    }
    
    private func playNextVideoFrom(currentVideo: Video) {
        if let currentIndex = viewModel.itemsList.list.index(where: { ($0 as? Video)?.id == currentVideo.id }) {
            if currentIndex < viewModel.itemsList.list.count - 1 {
                guard let indexPath = nextIndexOfVideo(currentIndex: currentIndex) else { return }
                if let nextVideo = viewModel.itemsList.list[indexPath.row] as? Video {
                    nextVideo.currentTime.value = 0
                    nextVideo.hasEnded.value = false
                    VideoFullscreenLandscapeView.shared.video = nextVideo
                    VideoFullscreenLandscapeView.shared.inlinePlayer?.setVideoForFullscreenLandscape(video: nextVideo)
                    VideoFullscreenLandscapeView.shared.inlinePlayer?.resumePlaying(toResume: true, autoNext: true)
                    
                    if !Constants.Singleton.isLandscape {
                        Common.generalAnimate(duration: Constants.DefaultValue.animateDurationForNextVideo, animation: {
                            self.scrollingStatus = .autoScrolling
                            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle,
                                                       animated: false)
                        })
                    }
                }
            }
        }
    }
	
	private func nextIndexOfVideo(currentIndex: Int) -> IndexPath? {
		var tmpIndex = currentIndex
		while tmpIndex < viewModel.itemsList.list.count - 1 {
			tmpIndex += 1
            if (viewModel.itemsList.list[tmpIndex] as? Video) != nil {
                return IndexPath(item: tmpIndex, section: 0)
            }
		}
		return nil
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.resetVideoPlayingStatusFor(table: tableView)
        updateGifAnimation()
    }
    
    // MARK: Public
    func bindDataFrom(pageId: String, contentId: String, videoId: String? = nil) {
        viewModel.setPageId(pageId: pageId)
        viewModel.setContentId(contentId: contentId)
        self.videoId = videoId
    }
    
    func bindDataFrom(customPlaylist: VideoPlaylist) {
        guard let playlistId = customPlaylist.id else { return }
        self.titleString = customPlaylist.title
        viewModel.setPlaylistId(playlistId: playlistId)
    }
    
    func bindDataFrom(playlistId: String, title: String?) {
        self.titleString = title
        viewModel.setPlaylistId(playlistId: playlistId)
    }
    
    func bindDefaultPlaylistFrom(defaultPlaylist: VideoDefaultPlaylist, videoId: String? = nil) {
        isDefaultPlaylist = true
        self.videoId = videoId
         self.titleString = defaultPlaylist.author.name
        viewModel.setPageId(pageId: defaultPlaylist.pageId)
        viewModel.setAccentColor(accentColor: defaultPlaylist.accentColor)
    }
    
    func bindDataFrom(feed: Feed) {
        if let author = feed.author {
            viewModel.setPageId(pageId: author.authorId)
        }
        self.feed = feed
        viewModel.setContentId(contentId: feed.uuid)
    }
    
    func bindDataFrom(videos: [Video], videoIndex: Int, videoId: String? = nil) {
        viewModel.setVideos(videos: videos)
        self.videoId = videoId
        if let index = getIndexFirstTime() {
            currentVideoIndex = index
        }
    }
    
    func pauseVideosWhenSwipedOutOfBundle() {
        pauseVideosWhenLeaving()
    }
    
    private func pauseVideosWhenLeaving() {
        for cell in tableView.visibleCells {
            if let videoCell = cell as? VideoPlaylistTableViewCell {
                _ = videoCell.playVideo(false)
            }
        }
    }
    
    func resumePlayingVideosWhenSwipedInBundle() {
        updateGifAnimation()
    }
    
    // MARK: Private
    private func setupUI() {
        addBackButton()
        setupTableView()
    }
    
    private func bindEvents() {
        guard self.viewModel.pageId != nil || self.viewModel.playlistId != nil else { return }
        disposeBag.addDisposables([
            viewModel.onWillStartGetListItem.subscribe(onNext: {  [unowned self] _ in
                self.isMoreDataAvailable = true
            }),
            viewModel.onDidLoadItems.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.updateContent()
            }),
            viewModel.onFinishLoadListItem.subscribe(onNext: { [unowned self] in
                self.isMoreDataAvailable = false
            }),
            viewModel.onErrorLoadListItem.subscribe(onNext: { [weak self] _ in
                self?.isMoreDataAvailable = false
                self?.showMessage(message: R.string.localizable.errorDataNotAvailable())
            })
        ])
    }
    
    private func getIndexFirstTime() -> Int? {
        var videoId = ""
        var currentTime: Double?
        
        if let video = (self.feed as? Post)?.medias?.first as? Video {
            videoId = video.id
            currentTime = video.currentTime.value
        }
        if let id = self.videoId { videoId = id }
        guard !videoId.isEmpty else { return nil }
        for index in 0..<viewModel.itemsList.list.count {
            if let item = viewModel.itemsList.list[index] as? Video {
                if item.id == videoId {
                    if let currentTime = currentTime {
                        item.currentTime.value = currentTime
                    }
                    return index
                }
            }
        }
        return nil
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.DefaultValue.estimatedTableRowHeight
        tableView.backgroundColor = UIColor.black
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        fillOverlayGradientForTable()
        tableView.register(R.nib.videoPlaylistTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.videoPlaylistTableViewCellid.identifier)
		tableView.register(R.nib.bannerAdsViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.bannerAdsViewCell.identifier)
    }
    
    private func fillOverlayGradientForTable() {
        let gradient = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = Constants.DefaultValue.gradientForVideoPlaylist
        gradient.locations = [0, 0.1]
        tableView.superview?.layer.addSublayer(gradient)
        tableView.backgroundColor = UIColor.clear
    }
    
    private func getDetailPlaylist() {
        viewModel.getDetailPlaylist()
    }
    
    private func updateContent() {
        tableView.reloadData()
        if let index = getIndexFirstTime() {
            currentVideoIndex = index
            scrollToVideoIndex()
        }
    }
    
    func updateGifAnimation() {
        Common.repeatCall { [weak self] in
            guard let strongSelf = self else { return }
            guard strongSelf.shouldAutoPlay else { return }
            strongSelf.scrollViewDidScroll(strongSelf.tableView)
        }
    }
    
    @objc
    private func refreshData(_ refreshControl: UIRefreshControl) {
        isMoreDataAvailable = false
		adsCells.removeAll()
        //viewModel.clearCache()
    }
    
    private func createLoadmoreCell(_ indexPath: IndexPath) -> UITableViewCell? {
        if viewModel.itemsList.list.isEmpty ||
            indexPath.row < viewModel.itemsList.count ||
            !isMoreDataAvailable { return nil }
        loadMoreData()
        return Common.createLoadMoreCell()
    }
    
    private func loadMoreData() {
            //viewModel.loadItems()
    }
    
    private func setUpViewCountDown() {
        nextVideoCountDownView.disposeBag.addDisposables([
            nextVideoCountDownView.endCountDown.subscribe(onNext: { [weak self] _ in
                self?.hideNextVideoCountDownView()
            })
        ])
    }
	
    private func videoPlaylistCell(video: Video, indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.videoPlaylistTableViewCellid.identifier) as? VideoPlaylistTableViewCell {
            cell.bindData(videoItem: video, accentColor: viewModel.accentColor,
                          isLastVideoInPlaylist: indexPath.row == (viewModel.itemsList.list.count - 1))
			cell.disposeBag.addDisposables([
				cell.endVideoEvent.subscribe(onNext: { [weak self] video in
                    if !Constants.Singleton.isLandscape {
                        self?.playNextVideoFrom(currentVideo: video)
                    }
				}),
				cell.commentTapped.subscribe(onNext: { [weak self] data in
					guard let video = data as? Video, let pageId = video.author?.authorId, !video.id.isEmpty else { return }
					self?.showPopupComment(pageId: pageId, contentId: video.contentId, contentType: MediaType.video.rawValue)
				}),
                cell.shareTapped.subscribe(onNext: { [weak self] data in
                    self?.getURLFromObjAndShare(obj: data)
                }),
                cell.expandedText.subscribe(onNext: { [weak self] _ in
                    self?.reloadCell()
                }),
                cell.showNextVideoCountDown.subscribe(onNext: { [weak self] view in
                    self?.showNextVideoCountDownViewfrom(view: view)
                }),
                cell.hideNextVideoCountDown.subscribe(onNext: { [weak self] _ in
                    self?.hideNextVideoCountDownView()
                }),
                cell.didTapButtonTaggedPages.subscribe(onNext: { [weak self] video in
                    self?.viewModel.getTaggedPages(media: video)
                })
			])
			return cell
		}
		return Common.createDummyCellWith(title: "Invalid cell video")
	}
    
    private func showNextVideoCountDownViewfrom(view: UIView) {
        
            let realFrame = view.convert(view.bounds, to: tableView)
            nextVideoCountDownView.frame = CGRect(x: 0, y: realFrame.origin.y,
                                                                          width: Constants.DeviceMetric.screenWidth,
                                                                          height: 60)
            tableView.addSubview(nextVideoCountDownView)
            nextVideoCountDownView.startUpdateProgess()
        
    }
    
    private func hideNextVideoCountDownView() {
        nextVideoCountDownView.resetView()
        nextVideoCountDownView.removeFromSuperview()
    }
	
	private func bannerAdsCell(indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.bannerAdsViewCell.identifier) as? BannerAdsViewCell else { return UITableViewCell() }
		cell.setBottomSpacingColor(color: Colors.black.color())
        cell.applyColor(backgroundColor: Colors.black.color(), titleColor: Colors.unselectedTabbarItem.color())
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath] {
				ads.requestAds(adsType: .banner, viewController: self)
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
	
	private func reloadCell() {
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}

extension VideoPlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if viewModel.itemsList.list[indexPath.row] is BannerAds {
			if let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height {
				return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
					+ Constants.DefaultValue.paddingBannerAdsCellTop
			}
			return 0
		}
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = createLoadmoreCell(indexPath) { return cell }
        // create cell for video
        if let video = viewModel.itemsList.list[indexPath.row] as? Video {
            return videoPlaylistCell(video: video, indexPath: indexPath) }
		if viewModel.itemsList.list[indexPath.row] is BannerAds { return bannerAdsCell(indexPath: indexPath) }
        return Common.createDummyCellWith(title: "Invalid cell video")
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollingStatus = .didBeginDecelerating
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Common.shouldBypassAnimation() { return }
        
        let visibleCells = tableView.visibleCells
        Constants.Singleton.isAInlineVideoPlaying = false
        for cell in visibleCells where cell is VideoPlaylistTableViewCell {
            guard let videoCell = cell as? VideoPlaylistTableViewCell else { continue }
            videoCell.autoNext = scrollingStatus.isAutoNext()

            let result = Common.setAnimationFor(cell: videoCell,
                                                viewPort: view,
                                                isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying)
            if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
        }
    }
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView.contentOffset.y <= 0 && isUnderBundleContent && hasAdsSponsored {
			tableView.isScrollEnabled = false
		}
	}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateGifAnimation()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.isUnderBundleContent { return }
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
}
