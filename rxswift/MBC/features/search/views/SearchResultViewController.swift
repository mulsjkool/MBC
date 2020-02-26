//
//  SearchViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import MisterFusion
import RxSwift

class SearchResultViewController: HomeStreamViewController {

	@IBOutlet weak private var searchMenu: SearchMenu!
	
	private var searchBarContainer: SearchBarContainerView!
	private var searchBar: BaseSearchBar = BaseSearchBar()
	private let searchEmptyView: SearchResultEmpty = SearchResultEmpty()
	private let interactor = Components.homeStreamInteractor()
	private var isFirstLoadSearchResultMenu: Bool = true
	
	var keyword: String = ""
	
	var onClearButtonClicked = PublishSubject<Void>()
	var onDidCancelSearching = PublishSubject<Void>()
	
	// MARK: - Life method
	override func viewDidLoad() {
		interactor.setForSearchResult(keyword: keyword, searchType: .all, hasStatistic: true)
        viewModel = HomeStreamViewModel(interactor: interactor, socialService: Components.userSocialService)
		viewModel.loadLanguageConfigs()
        
        super.viewDidLoad()
		
		setupUI()
		bindEvents()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.hidesBackButton = true
	}
	
	override func setupUI() {
		addTableView()
		registerCell()
		addSearchBar()
		updateUIForSearchResult()
		view.bringSubview(toFront: searchMenu)
        searchMenu.isHidden = true
	}
	
	// MARK: - Private method
	private func bindEvents() {
		disposeBag.addDisposables([
			searchMenu.onSelectedSearchMenuItem.subscribe(onNext: { [unowned self] item in
				self.interactor.setForSearchResult(keyword: self.keyword, searchType: item, hasStatistic: false)
				self.viewModel.refreshItems()
			})
		])
	}
	
	private func showSearchEmptyView() {
		searchMenu.isHidden = true
		searchEmptyView.notFoundSearch(keyword)
		view.addSubview(searchEmptyView)
		searchEmptyView.translatesAutoresizingMaskIntoConstraints = false
		view.mf.addConstraints([
			view.top |==| searchEmptyView.top,
			view.left |==| searchEmptyView.left,
			view.bottom |==| searchEmptyView.bottom,
			view.right |==| searchEmptyView.right
		])
	}
	
	private func addSearchBar() {
        searchBar.isEditing = true
		searchBarContainer = Common.setupSearchBar(searchBar: searchBar, navigationItem: navigationItem)
		searchBarContainer.setSearchText(text: keyword)
		
		disposeBag.addDisposables([
			searchBarContainer.onShouldBeginSearching.subscribe(onNext: { [unowned self] _ in
                self.backSearchSuggestion(keyword: self.keyword)
			}),
			searchBarContainer.onTextDidChangeSearching.subscribe(onNext: { text in
				self.backSearchSuggestion(keyword: text)
			}),
			searchBarContainer.onDidCancelSearching.subscribe(onNext: { [unowned self] _ in
				self.cancelSearching()
			})
		])
	}
	
	private func updateUIForSearchResult() {
		searchMenu.updateStatisticSearch(data: SearchItemEnum.allItems)
		streamTableView.backgroundColor = Colors.defaultBg.color()
		streamTableView.contentInset = UIEdgeInsets(top: Constants.DefaultValue.tableSearchTopMargin,
													left: 0, bottom: 0, right: 0)
	}
	
	private func registerCell() {
		streamTableView.register(R.nib.starPageListingCell(),
								 forCellReuseIdentifier: R.reuseIdentifier.starPageListingCellId.identifier)
		streamTableView.register(R.nib.bundleSearchResultCell(),
								 forCellReuseIdentifier: R.reuseIdentifier.bundleSearchResultCell.identifier)
        streamTableView.register(R.nib.playlistSearchResultCell(),
                                 forCellReuseIdentifier: R.reuseIdentifier.playlistSearchResultCell.identifier)
	}
	
	private func backSearchSuggestion(keyword: String) {
		if keyword.isEmpty { self.onClearButtonClicked.onNext(()) }
		navigationController?.popViewController(animated: false)
	}
	
	private func cancelSearching() {
		onDidCancelSearching.onNext(())
		navigationController?.popViewController(animated: false)
	}
	
	private func streamCardPageCell(_ page: Page) -> UITableViewCell {
		if let cell = streamTableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.starPageListingCellId.identifier) as? StarPageListingCell {
            let star = Star(entity: page)
            star.metadata = viewModel.metadataForSearchPage(page)
			cell.bindData(star: Star(entity: page), isSearchingPage: true)
			return cell
		}
		return createDummyCellWith(title: "Cell for StreamCard type: Page Search")
	}
	
	private func streamCardAppCell(_ app: App) -> UITableViewCell {
        let identifier = IPad.CellIdentifier.appCardTableViewCell
		if let cell = streamTableView.dequeueReusableCell(withIdentifier: identifier)
			as? AppCardTableViewCell {
			cell.bindData(feed: app, accentColor: nil)
			cell.disposeBag.addDisposables([
				cell.expandedText.subscribe(onNext: { [unowned self] _ in
					self.reloadCell()
				}),
				cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
					self.reloadCell()
				}),
				cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
					self.navigateToContentPage(feed: app)
				}),
				cell.didTapTitle.subscribe(onNext: { [unowned self] app in
					self.navigator?.pushAppWhitePage(app: app)
				}),
				cell.didTapAppPhoto.subscribe(onNext: { [unowned self] app in
					self.navigator?.pushAppWhitePage(app: app)
				}),
				cell.shareTapped.subscribe(onNext: { [unowned self] data in
					self.getURLFromObjAndShare(obj: data)
				}),
				cell.commentTapped.subscribe(onNext: { [unowned self] data in
					if let app = data as? App { self.navigator?.pushAppWhitePage(app: app) }
				}),
				cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
					self.navigator?.pushAppWhitePage(app: app)
				})
			])
			return cell
		}
		return Common.createDummyCellWith(title: "Cell for streamCard type: app")
	}
	
	private func bundleSearchResultCell(_ bundleContent: Feed) -> UITableViewCell {
		if let cell = streamTableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.bundleSearchResultCell.identifier) as? BundleSearchResultCell {
			cell.bindData(bundle: bundleContent)
			return cell
		}
		return createDummyCellWith(title: "Cell for StreamCard type: Bundle Search")
	}
    
    private func playlistSearchResultCell(_ playList: Playlist) -> UITableViewCell {
        if let cell = streamTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.playlistSearchResultCell.identifier) as? PlaylistSearchResultCell {
            cell.bindData(data: playList)
            return cell
        }
        return createDummyCellWith(title: "Cell for StreamCard type: Bundle Search")
    }
	
	// MARK: - Override method
	override func loadDataItems() {
		super.loadDataItems()
		guard let statistic = viewModel.statistic else { return }
        
		if searchMenu.currentMenuItem == .all && isFirstLoadSearchResultMenu {
			if statistic.numberOfGeneralContents == 0 { showSearchEmptyView(); return }
            searchMenu.isHidden = false
			searchMenu.updateStatisticSearch(data: statistic.convertToSearchMenuItem())
			isFirstLoadSearchResultMenu = false
		}
	}
	
	override func showError() {
		super.showError()
		showSearchEmptyView()
	}
	
	// do not hide navigation bar while scrolling tableview
	override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
								   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
	}
	
	override func streamCardCellFor(_ item: Campaign, row: Int, highlight keyword: String = "") -> UITableViewCell {
		if let card = item.items.first as? Page, searchMenu.currentMenuItem == .pages { return streamCardPageCell(card) }
		if let card = item.items.first as? App, FeedType(rawValue: card.type) == .app { return streamCardAppCell(card) }
		return super.streamCardCellFor(item, row: row, highlight: self.keyword)
	}
	
	override func createSingleItemCell(campaign: Campaign, row: Int) -> UITableViewCell {
		if let card = campaign.items.first, searchMenu.currentMenuItem == .bundle { return bundleSearchResultCell(card) }
		if let card = campaign.items.first as? Playlist, searchMenu.currentMenuItem == .playlist {
			return playlistSearchResultCell(card)
		}
		return super.createSingleItemCell(campaign: campaign, row: row)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if searchMenu.currentMenuItem == .pages { return Constants.DefaultValue.starListingHeightCell }
		if searchMenu.currentMenuItem == .bundle { return Constants.DefaultValue.bundleSearchHeightCell }
        if searchMenu.currentMenuItem == .playlist {
            return (Constants.DeviceMetric.screenWidth - Constants.DefaultValue.defaultMargin)
                * Constants.DefaultValue.ratio9H16W + Constants.DefaultValue.playlistSearchResultMargin
        }
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard viewModel.itemsList.count > indexPath.row else { return }
		
        let campain = viewModel.itemsList[indexPath.row]
        if let card = campain.items.first as? Page, searchMenu.currentMenuItem == .pages {
            navigator?.navigateToContentPage(feed: card)
        }
        if let card = campain.items.first as? Playlist, searchMenu.currentMenuItem == .playlist {
            navigator?.pushVideoPlaylistFrom(playlistId: card.contentId!, title: card.title)
        }
        if let card = campain.items.first as? BundleContent, searchMenu.currentMenuItem == .bundle {
            navigator?.navigateToContentPage(feed: card)
        }
		super.tableView(tableView, didSelectRowAt: indexPath)
	}
}
