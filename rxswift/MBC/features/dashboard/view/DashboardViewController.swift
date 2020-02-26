//
//  DashboardViewController.swift
//  MBC
//
//  Created by Dao Le Quang on 11/8/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import MisterFusion
import SideMenu

class DashboardViewController: BaseViewController {
    
    static let indexMenuTab = 4

    var tabbarController: BaseTabBarController!
    private var selectedTab: Int?
    private var previousSelectedTab: Int?
    private var searchBarContainer: SearchBarContainerView!
    private var searchBar: BaseSearchBar = BaseSearchBar()
    private let viewModel: DashboardViewModel = {
        return DashboardViewModel(autheticationService: Components.authenticationService,
                                  appUpgradeVersionService: Components.upgradeVersionService)
    }()
    
    private var tableViewController: SearchSuggestionTableViewController?
    
    deinit {
        defaultNotification.removeObserver(self, name: Keys.Notification.navigateUniversalLink, object: nil)
        defaultNotification.removeObserver(self, name: Keys.Notification.openTabVideos, object: nil)
        defaultNotification.removeObserver(self, name: Keys.Notification.openTabAppsAndGames, object: nil)
        defaultNotification.removeObserver(self, name: Keys.Notification.openStarPageListingVC, object: nil)
        defaultNotification.removeObserver(self, name: Keys.Notification.openTabStream, object: nil)
        defaultNotification.removeObserver(self, name: Keys.Notification.openTabScheduler, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindEvents()
        setupUI()
        checkAppUpgradeVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.tableViewController != nil {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func viewDidLayoutSubviews() {
        searchBar.sizeToFit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.dashboardViewController.segueDashboardEmbeddedTabbar.identifier {
            if let viewController = segue.destination as? BaseTabBarController {
                tabbarController = viewController
                tabbarController.delegate = self
            }
        }
    }

    func openTabAtIndex(tabIndex: Int) {
        tabbarController.selectedIndex = tabIndex
        showHideNavigationBar(selectedIndex: tabIndex)
    }

    @objc
    func openStarPageListingVC() {
        self.navigator?.pushStarPageListing()
    }
    
    // MARK: Private functions
    fileprivate func toggleMenuForiPad() {
        guard let sideMeneController = Constants.Singleton.sideMenuController else { return }
        present(sideMeneController, animated: true, completion: nil)
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartToGetAppVersion.subscribe(onNext: {}),
            viewModel.onWillStopToGetAppVersion.subscribe(onNext: {}),
            viewModel.onDidGetAppVersion.subscribe(onNext: { data in
                self.checkAppVersion(data: data)
            }),
            viewModel.onForceToSignout.subscribe(onNext: { _ in
                Constants.Singleton.appDelegate.openLoginScreen()
            })
        ])
    }
    
    private func setupUI() {
        addSearchBar()
        addNotificationCenter()
        setupSideMenu()
        previousSelectedTab = 0
    }
    
    private func setupSideMenu() {
        guard Constants.Singleton.isiPad,
            let sideMenuController = R.storyboard.main.sideMenuController() else { return }
        sideMenuController.dashboardController = self
        sideMenuController.addMenuBackButton()
        Constants.Singleton.sideMenuController = UISideMenuNavigationController(rootViewController: sideMenuController)
    }
    
    private func checkAppUpgradeVersion() {
        viewModel.errorDecorator = self
        viewModel.startGetAppVersion()
    }
    
    private func showHideNavigationBar(selectedIndex: Int) {
        guard let selectedIndex = TabBarType(rawValue: selectedIndex) else { return }
        
        switch selectedIndex {
        case .stream, .showListing, .videos, .schedule:
            showHideNavigationBar(shouldHide: false, animated: false)
            searchBarContainer.show()
        case .menu:
            showHideNavigationBar(shouldHide: true, animated: false)
            searchBarContainer.hide()
            /*
        default:
            title = "" // TO BE UPDATED
            showHideNavigationBar(shouldHide: false, animated: false)
            searchBarContainer.hide()
        */
        }
    }
	
	private func addNotificationCenter() {
        defaultNotification.addObserver(self, selector: #selector(DashboardViewController.openPreviousTab),
                                        name: Keys.Notification.openPreviousTab, object: nil)
		defaultNotification.addObserver(self, selector: #selector(DashboardViewController.openTab(notification:)),
										name: Keys.Notification.openTabAppsAndGames, object: nil)
		defaultNotification.addObserver(self, selector: #selector(DashboardViewController.openTab(notification:)),
										name: Keys.Notification.openTabVideos, object: nil)
        defaultNotification.addObserver(self, selector: #selector(DashboardViewController.openTab(notification:)),
                                        name: Keys.Notification.openTabStream, object: nil)
        defaultNotification.addObserver(self, selector: #selector(DashboardViewController.openTab(notification:)),
                                        name: Keys.Notification.openTabScheduler, object: nil)
		defaultNotification.addObserver(self, selector: #selector(DashboardViewController.navigateUniversalLink(_:)),
										name: Keys.Notification.navigateUniversalLink, object: nil)
        defaultNotification.addObserver(self, selector: #selector(DashboardViewController.openStarPageListingVC),
                                        name: Keys.Notification.openStarPageListingVC, object: nil)
	}
    private func checkAppVersion(data: AppVersion) {
        showAppUpgradeVersionMessage(status: data.status, message: data.message)
    }
    
    private func showAppUpgradeVersionMessage(status: String, message: String) {
        
        if let versionEnum = AppVersionEnum(rawValue: status) {
            switch versionEnum {
            case .older:
                let appUpgradeViewController = AppUpgradeViewController()
                self.present(appUpgradeViewController, animated: false, completion: {
                    appUpgradeViewController.config(hideSkipButton: true, message: message)
                })
            case .newer:
                let appUpgradeViewController = AppUpgradeViewController()
                self.present(appUpgradeViewController, animated: false, completion: {
                    appUpgradeViewController.config(hideSkipButton: false, message: message)
                })
            case .lastest, .nonSupport: break
            }
        }
    }
	
    // MARK: Search
    
    private func addSearchBar() {
		searchBarContainer = Common.setupSearchBar(searchBar: searchBar, navigationItem: navigationItem)
        
        disposeBag.addDisposables([
            searchBarContainer.onShouldBeginSearching.subscribe(onNext: { [unowned self] _ in
                self.searchBar.placeholder = R.string.localizable.commonSearchBarSearchModePlaceholder().localized()
                self.addSearchSuggestionTableView()
            }),
            
            searchBarContainer.onShouldEndSearching.subscribe(onNext: { [unowned self] _ in
                self.searchBar.placeholder = R.string.localizable.commonSearchBarPlaceholder().localized()
            }),
            
            searchBarContainer.onDidCancelSearching.subscribe(onNext: { [unowned self] _ in
                self.cancelSearching()
            }),
            
            searchBarContainer.onTextDidChangeSearching
                .throttle(Constants.DefaultValue.inputSearchTextIntevalTime,
                          latest: true, scheduler: MainScheduler.instance)
                .subscribe(onNext: { text in
                    print(text)
                    guard let tableVC = self.tableViewController else { return }
                    tableVC.getGetSearchSuggestion(searchText: text)
            }),
            
            searchBarContainer.onSearchButtonClicked.subscribe(onNext: { [unowned self] text in
                print(text ?? "")
				self.openSearchResult(keyword: text ?? "")
            })
        ])
    }
	
    private func addSearchSuggestionTableView() {
        if self.tableViewController != nil { return }
        
        self.tableViewController = SearchSuggestionTableViewController()
        guard let tableVC = self.tableViewController else { return }
        addChildViewController(tableVC)
        self.view.addSubview(tableVC.tableView)
        tableVC.didMove(toParentViewController: self)
        tableVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.mf.addConstraints(
            tableVC.tableView.top |==| self.view.top,
            tableVC.tableView.left |==| self.view.left,
            tableVC.tableView.right |==| self.view.right,
            tableVC.tableView.bottom |==| self.view.bottom
        )
        
        disposeBag.addDisposables([
            tableVC.onCellClicked.subscribe(onNext: { [unowned self] item in
                self.openScreenFromSearchSuggestion(obj: item)
            }),
            tableVC.onFooterCellClicked.subscribe(onNext: { [unowned self] searchText in
                print(searchText)
                self.openSearchResult(keyword: searchText)
            }),
            tableVC.onDeleteHistoriesClicked.subscribe(onNext: { [unowned self] _ in
                self.showMessage(message: R.string.localizable.commonComingSoon())
            }),
            tableVC.onShowHistoriesClicked.subscribe(onNext: { [unowned self] _ in
                self.showMessage(message: R.string.localizable.commonComingSoon())
            })
        ])
    }
    
    private func removeSearchSuggestionTableview() {
        guard let tableVC = self.tableViewController else { return }
        tableVC.tableView.removeFromSuperview()
        tableVC.removeFromParentViewController()
        self.tableViewController = nil
    }
	
	private func cancelSearching() {
		searchBar.placeholder = R.string.localizable.commonSearchBarPlaceholder().localized()
		removeSearchSuggestionTableview()
	}
	
	private func openSearchResult(keyword: String) {
		guard let viewController = tabbarController.viewControllers?.first else { return }
		let searchResultVC = SearchResultViewController()
		searchResultVC.keyword = keyword
		disposeBag.addDisposables([
			searchResultVC.onClearButtonClicked.subscribe(onNext: { [unowned self] _ in
				self.searchBar.text = ""
			}),
			searchResultVC.onDidCancelSearching.subscribe(onNext: { [unowned self] _ in
				self.searchBar.text = ""
				self.cancelSearching()
			})
		])
		viewController.navigationController?.pushViewController(searchResultVC, animated: false)
	}
	
    private func openScreenFromSearchSuggestion(obj: SearchSuggestion) {
        guard let contentType = obj.contentType else { return }

        switch contentType {
        case .app:
            navigator?.pushAppWhitePage(universalURL: obj.universalUrl ?? "", contentId: obj.contentId)
        case .page, .profileStar, .profileGuest, .profileTalent, .profileSportPlayer, .profileSportTeam, .profileBand,
             .postShowNews, .postShowPlay, .postShowMatch, .postShowSeries, .postShowVideo, .postShowProgram,
             .channelTV, .channelRadio:
            navigator?.pushPageDetail(pageUrl: obj.universalUrl ?? "", pageId: obj.contentId)
        case .postImageMultiple, .postImageMultipleTitle, .postImageSingle, .postImageMultipleWithOutTitle:
            navigator?.presentFullscreenImage(universallink: obj.universalUrl ?? "", viewController: self)
        case .postVideo, .playlist:
            self.navigator?.pushVideoPlaylistFrom(playlistId: obj.contentId, title: obj.title)
        case .postEmbed, .postText, .article, .postEpisode:
            let type: ContentPageType = getContentPageType(contentType: contentType)
            
            self.navigator?.pushContentPage(universalUrl: obj.universalUrl ?? "", contentPageType: type,
                                            contentId: obj.contentId)
        case .bundle:
            self.navigator?.presentBundleWith(universal: obj.universalUrl ?? "", contentId: obj.contentId)
        }
    }
    
    private func getContentPageType(contentType: SearchSuggestionContentType) -> ContentPageType {
        var type: ContentPageType = .postText
        if contentType == .postEmbed {
            type = .postEmbed
        } else if contentType == .postText {
            type = .postText
        } else if contentType == .article {
            type = .article
        } else if contentType == .postEpisode {
            type = .postEpisode
        }
        return type
    }
    
    // MARK: Universal link
    
    @objc
    func navigateUniversalLink(_ sender: Notification) {
        guard let path = sender.object as? String else { return }
        NSLog("SENDER = \(path)")
        openScreenFromUniversalURL(strURL: path)
    }
    
    private func openScreenFromUniversalURL(strURL: String) {
        let strTemp1 = DashboardViewController.getPathFromURLString(strURL: strURL)
        let strtemp2 = DashboardViewController.getUniversalLinkTypeFromPath(path: strTemp1)
        print(strTemp1 + "\n" + strtemp2.rawValue)
        switch strtemp2 {
        case .homeStream:
            Constants.Singleton.appDelegate.openHomeScreen()
        case .apps:
            self.navigator?.pushAppWhitePage(universalURL: strTemp1, contentId: "")
        case .pages:
            openPage(pageURL: strTemp1)
        case .profile:
            openUserProfile(pageURL: strTemp1)
        case .sectionName:
            Constants.Singleton.appDelegate.openHomeScreen()
            let dictionary = ["path": strTemp1] as [String: Any]
            self.perform(#selector(DashboardViewController.openSectionVC(_:)), with: dictionary, afterDelay: 0.5)
        case .searchResult:
            openSearchResult(pageURL: strTemp1)
        case .grid:
            break
        case .staticPages:
            openStaticPage(pageURL: strTemp1)
        case .none: break
        }
    }
    
    private func openStaticPage(pageURL: String) {
        guard let item = DashboardViewController.getStaticPageItemFromPath(path: pageURL) else { return }
        
        switch item.type {
        case .aboutsite, .tos, .privacy:
            if let url = URL(string: item.url!) {
                self.navigator?.pushStaticPageInApp(url: url, title: item.name)
            }
        default: break
        }
    }
    
    private func openSearchResult(pageURL: String) {
        let result = DashboardViewController.getSearchResultItemFromPath(path: pageURL)
        if let item = result.item {
            self.navigator?.openSearchResult(keyword: result.keyWord, type: item.type)
        } else {
            self.navigator?.openSearchResult(keyword: result.keyWord, type: .all)
        }
    }
    
    private func openPage(pageURL: String) {
        let type = DashboardViewController.checkPagesFromPagePath(path: pageURL)

        switch type {
        case .radioplayer:
            break
        case .bundles, .bundlesPostMultiImageWithTitle, .bundlesContent:
            self.navigator?.presentBundleWith(universal: pageURL, contentId: "")
        case .playlists:
            break
        case .pageDetail:
            navigator?.pushPageDetail(pageUrl: pageURL, pageId: "")
        case .pageContent:
            navigator?.pushContentPageWithUniversalLink(pageURL)
        case .fullScreenImage:
            navigator?.presentFullscreenImage(universallink: pageURL, viewController: self)
        case .none:
            break
        }
    }
    
    private func openUserProfile(pageURL: String) {
        let name = DashboardViewController.getAccountNameFromPath(path: pageURL)
        guard let account = Components.sessionService.currentUser.value else { return }
        if name == account.name || name == account.email {
            self.navigator?.pushUserProfile()
        }
    }
	
    private static func getPathFromURLString(strURL: String) -> String {
        let str = strURL.replacingOccurrences(of: Components.instance.configurations.websiteBaseURL, with: "")
        return str
    }
    
    private static func getUniversalLinkTypeFromPath(path: String) -> UniversalLinkType {
        if path == Constants.DefaultValue.InforTabMetadataSeparatorString || path.isEmpty { return .homeStream }
        
        var array = path.components(separatedBy: Constants.DefaultValue.InforTabMetadataSeparatorString)
        array.removeFirst()
        if array.isEmpty { return .none }
        let strTemp = array[0]
        guard let type = UniversalLinkType(rawValue: strTemp) else { return .sectionName }
        return type
    }
    
    private static func getStaticPageItemFromPath(path: String) -> StaticPageItem? {
        var array = path.components(separatedBy: Constants.DefaultValue.InforTabMetadataSeparatorString)
        array.removeFirst()
        if array.count < 2 { return nil }
        let strTemp = array[1]
        return StaticPageEnum.allItems.first(where: { $0.name == strTemp })
    }
    
    private static func getSearchResultItemFromPath(path: String) -> (item: SearchMenuItem?, keyWord: String) {
        var array = path.components(separatedBy: Constants.DefaultValue.InforTabMetadataSeparatorString)
        array.removeFirst()
        var keyWord = ""
        if array.count < 2 { return (item: nil, keyWord: keyWord) }
        let strTemp = array[1]
        let item = SearchItemEnum.allItems.first(where: { $0.title == strTemp })
        if item != nil && array.count >= 3 { keyWord = array[2] } else { keyWord = strTemp }
        return (item: item, keyWord: keyWord)
    }
    
    private enum PathLevel: Int {
        case twoPart = 2
        case threePart = 3
        case fourPart = 4
        case fivePart = 5
        case sixPart = 6
        case sevenPart = 7
        case eightPart = 8
        case ninePart = 9
    }
    
    private static func checkPagesFromPagePath(path: String) -> UniversalPageType {
        let array = path.components(separatedBy:
            Constants.DefaultValue.InforTabMetadataSeparatorString).filter { !$0.isEmpty }
        let countNumber = array.count
        
        if countNumber == PathLevel.twoPart.rawValue || countNumber == PathLevel.threePart.rawValue {
            return .pageDetail
        }
        
        if countNumber == PathLevel.fourPart.rawValue {
            if array[2] == UniversalPageType.bundles.rawValue { return .bundles }
            if array[2] == UniversalPageType.radioplayer.rawValue { return .radioplayer }
            return .pageContent
        }
        
        if countNumber == PathLevel.sixPart.rawValue {
            return .bundlesContent
        }
        
        if countNumber == PathLevel.sevenPart.rawValue {
            return .bundlesPostMultiImageWithTitle
        }
        
        if countNumber == PathLevel.eightPart.rawValue {
            return .fullScreenImage
        }
        
        if countNumber == PathLevel.ninePart.rawValue {
            if array[4] == UniversalPageType.playlists.rawValue { return .playlists }
        }
        
        return .none
    }
    
    private static func getSectionNameTypeFromPath(path: String) -> SectionNameType {
        let array = path.components(separatedBy: Constants.DefaultValue.InforTabMetadataSeparatorString)
        if array.count < 2 { return .none }
        let strTemp = array[1]
        guard let type = SectionNameType(rawValue: strTemp) else { return .none }
        return type
    }
    
    @objc
    private static func openSectionVC(_ dictionary: NSDictionary) {
        guard let strSectionPath = dictionary["path"] as? String else { return }
        let type = getSectionNameTypeFromPath(path: strSectionPath)
        //print("\n" + type.rawValue)
        switch type {
        /*case .appsAndGames:
            NotificationCenter.default.post(name: Keys.Notification.openTabAppsAndGames,
                                            object: TabBarType.appsAndGames.rawValue)*/
        case .channels:
            break
        case .stars:
            NotificationCenter.default.post(name: Keys.Notification.openStarPageListingVC, object: nil)
        case .videoStream:
            NotificationCenter.default.post(name: Keys.Notification.openTabVideos, object: TabBarType.videos.rawValue)
        default:
            break
        }
    }
    
    private static func getAccountNameFromPath(path: String) -> String {
        var array = path.components(separatedBy: Constants.DefaultValue.InforTabMetadataSeparatorString)
        array.removeFirst()
        return array[1]
    }
}

extension DashboardViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex != DashboardViewController.indexMenuTab {
            self.previousSelectedTab = tabBarController.selectedIndex
        }
        self.showHideNavigationBar(selectedIndex: tabBarController.selectedIndex)
    }
    
    @objc
    func openTab(notification: Notification) {
        if let index = notification.object as? Int {
            openTabAtIndex(tabIndex: index)
        }
    }
    
    @objc
    func openPreviousTab() {
        if let index = self.previousSelectedTab {
            openTabAtIndex(tabIndex: index)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        guard Constants.Singleton.isiPad, viewController is MainNavigationController,
            viewController.childViewControllers.first is MenuViewController else { return true }
        toggleMenuForiPad()
        return false
    }
}
