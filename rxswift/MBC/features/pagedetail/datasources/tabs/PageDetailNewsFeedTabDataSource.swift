//
//  PageDetailNewsFeedTabDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailNewsFeedTabDelegate: PageDetailAppTabDelegate {
    func navigateToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?)
    func showFullscreenImage(_ feed: Feed, pageId: String, imageIndex: Int, imageId: String)
    func openInAppBrowser(url: URL)
    func navigateToPageDetail(feed: Feed)
    func navigateToPageDetail(author: Author)
    func navigateToTaggedPageListing(authors: [Author])
    func navigateToVideoPlaylist(feed: Feed)
	func reloadCell()
	func reloadCell(at indexPath: IndexPath)
}

enum PageDetailNewsFeedTabSection: Int {
    case bundles = 0
    case newsFeed = 1
}

class PageDetailNewsFeedTabDataSource: PageDetailTabDataSource {
	
	// Caching ads in Newsfeed tab
	private var adsCells = [IndexPath: AdsContainer]()
	var universalUrl: String = ""
    
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "")
    }
    
    weak var delegate: PageDetailNewsFeedTabDelegate?
	
	func resetCachingAds() {
		adsCells.removeAll()
	}

    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == PageDetailNewsFeedTabSection.bundles.rawValue {
            if let bundles = delegate?.getBundles() {
                return bundleCarouselCell(tableView: tableView, bundles: bundles)
            }
            return UITableViewCell()
        }
        guard let itemList = delegate?.getItemList() else {
            return createDummyCell(tableView: tableView, indexPath: indexPath)
        }
        
        if itemList.list.isEmpty, let streamInfoComponent = delegate?.streamInfoComponent() {
            return infoComponentCell(tableView: tableView, infoComponent: streamInfoComponent)
        }
        
        // Logic for inputting a stream info component under the first stream card
        var realRowIndex = indexPath.row
        if indexPath.section == PageDetailNewsFeedTabSection.newsFeed.rawValue,
            let streamInfoComponent = delegate?.streamInfoComponent() {
            if indexPath.row == 1 {
                return infoComponentCell(tableView: tableView, infoComponent: streamInfoComponent)
            } else if indexPath.row > 1 {
                realRowIndex = indexPath.row - 1
            }
        }
        
        return cellWithoutInfoComponent(tableView: tableView,
                                        indexPath: IndexPath(row: realRowIndex, section: indexPath.section))
    }
	
	func bannerAdsHeightCell(at indexPath: IndexPath) -> CGFloat? {
		guard let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height else { return 0 }
		return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
				+ Constants.DefaultValue.paddingBannerAdsCellTop
	}
    
    private func cellWithoutInfoComponent(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let itemList = delegate?.getItemList() else {
            return createDummyCell(tableView: tableView, indexPath: indexPath)
        }
        
        if itemList.list.count > indexPath.row,
            let feed = itemList.list[indexPath.row] as? Feed,
            let type = FeedType(rawValue: feed.type) {
            if feed.featureOnStream {
                return singleItemCell(feed, tableView: tableView, row: indexPath.row)
            }
            if type == .post, let post = feed as? Post {
                return createPostCell(tableView: tableView, post: post, indexPath: indexPath)
            }
            if type == .article, let article = feed as? Article {
                return createArticleCell(tableView: tableView, article: article, row: indexPath.row)
            }
            if type == .app, let app = feed as? App {
                return createAppCell(tableView: tableView, app: app)
            }
        }
        return createDummyCell(tableView: tableView, itemList: itemList, indexPath: indexPath)
    }
    
    private func infoComponentCell(tableView: UITableView, infoComponent: InfoComponent) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.carouselTableViewCellid.identifier) as? CarouselTableViewCell {
            cell.bindData(info: infoComponent, languageConfigList: delegate?.getLanguageConfigList())
            cell.disposeBag.addDisposables([
                cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, _ in
                    self.delegate?.navigateToPageDetail(feed: feed)
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] feed, _ in
                    self.delegate?.navigateToPageDetail(feed: feed)
                })
            ])
            return cell
        }
        return dummyCell
    }
    
    private func videoSingleItemCell(_ feed: Feed, tableView: UITableView, row: Int) -> UITableViewCell {
         //if let subTypeStr = post.subType, let subType = FeedSubType(rawValue: subTypeStr)
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.videoSingleItemCellId.identifier)
            as? VideoSingleItemCell {
            cell.bindData(feed: feed, accentColor: nil)
            cell.disposeBag.addDisposables([
                cell.timestampTapped.subscribe(onNext: { [weak self] _ in
                    self?.delegate?.navigateToContentPage(feed: feed, isShowComment: false, cell: cell)
                }),
                cell.didTapDescription.subscribe(onNext: { [weak self] _ in
                   self?.delegate?.navigateToVideoPlaylist(feed: feed)
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigateToContentPage(feed: feed, isShowComment: true, cell: cell)
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToVideoPlaylist(feed: feed)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                    self.delegate?.getURLFromObjAndShare(obj: data)
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToPageDetail(feed: feed)
                }),
                cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToPageDetail(feed: feed)
                }),
                cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.delegate?.navigateToTaggedPageListing(authors: authors)
                }),
                cell.videoPlayerTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToVideoPlaylist(feed: feed)
                })
            ])
            return cell
        }
         return  Common.createDummyCellWith(title: "Cell for singleItem type: \(feed.type)")
    }
    
    private func singleItemCell(_ feed: Feed, tableView: UITableView, row: Int) -> UITableViewCell {
        if let subTypeStr = feed.subType, let subType = FeedSubType(rawValue: subTypeStr) {
            if subType == .video {
                return videoSingleItemCell(feed, tableView: tableView, row: row)
            }
        }
        let identifier = IPad.CellIdentifier.homeStreamSingleItemCell
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            identifier) as? HomeStreamSingleItemCell {
            cell.bindData(feed: feed, accentColor: nil)
            
            cell.disposeBag.addDisposables([
                cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToContentPage(feed: feed, isShowComment: false, cell: cell)
                }),
                cell.thumbnailTapped.subscribe(onNext: { [unowned self] _ in
                    if let app = feed as? App {
                        self.delegate?.pushAppWhitePage(app: app)
                    } else if let post = feed as? Post, let subTypeStr = feed.subType,
                        FeedSubType(rawValue: subTypeStr) == FeedSubType.image {
                        self.showFullscreenImage(post, imageId: post.defaultImageId ?? "")
                    } else if let article = feed as? Article {
                       self.navigateToContentPage(feed: article)
                    }
                }),
                cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                    if let app = feed as? App {
                        self.delegate?.pushAppWhitePage(app: app)
                    } else if let post = feed as? Post, let subTypeStr = feed.subType,
                        FeedSubType(rawValue: subTypeStr) == FeedSubType.image,
                        let pageId = self.delegate?.getPageId() {
                        self.showFullscreenImage(post, pageId: pageId)
                    }
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                    if let app = feed as? App {
                        self.delegate?.pushAppWhitePage(app: app)
                    } else if let post = feed as? Post, let subTypeStr = feed.subType,
                        FeedSubType(rawValue: subTypeStr) == FeedSubType.image,
                        let pageId = self.delegate?.getPageId() {
                        self.showFullscreenImage(post, pageId: pageId)
                    }
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToContentPage(feed: feed, isShowComment: true, cell: cell)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                     self.delegate?.getURLFromObjAndShare(obj: data)
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToPageDetail(feed: feed)
                }),
                cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToPageDetail(feed: feed)
                }),
                cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.delegate?.navigateToTaggedPageListing(authors: authors)
                })
            ])
            cell.indexRow = row
            return cell
        }
        return  Common.createDummyCellWith(title: "Cell for singleItem type: \(feed.type)")
    }
    
    private func createAppCell(tableView: UITableView, app: App) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.appCardTableViewCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? AppCardTableViewCell {
            cell.bindData(feed: app, accentColor: delegate?.getAccentColor())
            cell.disposeBag.addDisposables([
                cell.expandedText.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.reloadCell()
                }),
                cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.reloadCell()
                }),
                cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                    self.navigateToContentPage(feed: app)
                }),
                cell.didTapTitle.subscribe(onNext: { [unowned self] app in
                    self.pushAppWhitePage(app: app)
                }),
                cell.didTapAppPhoto.subscribe(onNext: { [unowned self] app in
                    self.pushAppWhitePage(app: app)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                    self.delegate?.getURLFromObjAndShare(obj: data)
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] data in
                    if let app = data as? App { self.navigateToContentPage(feed: app, isShowComment: true) }
                }),
                cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                    self.pushAppWhitePage(app: app)
                }),
                cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToPageDetail(feed: app)
                }),
                cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.navigateToPageDetail(feed: app)
                }),
                cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.delegate?.navigateToTaggedPageListing(authors: authors)
                })
            ])
            return cell
        }
        return Common.createDummyCellWith(title: "Cell for streamCard type: app")
    }
    
    private func createArticleCell(tableView: UITableView, article: Article, row: Int) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.postCardMultiImagesCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? PostCardMultiImagesTableViewCell else {
                 return Common.createDummyCellWith(title: "Cell for streamCard type: article")
            }
        cell.bindData(feed: article, accentColor: delegate?.getAccentColor())
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didSelectImageAtIndex.subscribe(onNext: {  [unowned self] _ in
                self.navigateToContentPage(feed: article)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: article)
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: article)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: article)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: article, isShowComment: true)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.delegate?.getURLFromObjAndShare(obj: data)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: article)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: article)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.delegate?.navigateToTaggedPageListing(authors: authors)
            })
        ])
        cell.indexRow = row
        return cell
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func createPostCell(tableView: UITableView, post: Post, indexPath: IndexPath) -> UITableViewCell {
        if let subTypeStr = post.subType, let subType = FeedSubType(rawValue: subTypeStr) {
            switch subType {
                
            case .text:
                if let cell = postTextCellFor(tableView: tableView, post: post) {
                    cell.indexRow = indexPath.row
                    return cell
                }
            case .image:
                if let cell = postImageCellFor(tableView: tableView, post: post) {
                    cell.indexRow = indexPath.row
                    return cell
                }
            case .video:
                if let cell = postVideoCellFor(tableView: tableView, post: post) {
                    cell.indexRow = indexPath.row
                    return cell
                }
            case .embed:
                if let cell = postEmbedCellFor(tableView: tableView, post: post) {
                    cell.indexRow = indexPath.row
                    return cell
                }
            case .episode:
                if let cell = postEpisodeCellFor(tableView: tableView, post: post) {
                    cell.indexRow = indexPath.row
                    return cell
                }
            }
        }
        return createDummyCell(tableView: tableView, indexPath: indexPath)
    }
    
    private func bannerAdsCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.bannerAdsViewCell.identifier) as? BannerAdsViewCell else { return UITableViewCell() }
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath], let parentVC = tableView.viewController {
				ads.requestAds(adsType: .banner, viewController: parentVC, universalUrl: universalUrl)
				ads.disposeBag.addDisposables([
					ads.loadAdSuccess.subscribe(onNext: { [unowned self] row in
						if let index = row { self.delegate?.reloadCell(at: index) }
                    }),

                    ads.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                        self?.delegate?.openInAppBrowser(url: URL(string: urlString)!)
                    })
				])
			}
		}
        return cell
    }
    
    private func postTextCellFor(tableView: UITableView, post: Post) -> CardTextCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.cardTextCellId.identifier) as? CardTextCell else { return nil }
        
        cell.bindData(post: post, accentColor: delegate?.getAccentColor())
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post, isShowComment: true)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.delegate?.getURLFromObjAndShare(obj: data)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.delegate?.navigateToTaggedPageListing(authors: authors)
            })
        ])
        return cell
    }
    
    private func postImageCellFor(tableView: UITableView, post: Post) -> PostCardMultiImagesTableViewCell? {
        let identifier = IPad.CellIdentifier.postCardMultiImagesCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? PostCardMultiImagesTableViewCell else { return nil }
        
        cell.bindData(feed: post, accentColor: delegate?.getAccentColor())
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didSelectImageAtIndex.subscribe(onNext: { [unowned self] imageIndex, idImage in
                guard let pageId = self.delegate?.getPageId() else { return }
                self.showFullscreenImage(post, pageId: pageId, imageIndex: imageIndex, imageId: idImage)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                guard let pageId = self.delegate?.getPageId() else { return }
                self.showFullscreenImage(post, pageId: pageId)
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                guard let pageId = self.delegate?.getPageId() else { return }
                self.showFullscreenImage(post, pageId: pageId, imageIndex: 0)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.delegate?.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post, isShowComment: true)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.delegate?.navigateToTaggedPageListing(authors: authors)
            })
        ])
        return cell
    }
    
    private func postVideoCellFor(tableView: UITableView, post: Post) -> PostCardMultiImagesTableViewCell? {
        let identifier = IPad.CellIdentifier.postCardMultiImagesCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? PostCardMultiImagesTableViewCell else { return nil }
        
        cell.bindData(feed: post, accentColor: delegate?.getAccentColor())
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post, isShowComment: false, cell: cell)
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToVideoPlaylist(feed: post)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post, isShowComment: true, cell: cell)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToVideoPlaylist(feed: post)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.delegate?.getURLFromObjAndShare(obj: data)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.delegate?.navigateToTaggedPageListing(authors: authors)
            }),
            cell.videoPlayerTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToVideoPlaylist(feed: post)
            })
        ])
        
        return cell
    }
    
    private func postEmbedCellFor(tableView: UITableView, post: Post) -> EmbeddedCardCell? {
        let identifier = IPad.CellIdentifier.embeddedCardCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? EmbeddedCardCell
            else { return nil }
        
        cell.bindData(post: post, accentColor: delegate?.getAccentColor())
        cell.disposeBag.addDisposables([
            cell.expandedText.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didUpdateWebView.subscribe(onNext: { [unowned self] _ in
                self.delegate?.reloadCell()
            }),
            cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.delegate?.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post, isShowComment: true)
            }),
            cell.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.delegate?.openInAppBrowser(url: url)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.delegate?.navigateToTaggedPageListing(authors: authors)
            })
        ])
        
        return cell
    }
    
    private func postEpisodeCellFor(tableView: UITableView, post: Post) -> EpisodeCell? {
        let identifier = IPad.CellIdentifier.episodeCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            identifier) as? EpisodeCell else { return nil }
        
        cell.bindData(post: post, accentColor: delegate?.getAccentColor(), season: delegate?.getSeasonMetadata(),
                      genre: delegate?.getGenreMetadata())
        cell.disposeBag.addDisposables([
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.delegate?.getURLFromObjAndShare(obj: data)
            }),
            cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post, isShowComment: true, cell: cell)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                self.navigateToContentPage(feed: post)
            }),
            cell.onStartInAppBrowser.subscribe(onNext: { [unowned self] url in
                self.delegate?.openInAppBrowser(url: url)
                //self.test(url: url)
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.delegate?.navigateToPageDetail(feed: post)
            }),
            cell.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                self.delegate?.navigateToTaggedPageListing(authors: authors)
            })
        ])
        return cell
    }
    
    private func bundleCarouselCell(tableView: UITableView, bundles: [BundleContent]) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.pageBundleCarouselCell.identifier) as? PageBundleCarouselCell
            else { return UITableViewCell() }
        cell.bindData(bundles: bundles, accentColor: delegate?.getAccentColor())
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, _ in
                self.navigateToContentPage(feed: feed)
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, _ in
                self.navigateToContentPage(feed: feed)
            })
        ])
        return cell
    }
    
    private func createDummyCell(tableView: UITableView, itemList: ItemList? = nil, indexPath: IndexPath)
							-> UITableViewCell {
        var dummyType: String? = "Invalid"
        if let itemList = itemList,
            let nsType = itemList.list.count > indexPath.row ? itemList.list[indexPath.row] : nil {
            dummyType = (nsType as? Feed)?.type
            if (nsType as? Feed)?.type == CampaignType.ads.rawValue {
				return bannerAdsCell(tableView: tableView, indexPath: indexPath)
            }
        }
        return Common.createDummyCellWith(title: "Cell of type: \(String(describing: dummyType))")
    }
    
    private func showFullscreenImage(_ feed: Feed, pageId: String = "", imageIndex: Int = 0, imageId: String = "") {
        delegate?.showFullscreenImage(feed, pageId: pageId, imageIndex: imageIndex, imageId: imageId)
    }
    
    private func pushAppWhitePage(app: App) {
        delegate?.pushAppWhitePage(app: app)
    }
    
    private func navigateToContentPage(feed: Feed, isShowComment: Bool = false, cell: UITableViewCell? = nil) {
        delegate?.navigateToContentPage(feed: feed, isShowComment: isShowComment, cell: cell)
    }
    
}
