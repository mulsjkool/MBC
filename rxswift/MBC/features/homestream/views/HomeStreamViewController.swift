//
//  HomeStreamViewController.swift
//  MBC
//
//  Created by azuniMac on 12/16/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
import MisterFusion
import UIKit

class HomeStreamViewController: BaseViewController {
    var viewModel = HomeStreamViewModel(interactor: Components.homeStreamInteractor(),
                                        socialService: Components.userSocialService)
	var streamTableView: UITableView!
    private var dataReadyForStream = false
    private var heightAtIndexPathDict = [String: CGFloat]()
	private var adsCells = [IndexPath: AdsContainer]() // caching ads
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeStreamViewController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
	
    private var isMoreDataAvailable: Bool = false
    
    // constant
    private let estimatedRowHeight = CGFloat(210)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigator = Navigator(navigationController: self.navigationController)
        viewModel.errorDecorator = self
        bindEvents()
        getHomeStream()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.resetVideoPlayingStatusFor(table: streamTableView)
        updateGifAnimation()
    }
    
    // MARK: Private functions
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartGetListItem.subscribe({ [unowned self] _ in
                self.isMoreDataAvailable = true
            }),
            viewModel.onWillStopGetListItem.subscribe(onNext: { [unowned self] _ in
				self.loadDataItems()
            }),
            viewModel.onDidLoadItems.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            }),
            viewModel.onFinishLoadListItem.subscribe(onNext: { [unowned self] in
                self.refreshControl.endRefreshing()
                self.isMoreDataAvailable = false
            }),
			viewModel.onDidError.subscribe(onNext: { [unowned self] in
				self.showError()
			})
        ])
    }
	
	func loadDataItems() {
		self.refreshControl.endRefreshing()
		self.dataReadyForStream = true
		self.updateContent()
	}
	
	func showError() {
		self.refreshControl.endRefreshing()
		self.isMoreDataAvailable = false
	}
    
	func getHomeStream() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.loadItems()
        })
    }
    
	func setupUI() {
        addTableView()
        addRefreshControl()
    }
    
    private func addRefreshControl() {
        if refreshControl.superview == nil {
            streamTableView.addSubview(refreshControl)
        }
    }
    
	func addTableView() {
        let displayWidth = Constants.DeviceMetric.screenWidth
        let displayHeight = Constants.DeviceMetric.displayViewHeightWithNavAndTabbar
        streamTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        self.view.addSubview(streamTableView)
        streamTableView.translatesAutoresizingMaskIntoConstraints = false
        view.mf.addConstraints(
            streamTableView.top |==| view.top,
            streamTableView.left |==| view.left,
            streamTableView.width |==| view.width,
            streamTableView.height |==| view.height
        )
        
        streamTableView.separatorStyle = .none
        streamTableView.allowsSelection = true
        
        streamTableView.dataSource = self
        streamTableView.delegate = self
        streamTableView.rowHeight = UITableViewAutomaticDimension
        streamTableView.estimatedRowHeight = estimatedRowHeight
        streamTableView.backgroundColor = Colors.defaultBg.color()
        streamTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        streamTableView.showsVerticalScrollIndicator = false
        streamTableView.showsHorizontalScrollIndicator = false
        
        //TO BE ADDED MORE
        if Constants.Singleton.isiPad {
            streamTableView.register(R.nib.iPadPostCardMultiImagesTableViewCell(),
                                     forCellReuseIdentifier:
                R.reuseIdentifier.iPadPostCardMultiImagesTableViewCellid.identifier)
            streamTableView.register(R.nib.iPadHomeStreamSingleItemCell(),
                                     forCellReuseIdentifier:
                R.reuseIdentifier.iPadHomeStreamSingleItemCellId.identifier)
            streamTableView.register(R.nib.iPadAppCardTableViewCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.iPadAppCardTableViewCellid.identifier)
            streamTableView.register(R.nib.iPadEmbeddedCardCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.iPadEmbeddedCardCellid.identifier)
            streamTableView.register(R.nib.iPadPageCardCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.iPadPageCardCellId.identifier)
            streamTableView.register(R.nib.iPadAppCardTableViewCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.iPadAppCardTableViewCellid.identifier)
            streamTableView.register(R.nib.iPadBundleSingleItemCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.iPadBundleSingleItemCellId.identifier)
        } else {
            streamTableView.register(R.nib.postCardMultiImagesTableViewCell(),
                                     forCellReuseIdentifier:
                R.reuseIdentifier.postCardMultiImagesTableViewCellid.identifier)
            streamTableView.register(R.nib.homeStreamSingleItemCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.homeStreamSingleItemCell.identifier)
            streamTableView.register(R.nib.pageCardCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.pageCardCellId.identifier)
            streamTableView.register(R.nib.appCardTableViewCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.appCardTableViewCellid.identifier)
            streamTableView.register(R.nib.embeddedCardCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.embeddedCardCell.identifier)
            streamTableView.register(R.nib.bundleSingleItemCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.bundleSingleItemCell.identifier)
        }
        
        streamTableView.register(R.nib.cardTextCell(),
                                 forCellReuseIdentifier: R.reuseIdentifier.cardTextCellId.identifier)
		streamTableView.register(R.nib.carouselTableViewCell(),
								 forCellReuseIdentifier: R.reuseIdentifier.carouselTableViewCellid.identifier)
        streamTableView.register(R.nib.bannerAdsViewCell(),
                                 forCellReuseIdentifier: R.reuseIdentifier.bannerAdsViewCell.identifier)
        streamTableView.register(R.nib.videoSingleItemCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.videoSingleItemCellId.identifier)
    }
	
	// MARK: - Private method
    private func updateContent() {
        streamTableView.reloadData()
        Components.analyticsService.logCells(visibleCells: streamTableView.visibleCells)
    }

    @objc
    private func refreshData(_ refreshControl: UIRefreshControl) {
		print("adViewDidReceiveAd: ---- RESET ----")
        adsCells.removeAll()
        isMoreDataAvailable = false
        viewModel.refreshItems()
    }
    
    private func loadMoreData() {
        viewModel.loadItems()
    }
    
    private func createLoadMoreCell(_ indexPath: IndexPath) -> UITableViewCell? {
        if viewModel.itemsList.isEmpty ||
            indexPath.row < viewModel.itemsList.count ||
            !isMoreDataAvailable { return nil }
        
        loadMoreData()
        
        return Common.createLoadMoreCell()
    }
    
    private func streamCardPostCell(_ post: Post, row: Int, highlight keyword: String) -> UITableViewCell {
        guard let subType = post.subType, let type = FeedSubType(rawValue: subType) else { return UITableViewCell() }
        switch type {
        case .text:
            if let cell = postTextCellFor(post: post, highlight: keyword) {
                cell.indexRow = row
                return cell
            }
        case .image:
            if let cell = postImageCellFor(post: post, highlight: keyword) {
                cell.indexRow = row
                return cell
            }
        case .video:
            if let cell = postVideoCellFor(post: post, highlight: keyword) {
                cell.indexRow = row
                return cell
            }
        case .embed:
            if let cell = postEmbedCellFor(post: post, highlight: keyword) {
                cell.indexRow = row
                return cell
            }
        case .episode:
            break
        }
        return UITableViewCell()
    }
    
    private func postEmbedCellFor(post: Post, highlight keyword: String) -> EmbeddedCardCell? {
        let identifier = IPad.CellIdentifier.embeddedCardCell
        guard let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier) as? EmbeddedCardCell
            else { return nil }
            
        cell.bindData(post: post, accentColor: nil)
		cell.highlight(keyword: keyword)
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didUpdateWebView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.openInAppBrowser(url: url)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] data in
                if let post = data as? Post { self.navigator?.pushEmbed(post: post, isShowComment: true) }
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.showFullscreenImage(post, accentColor: nil, imageIndex: 0)
            }),
            cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.navigator?.presentTaggedPageListing(authorList: authors)
            })
        ])
        
        return cell
    }
    
    private func postImageCellFor(post: Post, highlight keyword: String) -> PostCardMultiImagesTableViewCell? {
        let identifier = IPad.CellIdentifier.postCardMultiImagesCell
        
        guard let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier)
            as? PostCardMultiImagesTableViewCell else { return nil }

        cell.bindData(feed: post, accentColor: nil)
		cell.highlight(keyword: keyword)
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didSelectImageAtIndex.subscribe(onNext: { [unowned self] imageIndex, idImage in
                self.showFullscreenImage(post, accentColor: nil, imageIndex: imageIndex, imageId: idImage)
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.showFullscreenImage(post, accentColor: nil, imageIndex: 0)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post, isShowComment: true)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                self.showFullscreenImage(post, accentColor: nil, imageIndex: 0)
            }),
            cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.navigator?.presentTaggedPageListing(authorList: authors)
            })
        ])
        
        return cell
    }
    
    private func postVideoCellFor(post: Post, highlight keyword: String) -> PostCardMultiImagesTableViewCell? {
        let identifier = IPad.CellIdentifier.postCardMultiImagesCell
        
        guard let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier)
            as? PostCardMultiImagesTableViewCell else { return nil }
        
        cell.bindData(feed: post, accentColor: nil)
		cell.highlight(keyword: keyword)
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post, isShowComment: false, cell: cell)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post, isShowComment: false, cell: cell)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post, isShowComment: true, cell: cell)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post, isShowComment: false, cell: cell)
            }),
            cell.videoPlayerTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.pushVideoPlaylistFrom(feed: post)
            }),
            cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.navigator?.presentTaggedPageListing(authorList: authors)
            })
        ])

        return cell
    }
    
    private func postTextCellFor(post: Post, highlight keyword: String) -> CardTextCell? {
        guard let cell = streamTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.cardTextCellId.identifier) as? CardTextCell else { return nil }
        
        cell.bindData(post: post, accentColor: nil)
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post)
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToPageDetail(feed: post)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigator?.navigateToContentPage(feed: post, isShowComment: true)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
            cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.navigator?.presentTaggedPageListing(authorList: authors)
            })
        ])
        
        return cell
    }
    
    private func streamCardArticleCell(_ article: Article, row: Int, highlight keyword: String) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.postCardMultiImagesCell
        
        if let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier) as?
            PostCardMultiImagesTableViewCell {
			cell.bindData(feed: article, accentColor: nil)
			cell.highlight(keyword: keyword)
            cell.disposeBag.addDisposables([
                cell.expandedText.subscribe(onNext: { [unowned self] _ in
                    self.reloadCell()
                }),
				cell.didSelectImageAtIndex.subscribe(onNext: {  [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: article)
				}),
                cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                    self.reloadCell()
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: article)
                }),
                cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: article)
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: article, isShowComment: true)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                    self.getURLFromObjAndShare(obj: data)
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: article)
                }),
                cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: article)
                }),
                cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: article)
                }),
                cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                    self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
                }),
                cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.navigator?.presentTaggedPageListing(authorList: authors)
                })
            ])
            
            cell.indexRow = row
            return cell
        }
        return createDummyCellWith(title: "Cell for streamCard type: article")
	}
	
    func carouselCellFor(_ campaign: Campaign) -> UITableViewCell {
		if let cell = streamTableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.carouselTableViewCellid.identifier) as? CarouselTableViewCell {
			cell.bindData(campaign)
            cell.disposeBag.addDisposables([
                cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                    self.openContentPageOfCarousel(feed: feed, imageIndex: defaultImageIndex)
                }),
                cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                    self.openContentPageOfCarousel(feed: feed, imageIndex: defaultImageIndex)
                }),
                cell.authorNameTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.numberOfVideoTapped.subscribe(onNext: { [unowned self] feed in
                    self.openContentPageOfCarousel(feed: feed)
                })
            ])
			return cell
		}
		
		return UITableViewCell()
	}
    
    private func openContentPageOfCarousel(feed: Feed, imageIndex: Int = 0) {
        if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType) {
            if type == .image {
                self.showFullscreenImage(post, accentColor: nil, imageIndex: imageIndex)
                return
            } else  if type == .video {
                self.navigator?.pushVideoPlaylistFrom(feed: feed)
                return
            }
        }
        self.navigator?.navigateToContentPage(feed: feed)
    }
	
    private func bannerAdsCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = streamTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.bannerAdsViewCell.identifier) as? BannerAdsViewCell else { return UITableViewCell() }
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath] {
				ads.requestAds(adsType: .banner, viewController: self)
				ads.disposeBag.addDisposables([
					ads.loadAdSuccess.subscribe(onNext: { [unowned self] row in
                        if let index = row { self.streamTableView.reloadRows(at: [index], with: .fade) }
                    }),

                    ads.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                        self?.openInAppBrowser(url: URL(string: urlString)!)
                    })
				])
			}
		}
        return cell
    }

    func reloadCell() {
        streamTableView.beginUpdates()
        streamTableView.endUpdates()
    }
    
    private func videoSingleItemCell(_ feed: Feed, row: Int) -> UITableViewCell {
        if let cell = streamTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.videoSingleItemCellId.identifier)
            as? VideoSingleItemCell {
            cell.bindData(feed: feed, accentColor: nil)
            cell.bindData(feed: feed, accentColor: Colors.singleItemAccentColor.color())
            cell.disposeBag.addDisposables([
                cell.expandedText.subscribe(onNext: { [unowned self] _ in
                    self.reloadCell()
                }),
                cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: feed, isShowComment: false, cell: cell)
                }),
                cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                    self.reloadCell()
                }),
                cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: feed, isShowComment: false, cell: cell)
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: feed, isShowComment: true, cell: cell)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                    self.getURLFromObjAndShare(obj: data)
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.pushVideoPlaylistFrom(feed: feed)
                }),
                cell.videoPlayerTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.pushVideoPlaylistFrom(feed: feed)
                }),
                cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                    self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
                }),
                cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.navigator?.presentTaggedPageListing(authorList: authors)
                })
            ])
            return cell
        }
        return  Common.createDummyCellWith(title: "Cell for singleItem type: \(feed.type)")
    }
    
	private func singleItemCell(_ feed: Feed, row: Int) -> UITableViewCell {
        if let subTypeStr = feed.subType, let subType = FeedSubType(rawValue: subTypeStr) {
            if subType == .video {
                return videoSingleItemCell(feed, row: row)
            }
        }
        let identifier = IPad.CellIdentifier.homeStreamSingleItemCell
    
        if let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier) as? HomeStreamSingleItemCell {
            cell.bindData(feed: feed, accentColor: Colors.singleItemAccentColor.color())
			
			cell.disposeBag.addDisposables([
				cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: feed)
				}),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: feed)
                }),
                cell.thumbnailTapped.subscribe(onNext: { [unowned self] _ in
                    if let app = feed as? App {
                        self.navigator?.pushAppWhitePage(app: app)
                    } else if let post = feed as? Post, let subTypeStr = feed.subType,
                        FeedSubType(rawValue: subTypeStr) == FeedSubType.image {
                        self.showFullscreenImage(post, accentColor: nil, imageId: post.defaultImageId ?? "")
                    } else if let article = feed as? Article {
                        self.navigateToContentPage(feed: article)
                    }
                }),
                cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                    if let app = feed as? App {
                        self.navigator?.pushAppWhitePage(app: app)
                    }
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                    if let app = feed as? App {
                        self.navigator?.pushAppWhitePage(app: app)
                    }
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToContentPage(feed: feed, isShowComment: true)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                    self.getURLFromObjAndShare(obj: data)
                }),
                cell.authorPageTapped.subscribe(onNext: { [unowned self] author in
                    self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
                }),
                cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.navigator?.presentTaggedPageListing(authorList: authors)
                })
			])
            cell.indexRow = row
			return cell
		}
		return createDummyCellWith(title: "Cell for SingleItem type: Article")
	}
    
    private func singleItemFor(_ item: Campaign, row: Int) -> UITableViewCell {
        guard let sItem = item.items.first, let itemType = FeedType(rawValue: sItem.type) else {
            return createDummyCellWith(title:
                "Cell for single item type: \(String(describing: item.items.first?.type))")
        }
        
        switch itemType {
        case .page:
            // swiftlint:disable:next force_cast
            return singleItemPageCell(sItem as! Page, row: row)
        case .article, .post, .app:
            return singleItemCell(sItem, row: row)
        case .bundle:
            return singleItemBundleCell(sItem)
        case .playlist:
            return singleItemPlaylistCell(sItem)
        default:
            print("TODO: NEED TO IMPLEMENT FOR TYPE OF HOMESTREAM CELL - \(itemType)")
        }
        return createDummyCellWith(title: "Cell for streamCard type: \(itemType)")
    }
    
    private func singleItemBundleCell(_ feed: Feed) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.bundleSingleItemCell
        
        if let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier) as? BundleSingleItemCell,
            let bundle = feed as? BundleContent {
            cell.bindData(bundle: bundle, accentColor: nil)
            cell.disposeBag.addDisposables([
                cell.authorNameTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.timestampTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToContentPage(feed: feed)
                }),
                cell.bundleTitleTapped.subscribe(onNext: { [unowned self] bundle, _ in
                    self.navigator?.navigateToContentPage(feed: bundle)
                }),
                cell.thumbnailTapped.subscribe(onNext: { [unowned self] bundle, _ in
                    self.navigator?.navigateToContentPage(feed: bundle)
                }),
                cell.itemTitleTapped.subscribe(onNext: { [unowned self] bundle, _ in
                    self.navigator?.navigateToContentPage(feed: bundle)
                }),
                cell.commentCountTapped.subscribe(onNext: { [unowned self] bundle, _ in
                    self.navigator?.navigateToContentPage(feed: bundle, isShowComment: true)
                }),
                cell.likeCountTapped.subscribe(onNext: { [unowned self] bundle, _ in
                    self.navigator?.navigateToContentPage(feed: bundle)
                }),
                cell.readMoreCarouselItemTapped.subscribe(onNext: { [unowned self] bundle, _ in
                    self.navigator?.navigateToContentPage(feed: bundle)
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    private func singleItemPlaylistCell(_ feed: Feed) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.bundleSingleItemCell
        
        if let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier) as? BundleSingleItemCell,
            let playlist = feed as? Playlist {
            cell.bindData(bundle: playlist, accentColor: nil)
            cell.disposeBag.addDisposables([
                cell.authorNameTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToPageDetail(feed: feed)
                }),
                cell.timestampTapped.subscribe(onNext: { [unowned self] feed in
                    self.navigator?.navigateToContentPage(feed: feed)
                }),
                cell.bundleTitleTapped.subscribe(onNext: { [unowned self] _, item in
                    self.navigator?.pushVideoPlaylistFrom(feed: item)
                }),
                cell.thumbnailTapped.subscribe(onNext: { [unowned self] _, item in
                    self.navigator?.pushVideoPlaylistFrom(feed: item)
                }),
                cell.commentCountTapped.subscribe(onNext: { [unowned self] _, item in
                    self.navigator?.pushVideoPlaylistFrom(feed: item)
                }),
                cell.likeCountTapped.subscribe(onNext: { [unowned self] _, item in
                    self.navigator?.pushVideoPlaylistFrom(feed: item)
                }),
                cell.readMoreCarouselItemTapped.subscribe(onNext: { [unowned self] _, item in
                    self.navigator?.pushVideoPlaylistFrom(feed: item)
                })
            ])
            return cell
        }
        return UITableViewCell()
    }
    
    private func singleItemPageCell(_ sPage: Page, row: Int) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.pageCardCell
        
        if let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier) as? PageCardCell {
            cell.bindData(model: sPage)
            cell.indexRow = row
            cell.disposeBag.addDisposables([
                cell.coverTapped.subscribe(onNext: { [unowned self] url in
                    self.openFullScreenImage(page: sPage, url: url)
                }),
                cell.posterTapped.subscribe(onNext: { [unowned self] url in
                    self.openFullScreenImage(page: sPage, url: url)
                }),
                cell.pageTitleTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigator?.navigateToPageDetail(feed: sPage)
                })
            ])
            return cell
        }
        return createDummyCellWith(title: "Cell for singleItemPageCell type: Page")
    }
    
    private func openFullScreenImage(page: Page, url: String?) {
        guard let pageId = page.contentId,
            let author = page.author,
            let url = url, !url.isEmpty else { return }
        var accentColor = Colors.defaultAccentColor.color()
        if let accentColorValue = author.accentColor {
            accentColor = UIColor(rgba: accentColorValue)
        }
        self.showFullScreenImageFrom(imageUrl: url, pageId: pageId,
                                     accentColor: accentColor,
                                     author: author)
    }
	
	private func navigateToPageDetail(feed: Feed) {
		if let author = feed.author {
			if author.authorId.isEmpty {
				author.authorId = feed.uuid ?? ""
			}
			navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
		}
	}
	
	private func updateGifAnimation() {
		Common.repeatCall { [weak self] in
			guard let strongSelf = self else { return }
			strongSelf.scrollViewDidScroll(strongSelf.streamTableView)
		}
	}
	
	// MARK: - Public method
    
    // swiftlint:disable:next cyclomatic_complexity
    func navigateToContentPage(feed: Feed, isShowComment: Bool = false, cell: UITableViewCell? = nil) {
        if let post = feed as? Post, let subType = post.subType, let type = FeedSubType(rawValue: subType) {
            switch type {
            case .text:
                navigator?.pushPostText(post: post, isShowComment: isShowComment)
            case .image:
                navigator?.pushPostImage(post: post, isShowComment: isShowComment)
            case .video:
                if let video = post.medias?.first as? Video, let videoCell = cell as? PostCardMultiImagesTableViewCell {
                    let contentPageVC = self.navigator?.pushVideo(post: post, currentVideoTime: video.currentTime.value)
                    contentPageVC?.didBackFromVideoContentPage.subscribe(onNext: { aVideo in
                        if let aVideo = aVideo {
                            videoCell.playVideo(true, currentTime: aVideo.currentTime.value)
                        }
                    }).disposed(by: (contentPageVC?.disposeBag)!)
                }
            case .embed:
                navigator?.pushEmbed(post: post, isShowComment: isShowComment)
            case .episode:
                return
            }
        }
        if let article = feed as? Article {
            navigator?.pushArticle(article: article, isShowComment: isShowComment)
        }
        if let app = feed as? App {
            navigator?.pushApp(app: app, isShowComment: isShowComment)
        }
        if feed is Page {
            navigateToPageDetail(feed: feed)
        }
    }
	
	func streamCardCellFor(_ item: Campaign, row: Int, highlight keyword: String = "") -> UITableViewCell {
		guard let card = item.items.first,
			let cardType = FeedType(rawValue: card.type) else {
				return createDummyCellWith(title:
					"Cell for streamCard type: \(String(describing: item.items.first?.type))")
		}
		
		// swiftlint:disable force_cast
		switch cardType {
		case .post:
			return streamCardPostCell(card as! Post, row: row, highlight: keyword)
		case .article:
			return streamCardArticleCell(card as! Article, row: row, highlight: keyword)
		default:
			print("TODO: NEED TO IMPLEMENT FOR TYPE OF HOMESTREAM CELL - \(cardType)")
		}
		// swiftlint:enable force_cast
		return createDummyCellWith(title: "Cell for streamCard type: \(cardType)")
	}
	
	func createSingleItemCell(campaign: Campaign, row: Int) -> UITableViewCell {
		let singleItemCell = singleItemFor(campaign, row: row)
		(singleItemCell as? BaseCampaignTableViewCell)?.bindMapCampaign(mapCampaign: [campaign])
		return singleItemCell
	}
}

extension HomeStreamViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPathDict["\(indexPath.row)"] {
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !dataReadyForStream {
            return Constants.DefaultValue.PlaceHolderLoadingHeight
        }
		
        if viewModel.itemsList.count > indexPath.row {
            let item = viewModel.itemsList[indexPath.row]
            if item.type == .ads {
                if let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height {
                    return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
									+ Constants.DefaultValue.paddingBannerAdsCellTop
                }
                return 0
            }
        }
        
		return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is HomeStreamSingleItemCell || cell is PostCardMultiImagesTableViewCell { updateGifAnimation() }
        heightAtIndexPathDict["\(indexPath.row)"] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !dataReadyForStream {
            return 3 // place holder cells
        }
        
        let itemsCount = viewModel.itemsList.count
        if isMoreDataAvailable && itemsCount > 0 { return itemsCount + 1 }
        
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !dataReadyForStream {
            return Common.createLoadingPlaceHolderCell()
        }
        
        if let cell = createLoadMoreCell(indexPath) {
            return cell
        }
        
        if viewModel.itemsList.isEmpty || indexPath.row >= viewModel.itemsList.count {
            return UITableViewCell()
        }
        
        let item = viewModel.itemsList[indexPath.row]
		switch item.type {
		case .carousel:
            let carouselCell = carouselCellFor(item)
            (carouselCell as? BaseCampaignTableViewCell)?.bindMapCampaign(mapCampaign: [item])
            
			return carouselCell
		case .singleItem:
            return createSingleItemCell(campaign: item, row: indexPath.row)
		case .streamCard:
            if item.featureOnStream { return createSingleItemCell(campaign: item, row: indexPath.row) }
            let streamCardCell = streamCardCellFor(item, row: indexPath.row)
            (streamCardCell as? BaseCampaignTableViewCell)?.bindMapCampaign(mapCampaign: [item])
            
            return streamCardCell
		case .ads:
            return bannerAdsCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard viewModel.itemsList.count > indexPath.row else { return }
        
        let item = viewModel.itemsList[indexPath.row]
        switch item.type {
        case .carousel:
            return
        case .streamCard:
            guard let sItem = item.items.first,
                let itemType = FeedType(rawValue: sItem.type) else {
                    return
            }
			switch itemType {
			case .post:
				if let subtypeStr = sItem.subType, let subtype = FeedSubType(rawValue: subtypeStr) {
					if subtype == .image {
                        showFullscreenImage(sItem, accentColor: nil)
					}
				}
			default:
				print("TODO: NEED TO IMPLEMENT DIDSELECTROW FOR TYPE OF HOMESTREAM - \(itemType)")
			}
        case .ads:
            return
        case .singleItem:
            return
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        Components.analyticsService.logCells(visibleCells: streamTableView.visibleCells)
    }
    
    // swiftlint:disable force_cast
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Common.shouldBypassAnimation() { return }
        
        let visibleCells = streamTableView.visibleCells
        Constants.Singleton.isAInlineVideoPlaying = false
        for cell in visibleCells {
            if cell is HomeStreamSingleItemCell {
                let result = Common.setAnimationFor(cell: (cell as! HomeStreamSingleItemCell),
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
            if cell is PostCardMultiImagesTableViewCell {
                let result = Common.setAnimationFor(cell: (cell as! PostCardMultiImagesTableViewCell),
                                                    viewPort: view,
                                                    isAVideoPlaying: Constants.Singleton.isAInlineVideoPlaying)
                if result.isVideo { Constants.Singleton.isAInlineVideoPlaying = result.shouldResume }
                continue
            }
        }
    }
    // swiftlint:enable force_cast
}
