//
//  BundleContentViewController.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxSwift

class BundleContentViewController: BaseViewController {
    // MARK: Outlets
	@IBOutlet weak private var containerScrollView: UIScrollView!
	@IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var headerView: BundleHeaderView!
    @IBOutlet weak private var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var bundleSponsorViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var adsContainerView: UIView!
    @IBOutlet weak private var headerTopConstraint: NSLayoutConstraint!
	@IBOutlet weak private var contentScrollHeightConstraint: NSLayoutConstraint!
	
    // MARK: Properties
    let screenWidth = Constants.DeviceMetric.screenWidth
    var viewModel: BundleContentViewModel!
    var isShowComment: Bool = false
	var hasAdsSponsored: Bool = false
	
	let onToggleScrollSubject = BehaviorSubject<(Bool, Bool)>(value: (false, false))
    
    private var selectedIndex = 0
    private var scrollViewHeight: CGFloat = 0.0
    private var loadedControllers: [BaseViewController?]!
    private var bundleItems = [Feed]()
    private var itemIds = [BundleItem]()
	private var adsContainer = AdsContainer()
    private var currentVC: BaseViewController?
    
    // MARK: Events
    override func viewDidLoad() {
        super.viewDidLoad()
        bindEvents()
        getContentPage()
		contentScrollHeightConstraint.constant = Constants.DeviceMetric.screenHeight
													- Constants.DeviceMetric.statusBarHeight
													- headerViewHeight.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Private functions
    private func setupUI() {
        setupScrollView()
    }
    
    private func getContentPage() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.getContent()
        })
    }
    
    private func requestAds(universalAddress: String?) {
		if adsContainer.getBannerAds() == nil {
			adsContainer.requestAds(adsType: .sponsored, viewController: self, universalUrl: universalAddress ?? "")
			adsContainer.disposeBag.addDisposables([
				adsContainer.loadAdSuccess.subscribe(onNext: { [unowned self] _ in
					self.hasAdsSponsored = true
					self.addSponsoredAds()
					self.modifyOffsetScroll()
                }),
				adsContainer.loadAdFail.subscribe(onNext: { [unowned self] _ in
					self.onToggleScrollSubject.onNext((self.hasAdsSponsored, true))
				}),
                adsContainer.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                    self?.openInAppBrowser(url: URL(string: urlString)!)
                })
			])
		}
    }
	
	private func addSponsoredAds() {
		if let adsView = adsContainer.getBannerAds() {
			bundleSponsorViewHeight.constant = adsView.bounds.height
			adsView.translatesAutoresizingMaskIntoConstraints = false
			adsContainerView.mf.addSubview(adsView, andConstraints: [
				adsView.centerX |==| adsContainerView.centerX,
				adsView.top |==| adsContainerView.top
			])
		}
	}
	
	private func modifyOffsetScroll() {
		self.scrollView.subviews.forEach {
			if $0.convert($0.bounds, to: self.view).origin.x == 0 {
				if let tableView = $0.subviews.first(where: { $0 is UITableView }) as? UITableView {
					var bottomOffset = CGPoint.zero
					if tableView.contentOffset.y > self.bundleSponsorViewHeight.constant {
						bottomOffset = CGPoint(x: 0,
											   y: self.containerScrollView.contentSize.height - self.containerScrollView.bounds.size.height)
					} else {
						tableView.contentOffset.y = 0
						bottomOffset = CGPoint(x: 0, y: tableView.contentOffset.y)
						self.onToggleScrollSubject.onNext((self.hasAdsSponsored, false))
					}
					self.containerScrollView.setContentOffset(bottomOffset, animated: false)
				}
			}
		}
	}
    
    private func bindEvents() {
        disposeBag.addDisposables([
            headerView.didTapCloseButton.subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }),
            viewModel.onWillStopGetItem.subscribe(onNext: { [weak self] _ in
                self?.setupUI()
            }),
            viewModel.onDidGetError.subscribe(onNext: { [weak self] _ in
                self?.showMessage(message: R.string.localizable.errorDataNotAvailable())
            })
        ])
    }
    
    private func setupHeader(numberOfItem: Int) {
        if #available(iOS 11.0, *) { } else {
            headerTopConstraint.constant += Constants.DeviceMetric.statusBarHeight
        }
        
        headerView.headerTitle = viewModel.bundle?.title ?? ""
        guard let bundleContent = viewModel.bundle else {
            return
        }
        headerView.pagerControl.numberOfPages = numberOfItem
        headerView.pagerControl.displayCount = Constants.DefaultValue.maxNumberOfDisplayInPager
        requestAds(universalAddress: bundleContent.universalUrl)
    }
    
    private func setupScrollView() {
        scrollViewHeight = Constants.DeviceMetric.screenHeight
            - Constants.DeviceMetric.statusBarHeight
            - headerViewHeight.constant
            - bundleSponsorViewHeight.constant
        
        guard let bundleContent = viewModel.bundle else {
            print("TODO: Please handle universal address here")
            return
        }
        var numberOfItem = 0
        if !bundleContent.items.isEmpty {
            numberOfItem = bundleContent.items.count
            bundleItems = bundleContent.items
        } else {
            itemIds = bundleContent.bundleItemIds
            numberOfItem = itemIds.count
        }
        setupHeader(numberOfItem: numberOfItem)
        loadedControllers = [BaseViewController?](repeating: nil, count: numberOfItem)
        let fullScrollContentWidth = screenWidth * CGFloat(numberOfItem)
        
        scrollView.contentSize = CGSize(width: fullScrollContentWidth, height: scrollViewHeight)
        
        var firstLoadedControllerIndex = bundleContent.selectedItemIndex
        if Constants.DefaultValue.shouldRightToLeft {
            bundleItems = bundleItems.reversed()
            itemIds = itemIds.reversed()
            firstLoadedControllerIndex = Constants.DefaultValue.shouldRightToLeft
                ? (numberOfItem - 1 - bundleContent.selectedItemIndex)
                : bundleContent.selectedItemIndex
            headerView.pagerControl.currentPage = bundleItems.count - 1 // make the starting point from RTL
        }
        
        loadController(atIndex: firstLoadedControllerIndex, isShowComment: isShowComment)
        
        var scrollOffset = fullScrollContentWidth - screenWidth
        if bundleContent.selectedItemIndex > 0 {// scroll to selected index by default
            scrollOffset -= screenWidth * CGFloat(bundleContent.selectedItemIndex)
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollOffset, y: 0), animated: false)
    }
    
    private func createContentControllerWith(feed: Feed) -> BaseViewController {
        let contentPageVC = ContentPageViewController()
        contentPageVC.viewModel = ContentPageViewModel(interactor: Components.contentPageInteractor(),
                                                       videoInterator: Components.videoPlaylistInteractor(),
                                                       socialService: Components.userSocialService)
        contentPageVC.viewModel.pageUrl = feed.universalUrl ?? ""
        contentPageVC.viewModel.contentId = feed.uuid ?? ""
        contentPageVC.viewModel.contentPageType = Common.getContentPageTypeFromFeed(feed: feed)
        contentPageVC.navigator = Navigator(navigationController: navigationController)
        return contentPageVC
    }
    
    private func createContentControllerWith(itemId: String) -> BaseViewController {
        let contentPageVC = ContentPageViewController()
        contentPageVC.shouldAutoPlay = false
        contentPageVC.viewModel = ContentPageViewModel(interactor: Components.contentPageInteractor(),
                                                       videoInterator: Components.videoPlaylistInteractor(),
                                                       socialService: Components.userSocialService)
        contentPageVC.viewModel.contentId = itemId
        contentPageVC.navigator = Navigator(navigationController: navigationController)
        return contentPageVC
    }
    
    private func loadNextControllers() {
        guard !loadedControllers.filter({ $0 != nil }).isEmpty else { return }
        if selectedIndex - 1 >= 0, selectedIndex - 1 < loadedControllers.count,
            loadedControllers[selectedIndex - 1] == nil {
            loadController(atIndex: selectedIndex - 1)
        }
        
        if selectedIndex + 1 < loadedControllers.count, loadedControllers[selectedIndex + 1] == nil {
            loadController(atIndex: selectedIndex + 1)
        }
    }
    
    private func createVideoPlaylistViewController(feed: Feed) -> BaseViewController? {
        guard let playlistId = feed.uuid else { return nil }
        let vc = VideoPlaylistViewController()
        vc.shouldAutoPlay = false
        vc.bindDataFrom(playlistId: playlistId, title: feed.title)
        vc.navigator = Navigator(navigationController: navigationController)
        return vc
    }
    
    private func loadController(atIndex: Int, isShowComment: Bool = false) {
        var controller: BaseViewController? = nil
        if !bundleItems.isEmpty {
            guard atIndex >= 0, atIndex < bundleItems.count else { return }
            let feed = bundleItems[atIndex]
            if feed is Playlist {
                if let vc = createVideoPlaylistViewController(feed: feed) {
                    controller = vc
                }
            } else {
                controller = createContentControllerWith(feed: feed)
                if let contentPageVC = controller as? ContentPageViewController {
                    contentPageVC.isShowComment = isShowComment
                }
            }
        } else {
            guard atIndex >= 0, atIndex < itemIds.count else { return }
            controller = createContentControllerWith(itemId: itemIds[atIndex].entityId)
            if let contentPageVC = controller as? ContentPageViewController {
                contentPageVC.isShowComment = isShowComment
                contentPageVC.viewModel.onDidLoadPlaylistItem.subscribe(onNext: { [weak self] feed in
                    if let vc = self?.createVideoPlaylistViewController(feed: feed) {
                        self?.addViewControllerToScrollView(controller: vc, atIndex: atIndex)
                        if let onToggleScrollSubject = self?.onToggleScrollSubject {
                            vc.listenToggleScroll(toggleSubject: onToggleScrollSubject)
                        }
                    }
                }).disposed(by: contentPageVC.viewModel.disposeBag)
            }
        }
        if let controller = controller {
            addViewControllerToScrollView(controller: controller, atIndex: atIndex)
			controller.listenToggleScroll(toggleSubject: onToggleScrollSubject)
        }
    }
    
    private func addViewControllerToScrollView(controller: BaseViewController, atIndex: Int) {
        addChildViewController(controller)
        scrollView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        let leadingOffset = screenWidth * CGFloat(atIndex + 1)
        scrollView.mf.addConstraints(
            controller.view.top |==| scrollView.top,
            controller.view.width |==| screenWidth,
            controller.view.height |==| scrollView.height,
            controller.view.leading |==| scrollView.leading |-| leadingOffset
        )
        
        loadedControllers[atIndex] = controller
        updateCurrentVC()
    }
    
    private func pauseVideosWhenSwipedOutOfBundle() {
        if let vc = self.currentVC as? ContentPageViewController {
            vc.shouldAutoPlay = false
            vc.pauseVideosWhenSwipedOutOfBundle()
            return
        }
        if let vc = self.currentVC as? VideoPlaylistViewController {
            vc.shouldAutoPlay = false
            vc.pauseVideosWhenSwipedOutOfBundle()
            return
        }
    }
    
    private func updateCurrentVC() {
        guard selectedIndex >= 0 && loadedControllers.count > selectedIndex else { return }
        currentVC = loadedControllers[selectedIndex]
        
        if let vc = currentVC as? VideoPlaylistViewController {
            vc.shouldAutoPlay = true
            vc.updateGifAnimation()
        } else if let vc = currentVC as? ContentPageViewController {
            vc.shouldAutoPlay = true
            vc.updateGifAnimation()
        }
    }
}

extension BundleContentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if self.scrollView == scrollView {
            let nextPageIndex = lround(Double(scrollView.contentOffset.x / screenWidth))
			if selectedIndex == nextPageIndex { return }
            
            pauseVideosWhenSwipedOutOfBundle()
            selectedIndex = nextPageIndex
			headerView.pagerControl.currentPage = selectedIndex
            
			// only load next item when needed (lazy load)
			loadNextControllers()
            updateCurrentVC()
		}
		
		if self.containerScrollView == scrollView {
			onToggleScrollSubject.onNext((self.hasAdsSponsored,
										  bundleSponsorViewHeight.constant <= scrollView.contentOffset.y))
		}
    }
}
