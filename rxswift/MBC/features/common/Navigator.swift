//
//  Navigator.swift
//  MBC
//
//  Created by Tuyen Nguyen Thanh on 10/3/16.
//  Copyright © 2016 MBC. All rights reserved.
//

import UIKit

class Navigator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func pushUserProfile() {
        let vc = UserProfileViewController(nibName: R.nib.userProfileViewController.name, bundle: nil)
        vc.navigator = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushStarPageListing() {
        guard let vc = R.storyboard.app.listingViewController() else {
            return
        }
        vc.listingType = .star
        vc.navigator = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func pushAppsAndGames() {
        guard let vc = R.storyboard.app.listingViewController() else {
            return
        }
        vc.listingType = .appAndGame
        vc.navigator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPageDetail(pageUrl: String, pageId: String) {
        guard let pageDetailVC = R.storyboard.pageDetail.pageDetailViewController() else {
            return
        }
        pageDetailVC.navigator = self
        pageDetailVC.pageUrl = pageUrl
        pageDetailVC.pageId = pageId
        navigationController?.pushViewController(pageDetailVC, animated: true)
    }
    
    func pushArticle(article: Article, isShowComment: Bool = false) {
        pushContentPage(pageUrl: article.universalUrl, contentId: article.contentId, contentPageType: .article,
                        currentVideoTime: 0, isShowComment: isShowComment)
    }
    
    func presentBundle(_ bundle: BundleContent, isShowComment: Bool = false) {
        let vc = BundleContentViewController(nibName: R.nib.bundleContentViewController.name, bundle: nil)
        vc.viewModel = BundleContentViewModel(interactor: Components.contentPageInteractor())
        vc.viewModel.bundle = bundle
        vc.viewModel.pageUrl = bundle.universalUrl ?? ""
        vc.isShowComment = isShowComment
        let navController = MainNavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func presentBundleWith(universal: String, contentId: String) {
        let vc = BundleContentViewController(nibName: R.nib.bundleContentViewController.name, bundle: nil)
        vc.viewModel = BundleContentViewModel(interactor: Components.contentPageInteractor())
        vc.viewModel.pageUrl = universal
        vc.viewModel.contentId = contentId
        let navController = MainNavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    private func pushContentPage(pageUrl: String?, contentId: String?, contentPageType: ContentPageType,
                                 currentVideoTime: Double = 0, isShowComment: Bool = false) {
        let contentPageVC = ContentPageViewController()
        contentPageVC.navigator = self
        contentPageVC.viewModel = ContentPageViewModel(interactor: Components.contentPageInteractor(),
                                                       videoInterator: Components.videoPlaylistInteractor(),
                                                       socialService: Components.userSocialService)
        contentPageVC.viewModel.pageUrl = pageUrl
        contentPageVC.viewModel.contentId = contentId
        contentPageVC.viewModel.contentPageType = contentPageType
        contentPageVC.viewModel.currentVideoTime = currentVideoTime
        contentPageVC.isShowComment = isShowComment
        contentPageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contentPageVC, animated: true)
    }
    
    private func getPushedContentPage(pageUrl: String?, contentId: String?, pageId: String? = nil,
                                      contentPageType: ContentPageType, currentVideoTime: Double = 0,
                                 isShowComment: Bool = false)
        -> ContentPageViewController {
        let contentPageVC = ContentPageViewController()
        contentPageVC.navigator = self
        contentPageVC.viewModel = ContentPageViewModel(interactor: Components.contentPageInteractor(),
                                                       videoInterator: Components.videoPlaylistInteractor(),
                                                       socialService: Components.userSocialService)
        contentPageVC.viewModel.pageUrl = pageUrl
        contentPageVC.viewModel.contentId = contentId
        contentPageVC.viewModel.pageId = pageId
        contentPageVC.viewModel.contentPageType = contentPageType
        contentPageVC.viewModel.currentVideoTime = currentVideoTime
        contentPageVC.isShowComment = isShowComment
        contentPageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contentPageVC, animated: true)
        return contentPageVC
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func navigateToContentPage(feed: Feed, isShowComment: Bool = false, cell: UITableViewCell? = nil) {
        if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType) {
            switch type {
            case .text:
                pushPostText(post: post, isShowComment: isShowComment)
            case .image:
                pushPostImage(post: post, isShowComment: isShowComment)
            case .video:
                if let video = post.medias?.first as? Video {
                    let contentPageVC = pushVideo(post: post, currentVideoTime: video.currentTime.value,
                                                  isShowComment: isShowComment)
                    contentPageVC.didBackFromVideoContentPage.subscribe(onNext: { aVideo in
                        if let aVideo = aVideo {
                            if let videoCell = cell as? PostCardMultiImagesTableViewCell {
                                videoCell.playVideo(true, currentTime: aVideo.currentTime.value)
                            } else if let relatedContentCell = cell as? RelatedContentCell {
                                relatedContentCell.playVideo(currentTime: aVideo.currentTime.value)
                            }
                        }
                    }).disposed(by: contentPageVC.disposeBag)
                } else {
                    _ = pushVideo(post: post, currentVideoTime: 0, isShowComment: isShowComment)
                }
            case .embed:
                pushEmbed(post: post, isShowComment: isShowComment)
            case .episode:
                pushEpisode(post: post, isShowComment: isShowComment)
            }
        }
        if let article = feed as? Article {
            pushArticle(article: article, isShowComment: isShowComment)
        }
        if let app = feed as? App {
            pushApp(app: app, isShowComment: isShowComment)
        }
        if feed is Page {
            navigateToPageDetail(feed: feed)
        }
        if feed is BundleContent {
            if feed is Playlist {
                pushVideoPlaylistFrom(feed: feed)
                return
            }
            // swiftlint:disable:next force_cast
            presentBundle(feed as! BundleContent, isShowComment: isShowComment)
        }
    }
    
    func navigateToContentPage(video: Video, isShowComment: Bool = false, cell: UITableViewCell? = nil) {
        if let videoCell = cell as? PhotoPostTableViewCell {
            let contentPageVC = pushVideo(video: video, currentVideoTime: video.currentTime.value,
                                          isShowComment: isShowComment)
            contentPageVC.didBackFromVideoContentPage.subscribe(onNext: { aVideo in
                if let aVideo = aVideo {
                    videoCell.seekTo(time: aVideo.currentTime.value)
                }
            }).disposed(by: contentPageVC.disposeBag)
        }
    }
    
    func navigateToPageDetail(feed: Feed) {
        if let universalUrl = feed.author?.universalUrl, !universalUrl.isEmpty {
			pushPageDetail(pageUrl: universalUrl, pageId: feed.author?.authorId ?? ""); return
        }
        pushPageDetail(pageUrl: feed.universalUrl ?? "", pageId: feed.uuid ?? "")
    }
    
    func pushPostText(post: Post, isShowComment: Bool = false) {
        pushContentPage(pageUrl: post.universalUrl, contentId: post.contentId, contentPageType: .postText,
                        currentVideoTime: 0, isShowComment: isShowComment)
    }
    
    func pushPostImage(post: Post, isShowComment: Bool = false) {
		pushContentPage(pageUrl: post.universalUrl, contentId: post.contentId,
						contentPageType: .postImage, isShowComment: isShowComment )
    }
    
    func pushApp(app: App, isShowComment: Bool = false) {
        pushContentPage(pageUrl: app.universalUrl, contentId: app.contentId, contentPageType: .app,
                        currentVideoTime: 0, isShowComment: isShowComment)
    }
    
    func pushContentPage(universalUrl: String, contentPageType: ContentPageType, contentId: String) {
        pushContentPage(pageUrl: universalUrl, contentId: nil, contentPageType: contentPageType,
                        currentVideoTime: 0, isShowComment: false)
    }
    
    func pushAppWhitePage(app: App) {
        guard let appWhitePageVC = R.storyboard.app.appWhitePageViewController() else {
            return
        }
        appWhitePageVC.navigator = self
        appWhitePageVC.viewModel = AppWhitePageViewModel(interactor: Components.appWhitePageInteractor())
        appWhitePageVC.viewModel.pageUrl = app.universalUrl
		appWhitePageVC.viewModel.contentId = app.contentId
        appWhitePageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(appWhitePageVC, animated: true)
    }
    
    func pushAppWhitePage(universalURL: String, contentId: String) {
        guard let appWhitePageVC = R.storyboard.app.appWhitePageViewController() else { return }
        appWhitePageVC.navigator = self
        appWhitePageVC.viewModel = AppWhitePageViewModel(interactor: Components.appWhitePageInteractor())
        appWhitePageVC.viewModel.pageUrl = universalURL
        appWhitePageVC.viewModel.contentId = contentId
        navigationController?.pushViewController(appWhitePageVC, animated: true)
    }
    
    func pushVideoPlaylistFrom(customPlaylist: VideoPlaylist) {
        let videPlaylistViewController = VideoPlaylistViewController()
        videPlaylistViewController.bindDataFrom(customPlaylist: customPlaylist)
        videPlaylistViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videPlaylistViewController, animated: true)
    }
    
    func pushVideoPlaylistFrom(playlistId: String, title: String?) {
        let videPlaylistViewController = VideoPlaylistViewController()
        videPlaylistViewController.bindDataFrom(playlistId: playlistId, title: title)
        videPlaylistViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videPlaylistViewController, animated: true)
    }
    
    func pushVideoPlaylistFromDefault(defaultPlaylist: VideoDefaultPlaylist, videoId: String? = nil) {
        let videPlaylistViewController = VideoPlaylistViewController()
        videPlaylistViewController.bindDefaultPlaylistFrom(defaultPlaylist: defaultPlaylist, videoId: videoId)
        videPlaylistViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videPlaylistViewController, animated: true)
    }
    
    func pushVideoPlaylistFrom(videos: [Video], videoIndex: Int, videoId: String? = nil) {
        let videPlaylistViewController = VideoPlaylistViewController()
        videPlaylistViewController.bindDataFrom(videos: videos, videoIndex: videoIndex, videoId: videoId)
        videPlaylistViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videPlaylistViewController, animated: true)
    }
    
    func pushVideoPlaylistFrom(feed: Feed) {
        let videPlaylistViewController = VideoPlaylistViewController()
        videPlaylistViewController.bindDataFrom(feed: feed)
        videPlaylistViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videPlaylistViewController, animated: true)
    }
    
    func pushVideoPlaylistFrom(pageId: String, contentId: String, videoId: String? = nil) {
        let videPlaylistViewController = VideoPlaylistViewController()
        videPlaylistViewController.bindDataFrom(pageId: pageId, contentId: contentId, videoId: videoId)
        videPlaylistViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(videPlaylistViewController, animated: true)
    }

    func pushContentPageWithUniversalLink(_ universalLink: String) {
        let vc = ContentPageViewController(nibName: R.nib.contentPageViewController.name, bundle: nil)
        vc.navigator = self
        vc.viewModel = ContentPageViewModel(interactor: Components.contentPageInteractor(),
                                            videoInterator: Components.videoPlaylistInteractor(),
                                            socialService: Components.userSocialService)
        vc.viewModel.pageUrl = universalLink
        vc.isShowComment = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushVideo(post: Post, currentVideoTime: Double, isShowComment: Bool = false) -> ContentPageViewController {
        return getPushedContentPage(pageUrl: post.universalUrl, contentId: post.contentId,
                                    pageId: post.author?.authorId, contentPageType: .postVideo,
                                    currentVideoTime: currentVideoTime, isShowComment: isShowComment)
    }
    
    func pushVideo(video: Video, currentVideoTime: Double, isShowComment: Bool = false) -> ContentPageViewController {
        return getPushedContentPage(pageUrl: video.universalUrl, contentId: video.contentId,
                                    pageId: video.author?.authorId, contentPageType: .postVideo,
                                    currentVideoTime: currentVideoTime, isShowComment: isShowComment)
    }
    
    func pushEmbed(post: Post, isShowComment: Bool = false) {
        pushContentPage(pageUrl: post.universalUrl, contentId: post.contentId, contentPageType: .postEmbed,
                        currentVideoTime: 0, isShowComment: isShowComment)
    }
    
    func pushEpisode(post: Post, isShowComment: Bool = false) {
        pushContentPage(pageUrl: post.universalUrl, contentId: post.contentId, contentPageType: .postEpisode,
                        currentVideoTime: 0, isShowComment: isShowComment)
    }
    
    func presentFullscreenImage(feed: Feed, pageId: String = "", imageIndex: Int = 0,
                                viewController: UIViewController, accentColor: UIColor?) {
        let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.bindData(feed, imageIndex: imageIndex, accentColor: accentColor)
        viewController.present(fullScreenImagePost, animated: true)
    }
    
    func presentFullscreenImage(universallink: String, viewController: UIViewController) {
        let fullScreenImagePost = FullScreenImagePostViewController.initFromStoryboard()
        fullScreenImagePost.bindData(universalLink: universallink)
        viewController.present(fullScreenImagePost, animated: true)
    }
    
    func pushStaticPageInApp(url: URL, title: String) {
        guard let inAppBrowserVC = R.storyboard.main.inAppBrowserViewController() else { return }
        inAppBrowserVC.url = url
        inAppBrowserVC.title = title
        inAppBrowserVC.didLoadStaticPage = true
        inAppBrowserVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(inAppBrowserVC, animated: true)
    }
    
    func pushSpecificChannelSchedule(schedulerOnChannel: SchedulerOnChannel, daySelectedIndex: Int) {
        let specificChannelSchedule: SpecificChannelScheduleViewController = SpecificChannelScheduleViewController()
        specificChannelSchedule.bindData(schedulerOnChannel: schedulerOnChannel, daySelectedIndex: daySelectedIndex)
        navigationController?.pushViewController(specificChannelSchedule, animated: true)
    }
    
    func openSearchResult(keyword: String, type: SearchItemEnum) {
        let searchResultVC = SearchResultViewController()
        searchResultVC.keyword = keyword
        navigationController?.pushViewController(searchResultVC, animated: false)
    }
    
    func pushChannelListing() {
        let vc = ChannelListingViewController(nibName: R.nib.channelListingViewController.name, bundle: nil)
        vc.navigator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushShowListing() {
        guard let vc = R.storyboard.app.listingViewController() else {
            return
        }
        vc.listingType = .showAndProgram
        vc.navigator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAirTimeList(viewModel: PageDetailViewModel) {
        let vc: AirTimeListViewController = AirTimeListViewController()
        let navi = MainNavigationController(rootViewController: vc)
        vc.viewModel = viewModel
        vc.navigator = self
        navigationController?.present(navi, animated: true, completion: nil)
    }
    
    func presentTaggedPageListing(authorList: [Author]) {
        let vc = TaggedPageListingViewController()
        vc.authorList = authorList
        let navi = MainNavigationController(rootViewController: vc)
        vc.navigator = Navigator(navigationController: navi)
        navigationController?.present(navi, animated: true, completion: nil)
    }
    
    func pushFormViewController(type: StaticPageEnum) {
        let vc = FormViewController(nibName: R.nib.formViewController.name, bundle: nil)
        vc.formType = type
        navigationController?.pushViewController(vc, animated: true)
    }
}
