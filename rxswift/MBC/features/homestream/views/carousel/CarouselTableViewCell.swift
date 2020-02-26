//
//  CarouselTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/20/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import iCarousel
import MisterFusion
import UIKit
import RxSwift

class CarouselTableViewCell: BaseCampaignTableViewCell {

	@IBOutlet weak private var collectionView: UICollectionView!
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var constraintHeightOfcollectionView: NSLayoutConstraint!
	private var widthOfItemView: CGFloat = 0
	private var heightOfItemView: CGFloat = 0
	private var campaign: Campaign!
	private var feeds: [Feed] = []
    private var accentColor: UIColor?
    var numberOfItemsPerSection: Int = 0
    private var info: InfoComponent?
	
	private var widthOfPageItem: CGFloat = 107
	private var heightOfPageItem: CGFloat = 239 //296
	
	private var widthOfPostItem: CGFloat = 228
	private var heightOfPostItem: CGFloat = 230
	
    private var widthtOfAppItem: CGFloat = 107
	private var heightOfAppItem: CGFloat = 220
	
    private var widthtOfBundleItem: CGFloat = 107
    private var heightOfBundleItem: CGFloat = Constants.Singleton.isiPad ? 195 : 175
    
    private var widthtOfBundleItemOnPageStream: CGFloat = 107
    private var heightOfBundleItemOnPageStream: CGFloat = 169
    
    private var widthOfPlaylistItem: CGFloat = 228
    private var heightOfPlaylistItem: CGFloat = Constants.Singleton.isiPad ? 236 : 226
    
    private var infinityNumber: Int = Constants.DefaultValue.infinityNumber
    private var maximumInfinityNumber: Int = Constants.DefaultValue.maximumInfinityNumber
    private var lastIndex: CGFloat = 0
    private var itemViewTag: Int = 1
    private var isOnPageStream = false
    private var isBundleCell = false
    
    var thumbnailTapped = PublishSubject<(Feed, Int)>()
    var titleTapped = PublishSubject<(Feed, Int)>()
    var authorNameTapped = PublishSubject<Feed>()
    var numberOfVideoTapped = PublishSubject<Feed>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(R.nib.pageCarouselItemView(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.pageCarouselItemView.identifier)
        collectionView.register(R.nib.postCarouselItemView(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.postCarouselItemView.identifier)
        collectionView.register(R.nib.appCarouselItemView(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.appCarouselItemView.identifier)
        collectionView.register(R.nib.bundleCarouselCollectionViewCell(),
                    forCellWithReuseIdentifier: R.reuseIdentifier.bundleCarouselCollectionViewCell.identifier)
        collectionView.register(R.nib.playlistCarouselCollectionViewCell(),
                    forCellWithReuseIdentifier: R.reuseIdentifier.playlistCarouselCollectionViewCell.identifier)
        collectionView.register(R.nib.playlistCarouselCollectionViewCell(),
                    forCellWithReuseIdentifier: R.reuseIdentifier.playlistCarouselCollectionViewCell.identifier)
        collectionView.register(R.nib.pageBundleCarouselCollectionViewCell(),
                    forCellWithReuseIdentifier: R.reuseIdentifier.pageBundleCarouselCollectionViewCell.identifier)
        collectionView.isPagingEnabled = false
    }
    
    func getCollectionView() -> UICollectionView {
        return collectionView
    }

	func bindData(_ campaign: Campaign) {
		self.campaign = campaign
        feeds = filterInvalidItemsFrom(campaign.items)
        sortDefaultItem()
        setTitle(title: campaign.title ?? "")
		setupCollectionView()
	}
    
    func bindData(bundles: [BundleContent], accentColor: UIColor?) {
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        isOnPageStream = true
        feeds = bundles
        setupCollectionView()
    }
    
    func bindData(info: InfoComponent, languageConfigList: [LanguageConfigListEntity]?) {
        self.info = info
        setTitle(title: info.title)
        
//        feeds = .... from info components
        feeds = []
        if let components = info.infoComponentElements {
            for comp in components {
                let linkedPage = comp.linkedPage
                linkedPage.pageType = info.type.rawValue
                linkedPage.uuid = comp.linkedPageEntityId
                linkedPage.infoComponentValue = buildMetadataStringFrom(comp: comp,
                                                                        languageConfigList: languageConfigList)
                feeds.append(linkedPage)
            }
        }
        setupCollectionView()
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func buildMetadataStringFrom(comp: InfoComponentElement,
                                         languageConfigList: [LanguageConfigListEntity]?) -> String {
        var metaDataValue = ""
        let displayName = comp.linkedCharacterPage?.displayName ?? ""
        let linkedValues = comp.linkedValue?.metadata
            .map({ String($0.name) })
            .joined(separator: Constants.DefaultValue.MetadataLinkedValueSeparatorString) ?? ""
        
        if let linkedType = LinkedTypeEnum(rawValue: comp.linkedType) {
            switch linkedType {
            case .etablishYear:
                if !linkedValues.isEmpty {
                    let date = Date.dateFromString(string: linkedValues,
                                                   format: Constants.DateFormater.StandardWithMilisecond)
                    metaDataValue = date.toDateString(format: Constants.DateFormater.BirthDay)
                }
            case .character:
                metaDataValue = !displayName.isEmpty ? R.string.localizable.abouttabIcCharacter(displayName) : ""
            case .dob:
                metaDataValue = linkedValues
            case .horoscope:
                metaDataValue = !linkedValues.isEmpty ? R.string.localizable.abouttabIcHoroscope(linkedValues) : ""
            case .nationality:
                metaDataValue = !linkedValues.isEmpty ? R.string.localizable.abouttabIcNationality(linkedValues) : ""
            case .seasonNumber:
                metaDataValue = !linkedValues.isEmpty ? R.string.localizable.abouttabIcSeasonNumber(linkedValues) : ""
            case .sequelNumber:
                metaDataValue = !linkedValues.isEmpty ? R.string.localizable.abouttabIcSequelNumber(linkedValues) : ""
            case .genre:
                return getLocalizedValues(linkedValue: comp.linkedValue, languageConfigList: languageConfigList,
                                          type: Constants.ConfigurationDataType.genres)
            case .subGenre:
                return getLocalizedValues(linkedValue: comp.linkedValue, languageConfigList: languageConfigList,
                                          type: Constants.ConfigurationDataType.subgenres)
            case .occupation, .occupations:
                return getLocalizedValues(linkedValue: comp.linkedValue, languageConfigList: languageConfigList,
                                          type: Constants.ConfigurationDataType.occupations)
            default:
                metaDataValue = linkedValues
            }
        } else {
            metaDataValue = linkedValues
        }
        
        return metaDataValue
    }
    
    private func getLocalizedValues(linkedValue: LinkedValue?,
                                    languageConfigList: [LanguageConfigListEntity]?,
                                    type: String) -> String {
        guard let languageConfigList = languageConfigList, let linkedValue = linkedValue else {
            return ""
        }
        var localizedValues = [String]()
        for value in linkedValue.metadata {
            if let localizedString = value.code.getLocalizedString(languageConfigList: languageConfigList,
                                                                   type: type) {
                localizedValues.append(localizedString)
            }
        }
        return localizedValues.joined(separator: Constants.DefaultValue.MetadataLinkedValueSeparatorString)
    }

    private func setTitle(title: String) {
        if let titleLabel = titleLabel {
            titleLabel.text = title
        }
	}
	
	private func setupCollectionView() {
        widthOfItemView = getWidthForFisrtItem()
        heightOfItemView = getHeightForFisrtItem()
        if Constants.DefaultValue.shouldRightToLeft {
            collectionView.semanticContentAttribute = .forceRightToLeft
        }
        numberOfItemsPerSection = shoulEnableInfinityScrolling() ? infinityNumber : feeds.count
		constraintHeightOfcollectionView.constant = heightOfItemView
        collectionView.reloadData()
	}
    
    private func shoulEnableInfinityScrolling() -> Bool {
        let totalW = CGFloat(feeds.count) * widthOfItemView
        return totalW > Constants.DeviceMetric.screenWidth
    }
	
	private func getWidthForFisrtItem() -> CGFloat {

        guard let firstItem = feeds.first else { return 0 }
        if firstItem is Post { return widthOfPostItem }
        if firstItem is Article { return widthOfPostItem }
        if firstItem is Page { return widthOfPageItem }
        if firstItem is App { return widthtOfAppItem }
        if firstItem is BundleContent {
            if firstItem is Playlist { return widthOfPlaylistItem }
            return isOnPageStream ? widthtOfBundleItemOnPageStream : widthtOfBundleItem
        }
        guard let info = info?.infoComponentElements else { return 0 }
        if !info.isEmpty { return widthOfPageItem }
        return 0
	}
	
	private func getHeightForFisrtItem() -> CGFloat {
        guard !feeds.isEmpty else { return 0 }
        if feeds.first! is Post || feeds.first! is Article { return heightOfPostItem }
        if feeds.first! is Page { return heightOfPageItem }
        if feeds.first! is App { return heightOfAppItem }
        if feeds.first! is BundleContent {
            if feeds.first! is Playlist { return heightOfPlaylistItem }
            return isOnPageStream ? heightOfBundleItemOnPageStream : heightOfBundleItem
        }
        guard let info = info?.infoComponentElements else { return 0 }
        if !info.isEmpty { return widthOfPageItem }
        return 0
	}

	private func filterInvalidItemsFrom(_ items: [Feed]) -> [Feed] {
		return items.filter {
			if $0 is Post, let images = ($0 as? Post)?.medias, images.first != nil { return true }
			if $0 is Article, ($0 as? Article)?.photo != nil { return true }
            if $0 is App, ($0 as? App)?.photo != nil { return true }
            if $0 is BundleContent { return true }
            if $0 is Playlist { return true }
			return true
		}
	}
	
    private func sortDefaultItem() {
        guard feeds.count > 1, let firstPost = (feeds.first as? Post) else { return }
        guard let defaultImageId = firstPost.defaultImageId else { return }
       
        let index = feeds.index(where: { postItem -> Bool in
            (postItem as? Post)?.medias?.first?.id == defaultImageId
        })
        guard let indexOfdefaultImage = index else { return }
        let media = feeds.remove(at: indexOfdefaultImage)
        feeds.insert(media, at: 0)
    }
    
    // MARK: - Create cell methods
    
    private func pageBundleCellAtIndexPath(_ indexPath: IndexPath, feed: Feed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.pageBundleCarouselCollectionViewCell.identifier, for: indexPath)
            as? PageBundleCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(feed, accentColor: accentColor)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.thumbnailTapped.onNext((feed, defaultImageIndex))
                for item in self.feeds {
                    if let bundle = item as? BundleContent {
                        bundle.ishighlighted = false
                    }
                }
                if let bundle = feed as? BundleContent {
                    bundle.ishighlighted = true
                }
                self.highlighBundleCell()
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.titleTapped.onNext((feed, defaultImageIndex))
            })
        ])
        return cell
    }
    
    private func playlistCellAtIndexPath(_ indexPath: IndexPath, feed: Feed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.playlistCarouselCollectionViewCell.identifier, for: indexPath)
            as? PlaylistCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(feed, accentColor: accentColor)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                if let playlist = feed as? Playlist, let item = playlist.items.first {
                    self.thumbnailTapped.onNext((item, defaultImageIndex))
                }
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                if let playlist = feed as? Playlist, let item = playlist.items.first {
                    self.titleTapped.onNext((item, defaultImageIndex))
                }
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self]  in
                self.authorNameTapped.onNext(feed)
            }),
            cell.numberOfVideoTapped.subscribe(onNext: { [unowned self] in
                if let playlist = feed as? Playlist, let item = playlist.items.first {
                    self.numberOfVideoTapped.onNext(item)
                }
            })
        ])
        return cell
    }
    
    private func bundleCellAtIndexPath(_ indexPath: IndexPath, feed: Feed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.bundleCarouselCollectionViewCell.identifier, for: indexPath)
            as? BundleCarouselCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(feed, accentColor: accentColor)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.thumbnailTapped.onNext((feed, defaultImageIndex))
                for item in self.feeds {
                    if let bundle = item as? BundleContent {
                        bundle.ishighlighted = false
                    }
                }
                if let bundle = feed as? BundleContent {
                    bundle.ishighlighted = true
                }
                self.highlighBundleCell()
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.titleTapped.onNext((feed, defaultImageIndex))
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self]  in
                self.authorNameTapped.onNext(feed)
            })
        ])
        return cell
    }
    
    private func postOrArticleCellAtIndexPath(_ indexPath: IndexPath, feed: Feed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.postCarouselItemView.identifier, for: indexPath)
            as? PostCarouselItemView else { return UICollectionViewCell() }
        cell.bindData(feed)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.thumbnailTapped.onNext((feed, defaultImageIndex))
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.titleTapped.onNext((feed, defaultImageIndex))
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.authorNameTapped.onNext(feed)
            })
        ])
        return cell
    }
    
    private func pageCellAtIndexPath(_ indexPath: IndexPath, feed: Feed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.pageCarouselItemView.identifier, for: indexPath)
            as? PageCarouselItemView else { return UICollectionViewCell() }
        var willShowMetadata = true
        if let info = self.info {
            willShowMetadata = info.showCurrentPageMetadata
        }
        cell.bindData(feed, isInfoComponent: (self.info != nil), willShowMetadata: willShowMetadata)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.thumbnailTapped.onNext((feed, defaultImageIndex))
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.titleTapped.onNext((feed, defaultImageIndex))
            })
        ])
        return cell
    }
    
    private func appCellAtIndexPath(_ indexPath: IndexPath, feed: Feed) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.appCarouselItemView.identifier, for: indexPath)
            as? AppCarouselItemView else { return UICollectionViewCell() }
        cell.bindData(feed)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.thumbnailTapped.onNext((feed, defaultImageIndex))
            }),
            cell.titleTapped.subscribe(onNext: { [unowned self] feed, defaultImageIndex in
                self.titleTapped.onNext((feed, defaultImageIndex))
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self]  in
                self.authorNameTapped.onNext(feed)
            })
        ])
        return cell
    }
    
    // MARK: - Load collection cells
    
	private func cellAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
        var index = indexPath.row
        if index >= feeds.count { index = index % feeds.count }
        let feed = feeds[index]
        
        if feed is Post || feed is Article {
            return postOrArticleCellAtIndexPath(indexPath, feed: feed)
        }
        if feed is Page {
            return pageCellAtIndexPath(indexPath, feed: feed)
        }
        if feed is App {
            return appCellAtIndexPath(indexPath, feed: feed)
        }
        if feed is BundleContent {
            if isOnPageStream {
                return pageBundleCellAtIndexPath(indexPath, feed: feed)
            }
            
            if feed is Playlist {
                return playlistCellAtIndexPath(indexPath, feed: feed)
            }
            
            return bundleCellAtIndexPath(indexPath, feed: feed)
        }
        return UICollectionViewCell()
	}
    
    private func highlighBundleCell() {
        for cell in self.collectionView.visibleCells {
            if let bundleCell = cell as? BundleCarouselCollectionViewCell {
                bundleCell.highligh()
            }
        }
    }
}

extension CarouselTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOfItemView, height: heightOfItemView )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.DefaultValue.defaultMargin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.DefaultValue.defaultMargin,
                            bottom: 0, right: Constants.DefaultValue.defaultMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellAtIndexPath(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentW = scrollView.contentSize.width
        if offsetX > contentW - scrollView.frame.size.width && numberOfItemsPerSection < maximumInfinityNumber {
            numberOfItemsPerSection += numberOfItemsPerSection
            self.collectionView.reloadData()
        }
        highlighBundleCell()
    }
}
