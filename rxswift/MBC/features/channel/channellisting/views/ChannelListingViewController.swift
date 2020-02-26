//
//  ChannelListingViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/12/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion

class ChannelListingViewController: BaseViewController {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ChannelListingViewController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    private var viewModel = ChannelListingViewModel(interactor: Components.channelListingInteractor())
    private var isMoreDataAvailable: Bool = false
    private var dataReadyForStream = false
    
    static let collectionCellSpacing: CGFloat = 2.0
    private let sizeOfItemView: Int = Int((Constants.DeviceMetric.screenWidth
        - ChannelListingViewController.collectionCellSpacing) / 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindEvents()
        getChannelList()
    }
    
    // MARK: Private functions
    
    private func setupUI() {
        title = R.string.localizable.channelListingScreenTitle()
        addBackButton()
        collectionView.register(R.nib.channelCollectionViewCell(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.channelCollectionViewCell.identifier)
        collectionView.register(R.nib.loadingPlaceHolderCollectionViewCell(),
                    forCellWithReuseIdentifier: R.reuseIdentifier.loadingPlaceHolderCollectionViewCell.identifier)
        collectionView.register(R.nib.loadMoreCollectionViewCell(),
                                forCellWithReuseIdentifier: R.reuseIdentifier.loadMoreCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.white
        addRefreshControl()
    }
    
    private func addRefreshControl() {
        if refreshControl.superview == nil {
            collectionView.addSubview(refreshControl)
        }
    }
    
    private func getChannelList() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.loadItems()
        })
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartGetListItem.subscribe({ [unowned self] _ in
                self.isMoreDataAvailable = true
            }),
            viewModel.onWillStopGetListItem.subscribe(onNext: { [unowned self] _ in
                self.refreshControl.endRefreshing()
                self.dataReadyForStream = true
                self.collectionView.backgroundColor = Colors.channelTabBackgroundColor.color(alpha: 1)
                self.updateContent()
            }),
            viewModel.onFinishLoadListItem.subscribe(onNext: { [unowned self] in
                self.refreshControl.endRefreshing()
                self.isMoreDataAvailable = false
                self.updateContent()
            })
        ])
    }
    
    @objc
    private func refreshData(_ refreshControl: UIRefreshControl) {
        refreshData()
    }
    
    private func refreshData() {
        isMoreDataAvailable = false
        viewModel.refreshItems()
    }
    
    private func updateContent() {
        collectionView.reloadData()
    }
    
    private func loadMoreData() {
        viewModel.loadItems()
    }
    
    private func createLoadMoreCell(_ indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.loadMoreCollectionViewCell.identifier, for: indexPath)
            as? LoadMoreCollectionViewCell else { return UICollectionViewCell() }
        loadMoreData()
        return cell
    }
    
    private func channelCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.channelCollectionViewCell.identifier, for: indexPath)
            as? ChannelCollectionViewCell else { return UICollectionViewCell() }
        cell.bindData(page: viewModel.itemsList[indexPath.row])
        return cell
    }
    
    private func loadingPlaceHolderCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.loadingPlaceHolderCollectionViewCell.identifier, for: indexPath)
            as? LoadingPlaceHolderCollectionViewCell else { return UICollectionViewCell() }
        cell.showLoadingAnimation()
        return cell
    }
}

extension ChannelListingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if !dataReadyForStream {
                return CGSize(width: sizeOfItemView, height: sizeOfItemView)
            }
            return CGSize(width: sizeOfItemView, height: sizeOfItemView)
        }
        return CGSize(width: Constants.DeviceMetric.screenWidth,
                      height: Constants.DefaultValue.channelListingLoadMoreCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if !dataReadyForStream {
                return Constants.DefaultValue.numberOfLoadingPlaceHolderCell
            }
            return viewModel.itemsList.count
        }
        return isMoreDataAvailable ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ChannelListingViewController.collectionCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if !dataReadyForStream {
                return loadingPlaceHolderCell(indexPath)
            }
            return channelCell(indexPath)
        }
        
        if let cell = createLoadMoreCell(indexPath) {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row < viewModel.itemsList.count {
            let page = viewModel.itemsList[indexPath.row]
            navigator?.pushPageDetail(pageUrl: page.universalUrl, pageId: page.entityId)
        }
    }
}

extension ChannelListingViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
}
