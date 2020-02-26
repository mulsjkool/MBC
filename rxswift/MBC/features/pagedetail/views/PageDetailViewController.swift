//
//  PageDetailViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit
import MisterFusion

class PageDetailViewController: BaseViewController {
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var headerContainerView: UIView!
    @IBOutlet weak private var headerContainerViewiPad: UIView!
    @IBOutlet weak private var geoTargetingView: UIView!
    @IBOutlet weak private var geoTargetingTitleLabel: UILabel!
    @IBOutlet weak private var geoTargetingSubTitleLabel: UILabel!
    
    @IBOutlet weak private var pressHereButton: UIButton!
    
    private var heightAtIndexPathDict = [String: CGFloat]()
    
    private let viewModel = PageDetailViewModel(interactor: Components.pageDetailInteractor(),
                                                socialService: Components.userSocialService)
    private var pageHeaderVC: PageHeaderViewController!
    
	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action:
			#selector(PageDetailViewController.refreshData(_:)),
								 for: UIControlEvents.valueChanged)
		refreshControl.tintColor = UIColor.gray
		
		return refreshControl
	}()
    
	private let identifierPhotoAlbumsCarousellCell: String = "photoAlbumsCarousel"
    private let identifierSheCell: String = "photoAlbumsCarousel"
    private let noCustomAlbumeCellHeight = CGFloat(44)
	private let titleAppCellHeight = CGFloat(44)
    private let schedulerDaySelectionHeight = CGFloat(100)
    
    private var lastY: CGFloat = 0
    private var headerAppeared = true
    private var checkSchedulerShowTimeTimer: Timer?
    
    private lazy var dataSource: PageDetailDataSource = {
        return PageDetailDataSource(viewModel: self.viewModel)
    }()
    
    var pageUrl: String! { didSet { viewModel.setPageUrl(pageUrl) } }
    var pageId: String! { didSet { viewModel.setPageId(pageId) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindEvents()
        getPageDetail()
        getInfoComponent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Common.resetVideoPlayingStatusFor(table: tableView)
        updateGifAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.pageHeaderVC.videoHasEnded() {
            _ = self.pageHeaderVC.bindVideo()
        }
    }
    
    override func backButtonPressed() {
        for cell in tableView.visibleCells {
            if let photoCell = cell as? PhotoPostTableViewCell {
                photoCell.inlinePlayer?.videoWillTerminate()
            } else if let postCell = cell as? PostCardMultiImagesTableViewCell {
                postCell.videoCell?.inlinePlayer?.videoWillTerminate()
            }
        }

        super.backButtonPressed()
    }
    
    // MARK: GEO targeting
    
    private func checkAllowToShowPageDetail(page: PageDetail) {
        if !page.geoTargeting.isEmpty {
            if page.geoTargeting == Constants.ConfigurationGEOTargeting.country {
                geoTargetingView.isHidden = !isCurrentCountryInGEOTargetingArray(array: page.geoSuggestions)
                return
            }
            
            if page.geoTargeting == Constants.ConfigurationGEOTargeting.region {
                geoTargetingView.isHidden = !isCurrentRegionInGEOTargetingArray(array: page.geoSuggestions)
                return
            }
        }
    }
    
    private func isCurrentCountryInGEOTargetingArray(array: [String]) -> Bool {
        let countryCode = Components.sessionService.countryCode
        return array.first(where: { $0 == countryCode }) != nil
    }
    
    private func isCurrentRegionInGEOTargetingArray(array: [String]) -> Bool {
        let regionCode = Components.sessionService.currentSession()?.regionCode
        return array.first(where: { $0 == regionCode }) != nil
    }
    
    // MARK: Private functions
    
    private func setupUI() {
        self.addBackButton()
        setupTableView()
        
        let radius = pressHereButton.frame.size.height / 2
        pressHereButton.format(cornerRadius: radius, color: Colors.defaultAccentColor.color())
        
        geoTargetingView.isHidden = true
        
        geoTargetingTitleLabel.text = R.string.localizable.geoTargetTitle()
        geoTargetingSubTitleLabel.text = R.string.localizable.geoTargetSubTitle()
        pressHereButton.setTitle(R.string.localizable.geoTargetButtonTitle(), for: .normal)
    }
	
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
		tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.DefaultValue.estimatedTableRowHeight
		
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        //TO BE ADDED MORE
        tableView.register(R.nib.cardTextCell(), forCellReuseIdentifier: R.reuseIdentifier.cardTextCellId.identifier)
        if Constants.Singleton.isiPad {
            tableView.register(R.nib.iPadPostCardMultiImagesTableViewCell(),
                                     forCellReuseIdentifier:
                R.reuseIdentifier.iPadPostCardMultiImagesTableViewCellid.identifier)
            tableView.register(R.nib.iPadHomeStreamSingleItemCell(),
                                     forCellReuseIdentifier:
                R.reuseIdentifier.iPadHomeStreamSingleItemCellId.identifier)
            tableView.register(R.nib.iPadEpisodeCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.iPadEpisodeCell.identifier)
            tableView.register(R.nib.iPadAppCardTableViewCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.iPadAppCardTableViewCellid.identifier)
            tableView.register(R.nib.iPadEmbeddedCardCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.iPadEmbeddedCardCellid.identifier)
            tableView.register(R.nib.iPadPhotoCollectionView(),
                               forCellReuseIdentifier: R.reuseIdentifier.iPadPhotoCollectionViewId.identifier)
            tableView.register(R.nib.iPadPhotoAlbumsCarouselTableViewCell(),
                               forCellReuseIdentifier:
                R.reuseIdentifier.iPadPhotoAlbumsCarouselTableViewCellid.identifier)
        } else {
            tableView.register(R.nib.postCardMultiImagesTableViewCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.postCardMultiImagesTableViewCellid.identifier)
            tableView.register(R.nib.homeStreamSingleItemCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.homeStreamSingleItemCell.identifier)
            tableView.register(R.nib.episodeCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.episodeCell.identifier)
            tableView.register(R.nib.appCardTableViewCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.appCardTableViewCellid.identifier)
            tableView.register(R.nib.embeddedCardCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.embeddedCardCell.identifier)
            tableView.register(R.nib.photoPostTableViewCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.photoPostTableViewCellid.identifier)
            tableView.register(R.nib.photoAlbumsCarouselTableViewCell(),
                               forCellReuseIdentifier: R.reuseIdentifier.photoAlbumsCarouselTableViewCellid.identifier)
        }
		
        tableView.register(R.nib.aboutTabLocationCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.aboutTabLocationCell.identifier)
        tableView.register(R.nib.aboutTabMetadataCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.aboutTabMetadataCell.identifier)
        tableView.register(R.nib.aboutTabAboutCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.aboutTabAboutCell.identifier)
        tableView.register(R.nib.aboutTabSocialNetworksCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.aboutTabSocialNetworksCell.identifier)
		tableView.register(R.nib.photoNoCustomAlbumTableViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.photoNoCustomAlbumTableViewCellid.identifier)
		tableView.register(R.nib.pageAppTableViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.pageAppTableViewCellid.identifier)
        tableView.register(R.nib.bannerAdsViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.bannerAdsViewCell.identifier)
        tableView.register(R.nib.pageBundleCarouselCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.pageBundleCarouselCell.identifier)
        tableView.register(R.nib.carouselTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.carouselTableViewCellid.identifier)
        tableView.register(R.nib.scheduleTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.scheduleTableViewCellid.identifier)
        tableView.register(R.nib.schedulerDaySelectionCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.schedulerDaySelectionCellid.identifier)
        tableView.register(R.nib.episodePageTabCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.episodePageTabCell.identifier)
        tableView.register(R.nib.videoSingleItemCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.videoSingleItemCellId.identifier)
    
    }
    
    private func setupData() {
        title = viewModel.details?.title ?? ""
        
        displayPageContent(dataSource.landingTab)
    }
    
    private func setupPageHeader() {
        pageHeaderVC.viewModel =
            PageHeaderViewModel(pageDetail: viewModel.details)
        pageHeaderVC.bindData()
    }
    
    private func setupPageDetail() {
        if let page = viewModel.pageDetail {
            Components.analyticsService.logEvent(trackingObject: AnalyticsPage(pageDetail: page,
                                                                               pageAddress: page.universalUrl))
            dataSource.dataReadyForBundles = !page.bundles.isEmpty
            self.checkAllowToShowPageDetail(page: page)
        }
        setupPageHeader()
        setupData()
        if let universalUrl = viewModel.getUniversalUrl() {
            pageHeaderVC.requestAds(universalAddress: universalUrl)
        }
    }
    
    private func bindEvents() {
        dataSource.delegate = self
        
        disposeBag.addDisposables([
            pressHereButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.backButtonPressed()
            }),
            
            viewModel.onWillStartGetInfoComponent.subscribe(onNext: {}),
            viewModel.onWillStopGetInfoComponent.subscribe(onNext: {}),
            viewModel.onDidGetInfoComponent.subscribe(onNext: { info in
                print(info.count)
            }),
            viewModel.onWillStartGetPageDetail.subscribe(onNext: { [unowned self] _ in
                self.pageHeaderVC.view.alpha = 0
            }),
            viewModel.onWillStopGetPageDetail.subscribe(onNext: { [unowned self] _ in
                self.pageHeaderVC.view.alpha = 1
            }),
            viewModel.onDidGetPageDetailByUrl.subscribe(onNext: { [weak self] _ in
                self?.setupPageDetail()
            }),
            viewModel.onDidGetPageDetailById.subscribe(onNext: { [weak self] _ in
                self?.setupPageDetail()
            }),
            viewModel.onErrorGetDetail.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.setupPageHeader()
                self?.setupData()
                self?.showMessage(message: R.string.localizable.errorDataNotAvailable())
            }),
			viewModel.onWillStartGetListItem.subscribe(onNext: {  [unowned self] _ in
				self.dataSource.isMoreDataAvailable = true
                self.dataSource.dataReadyForPhotos.displayingPhotos = false
                self.dataSource.dataReadyForVideo.displayingVideo = false
                self.dataSource.dataReadyForScheduler = false
			}),
            viewModel.onDidLoadItems.subscribe(onNext: { [weak self] _ in
                self?.dataSource.setItemDataReady()
                self?.refreshControl.endRefreshing()
                self?.updateContent()
            }),
            viewModel.onDidLoadAlbums.subscribe(onNext: { [weak self] _ in
				self?.dataSource.dataReadyForPhotos.titledAlbum = true
                self?.updateContent()
            }),
            viewModel.onDidLoadCustomVideoPlaylist.subscribe(onNext: { [weak self] _ in
                self?.dataSource.dataReadyForVideo.titledPlaylist = true
                self?.updateContent()
            }),
			viewModel.onFinishLoadListItem.subscribe(onNext: { [unowned self] in
                self.dataSource.setItemDataReady()
				self.dataSource.isMoreDataAvailable = false
			}),
            viewModel.onErrorLoadListItem.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.dataSource.dataReadyForStream = true
                self?.dataSource.isMoreDataAvailable = false
                self?.updateContent()
            }),
            viewModel.onErrorLoadAlbums.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.dataSource.dataReadyForPhotos.titledAlbum = true
                self?.updateContent()
            }),
            viewModel.onErrorLoadCustomVideoPlaylist.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.dataSource.dataReadyForVideo.titledPlaylist = true
                self?.updateContent()
            }),
            viewModel.onWillStartScheduledChannelList.subscribe(onNext: {}),
            viewModel.onWillStopScheduledChannelList.subscribe(onNext: {}),
            viewModel.onDidLoadScheduledChannelList.subscribe(onNext: { [weak self] array in
                print(array.count)
                self?.pageHeaderVC.viewModel.setScheduledChannelList(array)
                self?.pageHeaderVC.loadAvatarForChannel()
            }),
            
            // Page header VC
            
            pageHeaderVC.didShowProgramBar.subscribe(onNext: { [unowned self] _ in
                self.viewModel.getScheduledChannelList()
            }),
            pageHeaderVC.selectedMenuItem.subscribe(onNext: { [unowned self] item in
                self.displayPageContent(item)
            }),
            pageHeaderVC.didLayoutSubviews.throttle(0.1, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] _ in
                    if Constants.Singleton.isiPad {
                        self.headerContainerView.frame.size.height = 0
                        guard self.headerContainerViewiPad.frame.size.height != self.pageHeaderVC.viewHeight
                            else { return }
                        self.headerContainerViewiPad.frame.size.height = self.pageHeaderVC.viewHeight
                    } else {
                        self.headerContainerViewiPad.frame.size.height = 0
                        guard self.headerContainerView.frame.size.height != self.pageHeaderVC.viewHeight else { return }
                        self.headerContainerView.frame.size.height = self.pageHeaderVC.viewHeight
                    }
                    self.reloadTableView()
            }),
            pageHeaderVC.coverPhotoTapped.subscribe(onNext: { [unowned self] url in
                print("\(self) coverPhotoTapped tapped \(url)")
                self.showFullscreenImage(url: url)
            }),
            pageHeaderVC.posterPhotoTapped.subscribe(onNext: { [unowned self] url in
                print("\(self) posterPhotoTapped tapped \(url)")
                self.showFullscreenImage(url: url)
            }),
            pageHeaderVC.promoVideoTapped.subscribe(onNext: { [unowned self] video in
                self.navigator?.pushVideoPlaylistFrom(videos: [video], videoIndex: 0, videoId: video.id)
            }),
            pageHeaderVC.didbtPopupScheduleClicked.subscribe(onNext: { [unowned self] array in
                if let arr = array, !arr.isEmpty {
                    self.navigator?.presentAirTimeList(viewModel: self.viewModel)
                }
            }),
            pageHeaderVC.didbtChannelPageClicked.subscribe(onNext: { [unowned self] strID in
                self.navigator?.pushPageDetail(pageUrl: "", pageId: strID)
            })
        ])
    }
    
    private func showFullscreenImage(url: String) {
        guard let pageId = self.viewModel.pageDetail?.entityId,
            let author = self.viewModel.author else { return }
        
        self.showFullScreenImageFrom(imageUrl: url, pageId: pageId,
                                     accentColor: self.viewModel.getAccentColor(),
                                     author: author)
    }
    
    private func beginCheckSchedulerShowTime() {
        if self.checkSchedulerShowTimeTimer == nil { checkSchedulerShowTime() }
        self.checkSchedulerShowTimeTimer = Timer.scheduledTimer(
            timeInterval: Constants.DefaultValue.checkSchedulerShowTimeInterval, target: self,
                                                                selector: #selector(checkSchedulerShowTime),
                                                                userInfo: nil, repeats: true)
    }
    
    private func endCheckSchedulerShowTime() {
        self.checkSchedulerShowTimeTimer?.invalidate()
        self.checkSchedulerShowTimeTimer = nil
    }
    
    @objc
    private func checkSchedulerShowTime() {
        guard dataSource.selectingMenu == .schedule, !self.viewModel.itemsList.list.isEmpty,
            self.dataSource.getCurrentSchedulerDay() < self.viewModel.itemsList.list.count,
            let schedulerOnday = self.viewModel.itemsList.list[self.dataSource.getCurrentSchedulerDay()]
            as? SchedulersOnDay else {
            endCheckSchedulerShowTime()
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { // 1
            let now = Date()
            var rowIndex: Int?
            var isNeedScrollToShowTime = false
            for scheduler in schedulerOnday.list {
                scheduler.isOnShowTime = (now >= scheduler.startTime && now <= scheduler.endTime)
                if scheduler.isOnShowTime {
                    rowIndex = scheduler.rowIndex
                    DispatchQueue.main.async {
                        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows {
                            for indexPath in visibleIndexPaths {
                                isNeedScrollToShowTime = indexPath.row == rowIndex
                            }
                        }
                    }
                    break
                }
            }
            DispatchQueue.main.async { // 2
               self.reloadTableView()
                if let rowIndex = rowIndex {
                    if isNeedScrollToShowTime {
                        self.tableView.scrollToRow(at: IndexPath(row: rowIndex, section: 1 ),
                                                   at: .middle, animated: true)
                    }
                }
            }
        }
    }

    private func getPageDetail() {
        self.viewModel.getPageDetail()
    }
    
    private func getInfoComponent() {
        self.viewModel.getInfoComponentByPageId()
    }
    
    private func reloadTableView() {
        tableView.reloadData()
        Components.analyticsService.logCells(visibleCells: tableView.visibleCells)
    }
    
    private func displayPageContent(_ item: PageMenuEnum) {
        // swap to selecting menu content
        dataSource.selectingMenu = item
        switch dataSource.selectingMenu {
        case .newsfeed:
            addRefeshControl()
            viewModel.resetItemsAndLoadItemsFor(pageMenu: dataSource.selectingMenu)
			reloadTableView()
        case .photos:
			addRefeshControl()
			dataSource.dataReadyForPhotos = (false, false)
			viewModel.resetItemsAndLoadItemsFor(pageMenu: dataSource.selectingMenu)
            print("ITEM LIST = \(viewModel.itemsList.list.count)")
			reloadTableView()
            print("START GET DATA")
            viewModel.loadAlbums()
        case .apps:
			addRefeshControl()
			viewModel.resetItemsAndLoadItemsFor(pageMenu: dataSource.selectingMenu)
			reloadTableView()
        case .videos:
            addRefeshControl()
            viewModel.resetItemsAndLoadItemsFor(pageMenu: dataSource.selectingMenu)
            reloadTableView()
            viewModel.loadCustomVideoPlaylist()
        case .about:
            removeRefreshControl()
			updateContent()
        case .schedule:
            addRefeshControl()
            viewModel.resetItemsAndLoadItemsFor(pageMenu: dataSource.selectingMenu)
            reloadTableView()
        case .episodes:
            addRefeshControl()
            viewModel.resetItemsAndLoadItemsFor(pageMenu: dataSource.selectingMenu)
            reloadTableView()
        default:
			viewModel.resetData()
			removeRefreshControl()
            reloadTableView()
		}
    }
	
	private func removeRefreshControl() {
		self.refreshControl.removeFromSuperview()
	}
	
	private func addRefeshControl() {
		if self.refreshControl.superview == nil {
			self.tableView.addSubview(self.refreshControl)
		}
	}
	
    private func updateContent() {
        guard dataSource.isCorrectTab else { return }
        
		reloadTableView()
        if dataSource.selectingMenu == .schedule {
            beginCheckSchedulerShowTime()
        }
       // updateLoadMoreData() // try to use update loadmore instead tableview.reloaddata
    }
	
	func updateLoadMoreData() {
		UIView.setAnimationsEnabled(false)
		self.tableView.beginUpdates()
		var indexPaths = [IndexPath]()
		let numberCellLoadmore = self.dataSource.isMoreDataAvailable ? 0 : 1
		for row in (self.viewModel.currentCountItemData..<(self.viewModel.lastestCountItemData
			- numberCellLoadmore)
			) {
			indexPaths.append(IndexPath(row: row, section: 0))
		}
		self.tableView.insertRows(at: indexPaths, with: .none)
		self.tableView.endUpdates()
		UIView.setAnimationsEnabled(true)
	}
	
	@objc
	private func refreshData(_ refreshControl: UIRefreshControl) {
        dataSource.isMoreDataAvailable = false
        viewModel.clearCache()
		dataSource.resetCachingAds()
        getPageDetail()
        getInfoComponent()
	}

    private func heightForAboutCell(indexPath: IndexPath) -> CGFloat {
        let aboutTabData = dataSource.getAboutTabData()
        let rowDict = aboutTabData[indexPath.row]
        if let rowKey = rowDict.keys.first, let row = PageAboutRow(rawValue: rowKey) {
            switch row {
            case .location:
                return 304.0
            case .socialNetworks:
                return 145.0
            default:
                return UITableViewAutomaticDimension
            }
        }
        return 0
    }

    private func updateGifAnimation() {
        Common.repeatCall { [weak self] in
            guard let tableView = self?.tableView else { return }
            self?.scrollViewDidScroll(tableView)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        tableView.tableFooterView = nil
        if Constants.Singleton.isiPad {
            if segue.identifier == R.segue.mbcPageDetailViewController.seguePagedetailPageheaderipad.identifier {
                guard let pageHeaderViewController = segue.destination as? PageHeaderViewController else { return }
                pageHeaderVC = pageHeaderViewController
                tableView.tableHeaderView = self.headerContainerViewiPad
            }
        } else {
            if segue.identifier == R.segue.mbcPageDetailViewController.seguePagedetailPageheader.identifier {
                guard let pageHeaderViewController = segue.destination as? PageHeaderViewController else { return }
                pageHeaderVC = pageHeaderViewController
                tableView.tableHeaderView = self.headerContainerView
            }
        }
    }
}

extension PageDetailViewController: PageDetailDataSourceDelegate {
	func reloadCell(at indexPath: IndexPath) {
		self.tableView.reloadRows(at: [indexPath], with: .fade)
	}
	
    func pushVideoPlaylistFrom(customPlaylist: VideoPlaylist) {
        navigator?.pushVideoPlaylistFrom(customPlaylist: customPlaylist)
    }
    
    func pushVideoPlaylistFromDefault(defaultPlaylist: VideoDefaultPlaylist, videoId: String?) {
        navigator?.pushVideoPlaylistFromDefault(defaultPlaylist: defaultPlaylist, videoId: videoId)
    }
    
    func pushVideoPlaylistFrom(feed: Feed) {
        navigator?.pushVideoPlaylistFrom(feed: feed)
    }
    
    func navigateToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?) {
        navigator?.navigateToContentPage(feed: feed, isShowComment: isShowComment, cell: cell)
    }
    
    func reloadCell() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func reloadCellIn(section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .none)
    }
    
    func pushAppWhitePage(app: App) {
        navigator?.pushAppWhitePage(app: app)
    }
    
    func navigateToPageDetail(pageUrl: String, pageId: String) {
        navigator?.pushPageDetail(pageUrl: pageUrl, pageId: pageId)
    }
    
    func navigateToPageDetail(feed: Feed) {
        if !pageUrl.isEmpty && feed.author?.universalUrl == pageUrl { return }
        if !pageId.isEmpty && feed.author?.authorId == pageId { return }
        navigator?.navigateToPageDetail(feed: feed)
    }
    
    func openShahidEmbedded(url: URL, appStore: String?) {
        self.openInAppBrowserWithShahidEmbedded(url: url, appStore: appStore)
    }
    
    func navigateToPageDetail(author: Author) {
        if !pageUrl.isEmpty && author.universalUrl == pageUrl { return }
        if !pageId.isEmpty && author.authorId == pageId { return }
        navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
    }
    
    func navigateToTaggedPageListing(authors: [Author]) {
        navigator?.presentTaggedPageListing(authorList: authors)
    }
    
    func navigateToContentPage(video: Video, isShowComment: Bool, cell: UITableViewCell?) {
        navigator?.navigateToContentPage(video: video, isShowComment: isShowComment, cell: cell)
    }
}

extension PageDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPathDict["\(indexPath.section)_\(indexPath.row)"] {
            return height
        }
        
        return UITableViewAutomaticDimension
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource.selectingMenu == .about {
            return heightForAboutCell(indexPath: indexPath)
        }
		
		if dataSource.selectingMenu == .photos && indexPath.section == 0 {
            if !dataSource.dataReadyForPhotos.titledAlbum {
                return Constants.DefaultValue.PlaceHolderLoadingHeight
            }
            if viewModel.albumsList.list.isEmpty { return noCustomAlbumeCellHeight }
			return UITableViewAutomaticDimension
        } else if dataSource.selectingMenu == .photos && indexPath.section == 1 {
            if Constants.Singleton.isiPad {
                 if viewModel.albumsList.list.isEmpty { return 0 }
                return ceil(CGFloat(viewModel.itemsList.list.count) /
                    CGFloat(Constants.DefaultValue.numberOfItemPhotoDefaullAlbumInLine)) *
                    Common.getPhotoAlbumItemHeight()
            }
        }
        
        if dataSource.selectingMenu == .videos && indexPath.section == 0 {
            if !dataSource.dataReadyForVideo.titledPlaylist {
                return Constants.DefaultValue.PlaceHolderLoadingHeight
            }
            if viewModel.albumsList.list.isEmpty { return noCustomAlbumeCellHeight }
            return UITableViewAutomaticDimension
        }
        
		if dataSource.selectingMenu == .apps && indexPath.section == 0 {
			if !dataSource.dataReadyForApp {
                return Constants.DefaultValue.PlaceHolderLoadingHeight
            }
			return titleAppCellHeight
		}
        
        if dataSource.selectingMenu == .schedule && indexPath.section == 0 {
            if !dataSource.dataReadyForScheduler {
                return Constants.DefaultValue.PlaceHolderLoadingHeight
            }
            return schedulerDaySelectionHeight
        }
        
        if dataSource.selectingMenu == .newsfeed {
            if indexPath.section == PageDetailNewsFeedTabSection.bundles.rawValue {
                return dataSource.dataReadyForBundles ? Constants.DefaultValue.bundleCarouselCellOnPageStreamHeight : 0
            }
            if let heightCell = dataSource.bannerAdsHeightCell(at: indexPath) { return heightCell }
            if indexPath.section == PageDetailNewsFeedTabSection.newsFeed.rawValue
                && viewModel.itemsList.list.isEmpty {
                return Constants.DefaultValue.PlaceHolderLoadingHeight
            }
        }
        
        if dataSource.selectingMenu == .episodes && indexPath.section == 0 {
            if !dataSource.dataReadyForEpisodes {
                return Constants.DefaultValue.PlaceHolderLoadingHeight
            }
            return titleAppCellHeight
        }
        
		return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is PhotoPostTableViewCell || cell is PostCardMultiImagesTableViewCell { updateGifAnimation() }
        heightAtIndexPathDict["\(indexPath.section)_\(indexPath.row)"] = cell.frame.size.height
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        Components.analyticsService.logCells(visibleCells: tableView.visibleCells)
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Common.shouldBypassAnimation() { return }
        
        let visibleCells = tableView.visibleCells
        Constants.Singleton.isAInlineVideoPlaying = false
        for cell in visibleCells {
            if let postCell = cell as? PostCardMultiImagesTableViewCell {
                let result = Common.setAnimationFor(cell: postCell,
                                                    viewPort: view,
                                                    isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying)
                if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
                continue
            }
            
            if let videoSingleCell = cell as? VideoSingleItemCell {
                let result = Common.setAnimationFor(cell: videoSingleCell,
                                                    viewPort: view,
                                                    isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying)
                if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
                continue
            }
            
            if let photoCell = cell as? PhotoPostTableViewCell {
                let result = Common.setAnimationFor(cell: photoCell,
                                           viewPort: view,
                                           isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying)
                if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
                continue
            }
        }
        setAnimatedForHeader(scrollView: scrollView)
    }
    
    private func setAnimatedForHeader(scrollView: UIScrollView) {
        let currentY: CGFloat = scrollView.contentOffset.y
        let headerHeight: CGFloat = self.pageHeaderVC.view.frame.size.height
        
        if lastY <= headerHeight && currentY > headerHeight {
            headerAppeared = false
        }
        
        if lastY > headerHeight && currentY <= headerHeight {
            headerAppeared = true
        }
        
        lastY = currentY
        
        if headerAppeared {
            let result = Common.setAnimationFor(viewController: self.pageHeaderVC, viewPort: view,
                                       isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying)
            if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
        }
    }
}
