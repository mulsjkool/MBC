//
//  ContentPageViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class ContentPageViewModel: BaseViewModel {
    // MARK: variables and properties
    private var interactor: ContentPageInteractor
    private var videoInteractor: VideoPlaylistInteractor
    private let socialService: UserSocialService
    
    private let startLoadContentByUrlOnDemand = PublishSubject<Void>()
    private let startLoadContentByIdOnDemand = PublishSubject<Void>()
    private let startLoadVideoPlaylistDemand = PublishSubject<Void>()
    private let startLoadTaggedPageOnDemand = PublishSubject<Media>()
    private let startLoadCommentsOnDemand = PublishSubject<CommentSocial>()
    private let startLoadRelatedContentsOnDemand = PublishSubject<Void>()
    
    private var url: String!
	private var pageSize = 0
    private var data: CommentSocial? {
        guard let contentId = contentId, let user = interactor.getCurrentUser(), !contentId.isEmpty else { return nil }
		return CommentSocial(userId: user.uid, contentId: contentId, siteName: Constants.DefaultValue.SiteName,
							 fromIndex: 0, size: Constants.DefaultValue.defaultCommentPageSize)
    }
    
    // public
    var pageUrl: String?
    var contentId: String?
    var pageId: String?
    var feed: Feed?
    var comments = [Comment]()
    var videos: [Video]?
    var contentPageType: ContentPageType = .postText
    var currentVideoTime: Double = 0
    private var pageDetail: PageDetail?
    var relatedContents: [Feed]?
    
    // Rx
    var onWillStartGetItem = PublishSubject<Void>()
    var onWillStopGetItem = PublishSubject<Void>()
    var onDidGetError = PublishSubject<Error>()
    
    var onWillStartGetTaggedPages = PublishSubject<Void>()
    var onWillStopGetTaggedPages = PublishSubject<Void>()
    
    var onWillStartGetComments = PublishSubject<Void>()
	var onWillErrorComments = PublishSubject<Void>()
    var onWillStopGetComments = PublishSubject<Bool>()
    
    var onWillStartGetRelatedContents = PublishSubject<Void>()
    var onWillStopGetRelatedContents = PublishSubject<Void>()
    
    var onWillStartGetVideoPlaylist = PublishSubject<Void>()
    var onWillStopGetVideoPlaylist = PublishSubject<Void>()
    
    var onDidLoadPlaylistItem = PublishSubject<Feed>()
    private var likeStatusDisposeBag = DisposeBag()
    
    private var didSendGetRelatedContentsRequest = false
    private var didSendGetVideoPlaylistRequest = false
    
    init(interactor: ContentPageInteractor, videoInterator: VideoPlaylistInteractor, socialService: UserSocialService) {
        self.interactor = interactor
        self.videoInteractor = videoInterator
        self.socialService = socialService
        super.init()
        setUpRx()
    }
    
    func getContent() {
        if let itemId = contentId, !itemId.isEmpty {
            startLoadContentByIdOnDemand.onNext(())
        } else {
            startLoadContentByUrlOnDemand.onNext(())
        }
    }
	
    func getComments() {
        guard var data = self.data else { return }
		data.setFromIndex(getTimeLastComment())
        startLoadCommentsOnDemand.onNext(data)
    }
    
    private func getVideoPlaylist() {
        guard let pageId = self.pageId, !pageId.isEmpty, !didSendGetVideoPlaylistRequest else { return }
        didSendGetVideoPlaylistRequest = true
        startLoadVideoPlaylistDemand.onNext(())
    }
    
    private func getRelatedContents() {
        guard let pageUrl = self.pageUrl, !pageUrl.isEmpty,
            let contentId = self.contentId, !contentId.isEmpty else { return }
        self.startLoadRelatedContentsOnDemand.onNext(())
    }
    
    func getTaggedPages(media: Media) {
        startLoadTaggedPageOnDemand.onNext(media)
    }
    
    func pageAccentColor() -> UIColor {
        var accentColor = pageDetail?.pageSettings.accentColor
        if accentColor == nil {
            accentColor = feed?.author?.accentColor
        }
        return (accentColor != nil) ? UIColor(rgba: accentColor!) : Colors.defaultAccentColor.color()
    }
    
    func addComment(comment: Comment) {
        self.comments.insert(comment, at: 0)
    }
    
    func removeComment(at index: Int) {
        self.comments.remove(at: index)
    }
    
    func index(comment: Comment) -> Int? {
        return self.comments.index(where: { $0.commentId == comment.commentId })
    }
	
	func getTimeLastComment() -> Double {
		if self.comments.isEmpty { return 0 }
		return self.comments.last?.publishedDate?.milliseconds ?? 0
	}
    
    // MARK: Private functions
    
    private func setUpRx() {
        setUpRxForGetItem()
        setUpRxGetTaggedPages()
        setUpRxGetComments()
        setUpRxForGetRelatedContents()
        setUpRXGetVideoPlaylist()
    }
    
    private func setUpRXGetVideoPlaylist() {
        startLoadVideoPlaylistDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetVideoPlaylist.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<ItemList> in
                guard let pageId = self.pageId else { return Observable.empty() }
                return self.videoInteractor.getDetailOfPlayListFrom(pageId: pageId, contentId: self.contentId,
                                                                    playlistId: nil)
                    .catchError { _ -> Observable<ItemList> in
                        self.onWillStopGetVideoPlaylist.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] itemlist in
                let videosList = itemlist.list.filter { $0 is Video }
                // swiftlint:disable:next force_cast
                self.videos = videosList.map { $0 as! Video }
            })
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetVideoPlaylist.onNext(())
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
    
    private func setUpRxGetTaggedPages() {
        startLoadTaggedPageOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetTaggedPages.onNext(())
            })
            .flatMap { [unowned self] media -> Observable<Media> in
                return self.interactor.getTaggedPagesFor(media: media)
                    .catchError { _ -> Observable<Media> in
                        self.onWillStopGetTaggedPages.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetTaggedPages.onNext(())
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
    
    private func setupData() {
        if contentId == nil || (contentId?.isEmpty)! {
            contentId = feed?.contentId ?? ""
        }
        if pageUrl == nil || (pageUrl?.isEmpty)! {
            pageUrl = feed?.universalUrl
        }
        if pageId == nil || (pageId?.isEmpty)! {
            pageId = feed?.author?.authorId
        }
        
        contentPageType = Common.getContentPageTypeFromFeed(feed: feed)
        if contentPageType == .postVideo {
            if let post = self.feed as? Post, let sType = post.subType,
                let subType = FeedSubType(rawValue: sType),
                subType == .video, let video = post.medias?.first as? Video {
                video.currentTime.value = currentVideoTime
            }
        }
        if contentPageType != .bundle { injectAds() }
        onWillStopGetItem.onNext(())
        getRelatedContents()
        getComments()
        getVideoPlaylist()
        
        if let playlist = feed as? Playlist {
            onDidLoadPlaylistItem.onNext(playlist)
        }
    }
    
    private func setUpRxForGetItem() {
        startLoadContentByUrlOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetItem.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<(Feed?, PageDetail?, String?)> in
                guard let pageUrl = self.pageUrl else { return Observable.empty() }
                return self.interactor.getContentPage(pageUrl: pageUrl, contentPageType: self.contentPageType)
                    .catchError { error in
                        self.onDidGetError.onNext(error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] feed, pageDetail, redirectUrl in
                if let feed = feed {
                    self.feed = feed
                    self.pageDetail = pageDetail
                    self.setupData()
                    self.getLikeStatus(feed: self.feed)
                } else if let redirectUrl = redirectUrl {
                    self.pageUrl = redirectUrl
                    self.startLoadContentByUrlOnDemand.onNext(())
                } else {
                    self.onDidGetError.onNext(ApiError.dataNotAvailable(description:
                        R.string.localizable.errorDataNotAvailable()))
                }
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
        
        startLoadContentByIdOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetItem.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<Feed?> in
                guard let contentId = self.contentId else { return Observable.empty() }
                return self.interactor.getContentPage(pageId: contentId)
                    .catchError { _ in
                        self.startLoadContentByUrlOnDemand.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] feed in
                if let feed = feed {
                    self.feed = feed
                    self.setupData()
                    self.getLikeStatus(feed: self.feed)
                } else {
                    self.startLoadContentByUrlOnDemand.onNext(())
                }
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
    
    private func setUpRxGetComments() {
        startLoadCommentsOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetComments.onNext(())
            })
            .flatMap { [unowned self] data -> Observable<[Comment]> in
                return self.interactor.getCommentsFrom(data: data)
                    .catchError { _ -> Observable<[Comment]> in
                        self.onWillErrorComments.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] item in
				item.forEach { self.comments.append($0) }
            })
            .do(onNext: { [unowned self] item in
                self.onWillStopGetComments.onNext((!(item.count < Constants.DefaultValue.defaultCommentPageSize)))
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
    
    private func setUpRxForGetRelatedContents() {
        startLoadRelatedContentsOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetRelatedContents.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<[Feed]?> in
                guard let pageUrl = self.pageUrl, let contentId = self.contentId else { return Observable.empty() }
                var type: String? = nil
                var subtype: String? = nil
                if self.contentPageType == .postEpisode {
                    type = FeedType.post.rawValue
                    subtype = FeedSubType.episode.rawValue
                } else if self.contentPageType == .postVideo {
                    type = FeedType.post.rawValue
                    subtype = FeedSubType.video.rawValue
                }
                return self.interactor.getRelatedContent(pageUrl: pageUrl, pageId: contentId, type: type,
                                                         subtype: subtype)
                    .catchError { _ in
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] relatedContents in
                self.relatedContents = relatedContents
            })
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetRelatedContents.onNext(())
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
    
    private func injectAds() {
		guard let data = feed as? Article else { return }
		if data.paragraphs.isEmpty || data.paragraphs.first(where: { $0.type == .ads }) != nil { return }
		data.paragraphs.insert(Paragraph(), at: data.paragraphs.isEmpty ? 0 : 1)
    }
    
    private func getLikeStatus(feed: Feed?) {
        guard let feed = feed, let contentId = feed.contentId else { return }
        let ids = [contentId]
        socialService.getLikeStatus(ids: ids)
            .do(onNext: { [unowned self] array in
                for item in array {
                    guard let id = item.id, let likeStatus = item.liked else {
                        continue
                    }
                    if let likable = self.feed, let contentId = likable.contentId, id == contentId {
                        likable.liked = likeStatus
                        likable.didReceiveLikeStatus.onNext(likable.liked)
                        break
                    }
                }
            })
            .subscribe()
            .disposed(by: self.likeStatusDisposeBag)
    }
}
