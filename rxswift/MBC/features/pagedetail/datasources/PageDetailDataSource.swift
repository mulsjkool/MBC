//
//  PageDetailDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/23/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift

class PageDetailDataSource: NSObject {
    var selectingMenu = PageMenuEnum.undefine // TO BE UPDATED WITH CACHE DATA IF ANY
    
    var dataReadyForPhotos: (displayingPhotos: Bool, titledAlbum: Bool) = (false, false)
    var dataReadyForStream = false
    var dataReadyForApp = false
    var dataReadyForScheduler = false
    var dataReadyForVideo: (displayingVideo: Bool, titledPlaylist: Bool) = (false, false)
    var dataReadyForBundles = false
    var dataReadyForEpisodes = false
    
    var isMoreDataAvailable: Bool = false
    private var currentSchedulerDay: Int = 0
    weak var delegate: PageDetailDataSourceDelegate?
    
    private let aboutTabDataSource = PageDetailAboutTabDataSource()
    private let photosTabDataSource = PageDetailPhotosTabDataSource()
    private let appTabDataSource = PageDetailAppTabDataSource()
    private let newsFeedTabDataSource = PageDetailNewsFeedTabDataSource()
    private let videoTabDataSource = PageDetailVideoTabDataSource()
    private let schedulerTabDataSource = PageDetailSchedulerTabDataSource()
    private let episodeTabDataSource = PageDetailEpisodeTabDataSource()
    
    private let viewModel: PageDetailViewModel
	
    var landingTab: PageMenuEnum {
        let settings = viewModel.details?.pageSettings
        
        var result = selectingMenu == .undefine ? PageMenuEnum.newsfeed : selectingMenu
        if selectingMenu == .undefine, let selectLandingTab = settings?.selectLandingTab,
            let tab = PageMenuEnum.convertFrom(stringValue: selectLandingTab) {
            result = tab
        }
        
        return result
    }
    
    var isCorrectTab: Bool {
        // Make sure we reload the table when seeing the corresponding tab
        if selectingMenu == .newsfeed && (viewModel.itemsList.list as? [Feed]) == nil {
            return false
        }
        if selectingMenu == .photos && !(dataReadyForPhotos.displayingPhotos && dataReadyForPhotos.titledAlbum) {
            return false
        }
        if selectingMenu == .apps && (viewModel.itemsList.list as? [App]) == nil {
            return false
        }
        if selectingMenu == .videos && !(dataReadyForVideo.displayingVideo && dataReadyForVideo.titledPlaylist) {
            return false
        }
        if selectingMenu == .schedule && (viewModel.itemsList.list as? [SchedulersOnDay]) == nil {
            return false
        }
        if selectingMenu == .episodes && (viewModel.itemsList.list as? [Post]) == nil {
            return false
        }
        return true
    }
    
    var isLoadmoreCell: Bool {
        if selectingMenu == .newsfeed || selectingMenu == .photos ||
            selectingMenu == .apps || selectingMenu == .videos || selectingMenu == .episodes {
            return true
        }
        return false
    }
    
    init(viewModel: PageDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        aboutTabDataSource.delegate = self
        photosTabDataSource.delegate = self
        appTabDataSource.delegate = self
        newsFeedTabDataSource.delegate = self
		newsFeedTabDataSource.universalUrl = viewModel.author?.universalUrl ?? ""
        videoTabDataSource.delegate = self
        schedulerTabDataSource.delegate = self
        episodeTabDataSource.delegate = self
    }
    
    func setItemDataReady() {
        if self.selectingMenu == .photos {
            self.dataReadyForPhotos.displayingPhotos = true
            self.viewModel.albumsList.grandTotal = self.viewModel.itemsList.grandTotal
        } else if self.selectingMenu == .newsfeed {
            self.dataReadyForStream = true
        } else if self.selectingMenu == .apps {
            self.dataReadyForApp = true
        } else if self.selectingMenu == .videos { // Videos
            self.dataReadyForVideo.displayingVideo = true
            self.viewModel.albumsList.grandTotal = self.viewModel.itemsList.grandTotal
        } else if self.selectingMenu == .episodes { // Videos
            self.dataReadyForEpisodes = true
        } else { // scheduler
            self.dataReadyForScheduler = true
        }
    }

    func getAboutTabData() -> [[String: Any]] {
        return aboutTabDataSource.getAboutTabData(infoComponents: viewModel.infoComponents,
                                                  pageAboutTab: viewModel.pageAboutTab)
    }
	
	func resetCachingAds() {
		newsFeedTabDataSource.resetCachingAds()
	}
	
	func bannerAdsHeightCell(at indexPath: IndexPath) -> CGFloat? {
		let itemList = getItemList()
		guard !itemList.list.isEmpty,
			let nsType = itemList.list.count > indexPath.row ? itemList.list[indexPath.row] : nil,
			(nsType as? Feed)?.type == CampaignType.ads.rawValue else { return nil }
		return newsFeedTabDataSource.bannerAdsHeightCell(at: indexPath)
	}
}

extension PageDetailDataSource: PageDetailNewsFeedTabDelegate {
	func reloadCell(at indexPath: IndexPath) {
		delegate?.reloadCell(at: indexPath)
	}
	
    func openInAppBrowser(url: URL) {
        delegate?.openInAppBrowser(url: url)
    }
    
    func showFullscreenImage(_ feed: Feed, pageId: String, imageIndex: Int, imageId: String = "") {
        delegate?.showFullscreenImage(feed, accentColor: viewModel.getAccentColor(), pageId: pageId,
                                      imageIndex: imageIndex, imageId: imageId)
    }
    
    func navigateToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?) {
        delegate?.navigateToContentPage(feed: feed, isShowComment: isShowComment, cell: cell)
    }
    
    func navigateToPageDetail(author: Author) {
        delegate?.navigateToPageDetail(author: author)
    }
    
    func navigateToTaggedPageListing(authors: [Author]) {
        delegate?.navigateToTaggedPageListing(authors: authors)
    }
    
    func navigateToVideoPlaylist(feed: Feed) {
        delegate?.pushVideoPlaylistFrom(feed: feed)
    }
}

extension PageDetailDataSource: PageDetailAboutTabDelegate {
    func navigateToPageDetail(feed: Feed) {
        delegate?.navigateToPageDetail(feed: feed)
    }
}

extension PageDetailDataSource: PageDetailAppTabDelegate {
    
    func pushAppWhitePage(app: App) {
        delegate?.pushAppWhitePage(app: app)
    }
    
    func pushAppToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?) {
        delegate?.navigateToContentPage(feed: feed, isShowComment: isShowComment, cell: cell)
    }
}

extension PageDetailDataSource: PageDetailEpisodeTabDelegate {
    func openShahidEmbedded(url: URL, appStore: String?) {
        delegate?.openShahidEmbedded(url: url, appStore: appStore)
    }
}

extension PageDetailDataSource: PageDetailVideoTabDelegate {
    
    func getPageIndex() -> Int {
        return viewModel.getPageIndex()
    }
    
    func pushVideoPlaylistFrom(customPlaylist: VideoPlaylist) {
        delegate?.pushVideoPlaylistFrom(customPlaylist: customPlaylist)
    }
    
    func pushVideoPlaylistFromDefault(defaultPlaylist: VideoDefaultPlaylist, videoId: String?) {
        delegate?.pushVideoPlaylistFromDefault(defaultPlaylist: defaultPlaylist, videoId: videoId)
    }
    
    func getDataReadyForVideo() -> (displayingVideo: Bool, titledPlaylist: Bool) {
        return dataReadyForVideo
    }
    
    func navigateToContentPage(video: Video, isShowComment: Bool, cell: UITableViewCell?) {
        delegate?.navigateToContentPage(video: video, isShowComment: isShowComment, cell: cell)
    }
}

extension PageDetailDataSource: PageDetailSchedulerTabDelegate {
    func pushToPageDetail(pageUrl: String, pageId: String) {
        delegate?.navigateToPageDetail(pageUrl: pageUrl, pageId: pageId)
    }
    
    func getDataReadyForScheduler() -> Bool {
        return dataReadyForScheduler
    }
    func getCurrentSchedulerDay() -> Int {
        return currentSchedulerDay
    }
    
    func setCurrentSchedulerDay(index: Int) {
        currentSchedulerDay = index
    }
    func reloadCellIn(section: Int) {
        delegate?.reloadCellIn(section: section)
    }
}

extension PageDetailDataSource: PageDetailPhotosTabDelegate {
    
    func showFullScreenImageFromCustomAlbum(customAlbum: PhotoCustomAlbum) {
        delegate?.showFullScreenImageFromCustomAlbum(customAlbum: customAlbum)
    }
    
    func showPopupComment(pageId: String?, contentId: String?, contentType: String) {
        delegate?.showPopupComment(pageId: pageId,
                                   contentId: contentId,
                                   contentType: contentType)
    }
    
    func getAuthor() -> Author {
        return viewModel.author!
    }
    
    func showFullscreenImageDefaultAlbum(defaultAlbum: PhotoDefaultAlbum) {
        delegate?.showFullscreenImageDefaultAlbum(defaultAlbum: defaultAlbum)
    }
    
    func getAlbumList() -> ItemList {
        return viewModel.albumsList
    }
    
    func getDataReadyForPhotos() -> (displayingPhotos: Bool, titledAlbum: Bool) {
        return dataReadyForPhotos
    }
    
}

extension PageDetailDataSource: PageDetailTabDelegate {
    
    func getPageId() -> String {
        return viewModel.pageId
    }
    
    func getItemList() -> ItemList {
        return viewModel.itemsList
    }
    
    func getAccentColor() -> UIColor? {
        return viewModel.getAccentColor()
    }
    
    func reloadCell() {
        delegate?.reloadCell()
    }
    
    func getURLFromObjAndShare(obj: Likable) {
        delegate?.getURLFromObjAndShare(obj: obj)
    }
    
    func getBundles() -> [BundleContent]? {
        return viewModel.pageDetail?.bundles
    }
    
    func getGenreMetadata() -> String? {
        guard let pageDetail = viewModel.pageDetail, let genres = pageDetail.genres else { return nil }
        return genres.joined(separator: Constants.DefaultValue.InforTabMetadataGenreSeparatorString)
    }
    
    func getSeasonMetadata() -> String? {
        return viewModel.pageDetail?.seasonNumber
    }
    
    func streamInfoComponent() -> InfoComponent? {
        guard let infoComponents = viewModel.infoComponents else { return nil }
        return infoComponents.first(where: { $0.showDataOnStream })
    }
    
    func getLanguageConfigList() -> [LanguageConfigListEntity]? {
        return viewModel.pageDetail?.languageConfigList
    }
}

extension PageDetailDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectingMenu == .photos || selectingMenu == .apps || selectingMenu == .videos
            || selectingMenu == .newsfeed || selectingMenu == .schedule || selectingMenu == .episodes { return 2 }
        
        if selectingMenu == .about { return 1 }

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectingMenu {
        case .about:
            return numberOfSectionAboutCell(section: section)
        case .apps:
            return numberOfRowsForApps(forSection: section)
        case .newsfeed:
            return numberOfRowsForNewsFeed(forSection: section)
        case .photos, .videos:
            return numberOfRowsForPhotoOrVideo(forSection: section)
        case .schedule:
            return numberOfRowsForScheduler(forSection: section)
        case .episodes:
            return numberOfRowsForEpisodes(forSection: section)
        default:
            return 0
        }
    }
    
    private func numberOfSectionAboutCell(section: Int) -> Int {
        return aboutTabDataSource.getAboutTabData(infoComponents: viewModel.infoComponents,
                                                  pageAboutTab: viewModel.pageAboutTab).count
    }
    
    private var numberOfRowsFromList: Int {
        let itemsCount = viewModel.itemsList.list.count
        if isMoreDataAvailable && itemsCount > 0 { return itemsCount + 1 }
        
        return itemsCount
    }
    
    private func numberOfRowsForNewsFeed(forSection: Int) -> Int {
        if forSection == PageDetailNewsFeedTabSection.bundles.rawValue { return dataReadyForBundles ? 1 : 0 }
        if forSection == PageDetailNewsFeedTabSection.newsFeed.rawValue && !dataReadyForStream { return 2 }
        
        /// should show Info component?
        var shouldShowInfoComponent = false
        if let infoComponents = viewModel.infoComponents {
            shouldShowInfoComponent = !infoComponents.filter({ $0.showDataOnStream }).isEmpty
        }
        
        return shouldShowInfoComponent ? (numberOfRowsFromList + 1) : numberOfRowsFromList
    }
    
    private func numberOfRowsForApps(forSection: Int) -> Int {
        if forSection == 0 { return 1 }
        if !dataReadyForApp { return 2 }
        return numberOfRowsFromList
    }
    
    private func numberOfRowsForPhotoOrVideo(forSection: Int) -> Int {
        if forSection == 0 { return 1 }
        if Constants.Singleton.isiPad {
            return 1
        }
        return numberOfRowsFromList
    }
    
    private func numberOfRowsForScheduler(forSection: Int) -> Int {
        if forSection == 0 {
            if !dataReadyForScheduler { return 1 }
            return viewModel.itemsList.list.isEmpty ? 0 : 1
        }
        
        if !dataReadyForScheduler { return 2 }
        
        if !viewModel.itemsList.list.isEmpty, viewModel.itemsList.list.count > currentSchedulerDay,
            let list = (viewModel.itemsList.list[currentSchedulerDay] as? SchedulersOnDay)?.list {
            return list.count
        }
        
        return 0
    }
    
    private func numberOfRowsForEpisodes(forSection: Int) -> Int {
        if forSection == 0 { return 1 }
        if !dataReadyForEpisodes { return 2 }
        return numberOfRowsFromList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectingMenu {
        case .about:
            return cellForAboutFor(tableView: tableView, indexPath: indexPath)
        case .apps:
            return cellForAppsFor(tableView: tableView, indexPath: indexPath)
        case .newsfeed:
            return cellForNewsFeedFor(tableView: tableView, indexPath: indexPath)
        case .photos:
            return cellForPhotoFor(tableView: tableView, indexPath: indexPath)
        case .schedule:
            return cellForScheduleFor(tableView: tableView, indexPath: indexPath)
        case .videos:
            return cellForVideoFor(tableView: tableView, indexPath: indexPath)
        case .episodes:
            return cellForEpisodesFor(tableView: tableView, indexPath: indexPath)
        default:
            return Common.createDummyCellWith(title: "Cell for a not supported item")
        }
    }
    
    private func cellForVideoFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == viewModel.itemsList.count {
            return videoTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
        }
        
        if let cell = createLoadmoreCell(indexPath) { return cell }
        return videoTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func cellForScheduleFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if !dataReadyForScheduler { return Common.createLoadingPlaceHolderCell() }
        if let cell = createLoadmoreCell(indexPath) { return cell }
        return schedulerTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func cellForAppsFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if !dataReadyForApp { return Common.createLoadingPlaceHolderCell() }
        if let cell = createLoadmoreCell(indexPath) { return cell }
        return appTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func cellForNewsFeedFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if !dataReadyForStream && indexPath.section == PageDetailNewsFeedTabSection.newsFeed.rawValue {
            return Common.createLoadingPlaceHolderCell()
        }
        if let cell = createLoadmoreCell(indexPath) { return cell }
        return newsFeedTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func cellForPhotoFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == viewModel.itemsList.count {
            return photosTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
        }
        if let cell = createLoadmoreCell(indexPath) { return cell }
        return photosTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func cellForAboutFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return aboutTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func cellForEpisodesFor(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if !dataReadyForEpisodes { return Common.createLoadingPlaceHolderCell() }
        if let cell = createLoadmoreCell(indexPath) { return cell }
        return episodeTabDataSource.cellForIndexPath(tableView: tableView, indexPath: indexPath)
    }
    
    private func createLoadmoreCell(_ indexPath: IndexPath) -> UITableViewCell? {
        if viewModel.itemsList.list.isEmpty ||
            indexPath.row < viewModel.itemsList.count ||
            !isMoreDataAvailable { return nil }
        
        guard isLoadmoreCell else { return nil }
        
        if isLoadmoreCell {
            viewModel.loadItems(forPageMenu: selectingMenu)
        }
        return Common.createLoadMoreCell()
    }
}
