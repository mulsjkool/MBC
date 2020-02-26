//
//  AirTimeListViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class AirTimeListViewController: BaseViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    var viewModel: PageDetailViewModel!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(AirTimeListViewController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLargeCloseButton()
        title = R.string.localizable.airTimeListTitle()
        let textAttributes = [NSAttributedStringKey.foregroundColor: Colors.unselectedTabbarItem.color(alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        setupUI()
        bindEvents()
    }
    
    private func addRefreshControl() {
        if refreshControl.superview == nil {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc
    private func refreshData(_ refreshControl: UIRefreshControl) {
        viewModel.getScheduledChannelList()
    }
    
    private func setupUI() {
        addRefreshControl()
        showHideNavigationBar(shouldHide: false)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(R.nib.airTimeCell(),
                                      forCellReuseIdentifier: R.reuseIdentifier.airTimeCellId.identifier)
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartScheduledChannelList.subscribe(onNext: {}),
            viewModel.onWillStopScheduledChannelList.subscribe(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            }),
            viewModel.onDidLoadScheduledChannelList.subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
        ])
    }
    
    private func airTimeListingCell(_ item: Schedule) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.airTimeCellId.identifier) as? AirTimeCell {
            cell.bindData(item: item)
            cell.disposeBag.addDisposables([
                cell.didTapThumbnail.subscribe(onNext: { [unowned self] item in
                    guard let pageURL = item.channel?.externalUrl, let pageID = item.channel?.id else { return }
                    guard let pageDetailVC = R.storyboard.pageDetail.pageDetailViewController() else {
                        return
                    }
                    pageDetailVC.navigator = self.navigator
                    pageDetailVC.pageUrl = pageURL
                    pageDetailVC.pageId = pageID
                    self.navigationController?.pushViewController(pageDetailVC, animated: true)
                }),
                cell.didTapAdd.subscribe(onNext: { _ in
                    print("didTapAdd")
                })
            ])
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func updateGifAnimation() {
        Common.repeatCall { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.scrollViewDidScroll(strongSelf.tableView)
        }
    }
}

extension AirTimeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.DefaultValue.airTimeListingHeightCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.scheduledChannelList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = viewModel?.scheduledChannelList?.count ?? 0
        if indexPath.row < count, let array = viewModel.scheduledChannelList, !array.isEmpty {
            return self.airTimeListingCell(array[indexPath.row])
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is AirTimeCell { updateGifAnimation() }
    }
}

extension AirTimeListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
    
    // swiftlint:disable force_cast
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Common.shouldBypassAnimation() { return }
        
        let visibleCells = tableView.visibleCells
        for cell in visibleCells where cell is AirTimeCell {
            _ = Common.setAnimationFor(cell: (cell as! AirTimeCell), viewPort: self.view)
        }
    }
    // swiftlint:enable force_cast
}
