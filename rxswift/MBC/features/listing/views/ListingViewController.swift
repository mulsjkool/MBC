//
//  ListingViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/14/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion

class ListingViewController: BaseViewController {

    @IBOutlet weak private var listingContainView: UIView!
    @IBOutlet weak private var listingTableView: UITableView!
    @IBOutlet weak private var filterView: UIView!
    @IBOutlet weak private var filterContainView: UIView!
    @IBOutlet weak private var filter1ArrowImageView: UIImageView!
    @IBOutlet weak private var filter1Button: UIButton!
    @IBOutlet weak private var filter2ArrowImageView: UIImageView!
    @IBOutlet weak private var filter2Button: UIButton!
    @IBOutlet weak private var filter3ArrowImageView: UIImageView!
    @IBOutlet weak private var filter3Button: UIButton!
    
    private var filterTableViewHeightConstraint: NSLayoutConstraint!
    private var filterTableView: ListingFilterTableViewController!
    private var isLoadingData = false
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListingViewController.refreshData(_:)), for:
            UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    var listingType: ListingType = .showAndProgram { didSet { viewModel.listingType = listingType } }
    private var viewModel = ListingViewModel(interactor: Components.listingInteractor(),
                                             languageConfigService: Components.languageConfigService)
    
    private var isMoreDataAvailable: Bool = false
    private var dataReadyForStream = false
    
    private let headerHeight: CGFloat = 52.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.listingType == .showAndProgram {
            self.navigator = Navigator(navigationController: self.navigationController)
        }

        addBackButton()
        setupUI()
        bindEvents()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.resetVideoPlayingStatusFor(table: listingTableView)
        updateGifAnimation()
    }
    
    // MARK: Private functions
    
    private func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.startLoadingData()
        })
    }
    
    private func setupUI() {
        addTableView()
        addRefreshControl()
        resetFilterTitles()
        switch viewModel.listingType {
        case .appAndGame:
            title = ""
        case .star:
            title = R.string.localizable.starPageListingTitle()
        case .showAndProgram:
            title = ""
            //title = R.string.localizable.showListingTitle()
        }
        filter1Button.titleLabel?.lineBreakMode = .byTruncatingTail
        filter2Button.titleLabel?.lineBreakMode = .byTruncatingTail
        filter3Button.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    private func resetFilterTitles() {
        switch viewModel.listingType {
        case .appAndGame:
            filter1Button.setTitle(R.string.localizable.appListingFilterByAppType(), for: .normal)
            filter2Button.setTitle(R.string.localizable.appListingFilterByAuthor(), for: .normal)
            filter3Button.setTitle(R.string.localizable.commonSortingTitle(), for: .normal)
            title = R.string.localizable.sidemenuStaticPageTitleAppsGames()
        case .star:
            filter1Button.setTitle(R.string.localizable.starPageListingFilterByMonthOfBirth(), for: .normal)
            filter2Button.setTitle(R.string.localizable.starPageListingFilterByOccupation(), for: .normal)
            filter3Button.setTitle(R.string.localizable.commonSortingTitle(), for: .normal)
            title = R.string.localizable.starPageListingTitle()
        case .showAndProgram:
            filter1Button.setTitle(R.string.localizable.showListingFilterBySubType(), for: .normal)
            filter2Button.setTitle(R.string.localizable.showListingFilterByGenre(), for: .normal)
            filter3Button.setTitle(R.string.localizable.commonSortingTitle(), for: .normal)
        }
    }
    
    private func addTableView() {
        filterTableView = ListingFilterTableViewController()
        addChildViewController(filterTableView)
        filterTableView.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        filterContainView.addSubview(filterTableView.tableView)
        self.view.bringSubview(toFront: filterContainView)
        filterTableView.didMove(toParentViewController: self)
        filterTableView.setupUI()
        filterTableView.tableView.translatesAutoresizingMaskIntoConstraints = false
        filterContainView.mf.addConstraints(
            filterTableView.tableView.top |==| filterContainView.top,
            filterTableView.tableView.left |==| filterContainView.left,
            filterTableView.tableView.right |==| filterContainView.right
        )
        filterTableViewHeightConstraint = filterContainView.mf.addConstraint(filterTableView.tableView.height
            |==| 0)
        filterContainView.alpha = 0.0
        
        listingTableView.separatorStyle = .none
        listingTableView.allowsSelection = true
        listingTableView.dataSource = self
        listingTableView.delegate = self
        listingTableView.backgroundColor = Colors.defaultBg.color()
        listingTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        listingTableView.showsVerticalScrollIndicator = false
        listingTableView.showsHorizontalScrollIndicator = false
        listingTableView.register(R.nib.starPageListingCell(),
                                 forCellReuseIdentifier: R.reuseIdentifier.starPageListingCellId.identifier)
        listingTableView.register(R.nib.appListingCell(),
                                     forCellReuseIdentifier: R.reuseIdentifier.appListingCell.identifier)
        listingTableView.register(R.nib.showListingCell(),
                                  forCellReuseIdentifier: R.reuseIdentifier.showListingCell.identifier)
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            filter1Button.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.handleFilterButtonPressed(filterMode: .filter1)
            }),
            filter2Button.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.handleFilterButtonPressed(filterMode: .filter2)
            }),
            filter3Button.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.handleFilterButtonPressed(filterMode: .filter3)
            }),
            filterTableView.viewModel.onWillReload.subscribe(onNext: { [weak self] _ in
                self?.updateFiltersText()
                self?.configureFilterView()
                self?.refreshData()
            }),
            viewModel.onWillStopGetFilterContent.subscribe(onNext: { [weak self] _ in
                self?.filterTableView.viewModel.filter = self?.viewModel.filter
            }),
            viewModel.onWillStartGetListItem.subscribe({ [unowned self] _ in
                self.isMoreDataAvailable = true
            }),
            viewModel.onWillStopGetListItem.subscribe(onNext: { [unowned self] _ in
                self.isLoadingData = false
                self.refreshControl.endRefreshing()
                self.dataReadyForStream = true
                self.updateContent()
            }),
            viewModel.onFinishGetListItem.subscribe(onNext: { [unowned self] in
                self.refreshControl.endRefreshing()
                self.isMoreDataAvailable = false
                self.updateContent()
            }),
            viewModel.onDidGetError.subscribe(onNext: { [weak self] _ in
                self?.isLoadingData = false
                self?.isMoreDataAvailable = false
                self?.dataReadyForStream = true
                self?.updateContent()
                self?.showMessage(message: R.string.localizable.errorServerError().localized())
            })
        ])
    }
    
    private func handleFilterButtonPressed(filterMode: FilterMode) {
        viewModel.filter?.activeFilterMode = (viewModel.filter?.activeFilterMode == filterMode) ? .none : filterMode
        self.configureFilterView()
    }
    
    private func addRefreshControl() {
        if refreshControl.superview == nil {
            listingTableView.addSubview(refreshControl)
        }
    }
    
    @objc
    private func refreshData(_ refreshControl: UIRefreshControl) {
        refreshToDefaultFilter()
    }
    
    private func refreshToDefaultFilter() {
        isMoreDataAvailable = false
        viewModel.refreshItemsAndFilterContent()
        resetFilterTitles()
        configureFilterView()
    }
    
    private func refreshData() {
        isMoreDataAvailable = false
        viewModel.refreshItems()
    }
    
    private func updateContent() {
        listingTableView.reloadData()
    }
    
    private func loadMoreData() {
        viewModel.loadItems()
    }
    
    private func createLoadMoreCell(_ indexPath: IndexPath) -> UITableViewCell? {
        if indexPath.row < viewModel.itemsList.count ||
            !isMoreDataAvailable { return nil }
        loadMoreData()
        return Common.createLoadMoreCell()
    }
    
    private func updateGifAnimation() {
        Common.repeatCall { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.scrollViewDidScroll(strongSelf.listingTableView)
        }
    }
    
    private func starPageListingCell(_ item: Star) -> UITableViewCell {
        if let cell = listingTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.starPageListingCellId.identifier) as? StarPageListingCell {
            cell.bindData(star: item)
            cell.disposeBag.addDisposables([
                cell.didTapThumbnail.subscribe(onNext: { [unowned self] item in
                    self.navigator?.pushPageDetail(pageUrl: item.universalUrl, pageId: item.id)
                }),
                cell.didTapTitle.subscribe(onNext: { [unowned self] item in
                    self.navigator?.pushPageDetail(pageUrl: item.universalUrl, pageId: item.id)
                })
            ])
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func appListingCell(_ app: App) -> UITableViewCell {
        if let cell = listingTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.appListingCell.identifier) as? AppListingCell {
            cell.bindData(app: app)
            cell.disposeBag.addDisposables([
                cell.didTapAuthorName.subscribe(onNext: { [unowned self] app in
                    if let author = app.author {
                        self.navigator?.pushPageDetail(pageUrl: author.universalUrl, pageId: author.authorId)
                    }
                }),
                cell.didTapThumbnail.subscribe(onNext: { [unowned self] app in
                    self.navigator?.pushAppWhitePage(app: app)
                }),
                cell.didTapAppTitle.subscribe(onNext: { [unowned self] app in
                    self.navigator?.pushAppWhitePage(app: app)
                })
            ])
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func showListingCell(_ show: Show) -> UITableViewCell {
        if let cell = listingTableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.showListingCell.identifier) as? ShowListingCell {
            cell.bindData(show: show)
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func updateFiltersText() {
        guard let filter = viewModel.filter else { return }
        let tuple1 = filter.getSelectedItemTextForFilter(index: FilterMode.filter1.rawValue)
        if let text = tuple1.selectedItem {
            filter1Button.setTitle(text, for: .normal)
        } else {
            if let defaultText = tuple1.defaultItem {
                filter1Button.setTitle(defaultText, for: .normal)
            }
        }
        let tuple2 = filter.getSelectedItemTextForFilter(index: FilterMode.filter2.rawValue)
        if let text = tuple2.selectedItem {
            filter2Button.setTitle(text, for: .normal)
        } else {
            if let defaultText = tuple2.defaultItem {
                filter2Button.setTitle(defaultText, for: .normal)
            }
        }
        let tuple3 = filter.getSelectedItemTextForFilter(index: FilterMode.filter3.rawValue)
        if let text = tuple3.selectedItem {
            filter3Button.setTitle(text, for: .normal)
        } else {
            if let defaultText = tuple3.defaultItem {
                filter3Button.setTitle(defaultText, for: .normal)
            }
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func configureFilterView() {
        guard let filter = viewModel.filter else { return }
        switch filter.activeFilterMode {
        case .filter1:
            filter1Button.tintColor = Colors.dark.color()
            filter1ArrowImageView.image = R.image.iconArrowUp()
            filter2ArrowImageView.image = R.image.iconArrowDown()
            filter3ArrowImageView.image = R.image.iconArrowDown()
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter1.rawValue).selectedItem != nil {
                filter1Button.tintColor = Colors.activeFilterSortingTab.color()
                filter1ArrowImageView.image = R.image.iconArrowUpRed()
            }

            if filter.getSelectedItemTextForFilter(index: FilterMode.filter2.rawValue).selectedItem != nil {
                filter2ArrowImageView.image = R.image.iconArrowDownRed()
            }

            if filter.getSelectedItemTextForFilter(index: FilterMode.filter3.rawValue).selectedItem != nil {
                filter3ArrowImageView.image = R.image.iconArrowDownRed()
            }
            filterTableView.tableView.reloadData()
            hideFilterTable(isHidden: false)

        case .filter2:
            filter2Button.tintColor = Colors.dark.color()
            filter1ArrowImageView.image = R.image.iconArrowDown()
            filter2ArrowImageView.image = R.image.iconArrowUp()
            filter3ArrowImageView.image = R.image.iconArrowDown()
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter1.rawValue).selectedItem != nil {
                filter1ArrowImageView.image = R.image.iconArrowDownRed()
            }
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter2.rawValue).selectedItem != nil {
                filter2Button.tintColor = Colors.activeFilterSortingTab.color()
                filter2ArrowImageView.image = R.image.iconArrowUpRed()
            }
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter3.rawValue).selectedItem != nil {
                filter3ArrowImageView.image = R.image.iconArrowDownRed()
            }
            filterTableView.tableView.reloadData()
            hideFilterTable(isHidden: false)
            
        case .filter3:
            filter3Button.tintColor = Colors.dark.color()
            filter1ArrowImageView.image = R.image.iconArrowDown()
            filter2ArrowImageView.image = R.image.iconArrowDown()
            filter3ArrowImageView.image = R.image.iconArrowUp()

            if filter.getSelectedItemTextForFilter(index: FilterMode.filter1.rawValue).selectedItem != nil {
                filter1ArrowImageView.image = R.image.iconArrowDownRed()
            }
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter2.rawValue).selectedItem != nil {
                filter2ArrowImageView.image = R.image.iconArrowDownRed()
            }
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter3.rawValue).selectedItem != nil {
                filter3Button.tintColor = Colors.activeFilterSortingTab.color()
                filter3ArrowImageView.image = R.image.iconArrowUpRed()
            }
            filterTableView.tableView.reloadData()
            hideFilterTable(isHidden: false)

        case .none:
            filter1Button.tintColor = Colors.dark.color()
            filter2Button.tintColor = Colors.dark.color()
            filter3Button.tintColor = Colors.dark.color()
            filter1ArrowImageView.image = R.image.iconArrowDown()
            filter2ArrowImageView.image = R.image.iconArrowDown()
            filter3ArrowImageView.image = R.image.iconArrowDown()

            if filter.getSelectedItemTextForFilter(index: FilterMode.filter1.rawValue).selectedItem != nil {
                filter1Button.tintColor = Colors.activeFilterSortingTab.color()
                filter1ArrowImageView.image = R.image.iconArrowDownRed()
            }
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter2.rawValue).selectedItem != nil {
                filter2Button.tintColor = Colors.activeFilterSortingTab.color()
                filter2ArrowImageView.image = R.image.iconArrowDownRed()
            }
            
            if filter.getSelectedItemTextForFilter(index: FilterMode.filter3.rawValue).selectedItem != nil {
                filter3Button.tintColor = Colors.activeFilterSortingTab.color()
                filter3ArrowImageView.image = R.image.iconArrowDownRed()
            }
            filterTableView.tableView.reloadData()
            hideFilterTable(isHidden: true)
        }
    }
    
    private func hideFilterTable(isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.filterContainView.alpha = 0.0
            }, completion: { isCompleted in
                if isCompleted {
                    self.filterTableViewHeightConstraint.constant = 0
                }
            })
        } else {
            filterContainView.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: {
                self.filterTableViewHeightConstraint.constant = self.filterContainView.frame.size.height
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension ListingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !dataReadyForStream {
            return Constants.DefaultValue.PlaceHolderLoadingHeight
        }
        
        return Constants.DefaultValue.starListingHeightCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !dataReadyForStream {
            return 2 // place holder cells
        }
        
        let itemsCount = viewModel.itemsList.count
        if isMoreDataAvailable { return itemsCount + 1 }
        
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !dataReadyForStream {
            return Common.createLoadingPlaceHolderCell()
        }
        
        if let cell = createLoadMoreCell(indexPath) {
            return cell
        }
        
        if indexPath.row < viewModel.itemsList.count {
            switch viewModel.listingType {
            case .star:
                if let star = viewModel.itemsList[indexPath.row] as? Star {
                    return starPageListingCell(star)
                }
            case .appAndGame:
                if let app = viewModel.itemsList[indexPath.row] as? App {
                    return appListingCell(app)
                }
            case .showAndProgram:
                if let show = viewModel.itemsList[indexPath.row] as? Show {
                    return showListingCell(show)
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch viewModel.listingType {
        case .showAndProgram:
            if indexPath.row < viewModel.itemsList.count, let show = viewModel.itemsList[indexPath.row] as? Show {
                navigator?.pushPageDetail(pageUrl: show.universalUrl ?? "", pageId: show.id)
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is StarPageListingCell { updateGifAnimation() }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: headerHeight))
        view.backgroundColor = Colors.defaultBg.color()
        
        let label = UILabel()
        label.textColor = Colors.defaultText.color()
        label.font = Fonts.Primary.semiBold.toFontWith(size: 14.0)
        label.textAlignment = NSTextAlignment.natural
        
        switch viewModel.listingType {
        case .appAndGame:
            label.text = R.string.localizable.appListingTitle()
        case .star:
            label.text = R.string.localizable.starPageListingTitle()
        case .showAndProgram:
            label.text = R.string.localizable.showListingTitle()
        }
    
        view.mf.addSubview(label, andConstraints:
            label.centerY |==| view.centerY,
            label.left |+| 16,
            label.right |-| 16
        )
        
        view.addSubview(label)
        
        return view
    }
}

extension ListingViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }

    // swiftlint:disable force_cast
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Common.shouldBypassAnimation() { return }
        
        let visibleCells = listingTableView.visibleCells
        for cell in visibleCells where cell is StarPageListingCell {
            _ = Common.setAnimationFor(cell: (cell as! StarPageListingCell), viewPort: listingContainView)
        }
        for cell in visibleCells where cell is AppListingCell {
            _ = Common.setAnimationFor(cell: (cell as! AppListingCell), viewPort: listingContainView)
        }
        for cell in visibleCells where cell is ShowListingCell {
            _ = Common.setAnimationFor(cell: (cell as! ShowListingCell), viewPort: listingContainView)
        }
    }
    // swiftlint:enable force_cast
}
