//
//  BundleSingleItemCell.swift
//  MBC
//
//  Created by Cuong Nguyen on 2/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class BundleSingleItemCell: BaseTableViewCell {
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var carouselCollectionView: UICollectionView!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    
    private var widthOfCarouselItem: CGFloat = Constants.Singleton.isiPad ? 136 : 107
    private var heightOfCarouselItem: CGFloat = Constants.Singleton.isiPad ? 76 : 60
    private var widthOfCurrentItem: CGFloat = Constants.DeviceMetric.screenWidth
    private var heightOfCurrentItem: CGFloat = Constants.Singleton.isiPad ?
        Constants.DeviceMetric.screenWidth / (1 / Constants.DefaultValue.ratio9H16W) :
        Constants.DeviceMetric.screenWidth / Constants.DefaultValue.ratio27H40W
    
    var timestampTapped = PublishSubject<Feed>()
    var authorAvatarTapped = PublishSubject<Feed>()
    var authorNameTapped = PublishSubject<Feed>()
    var bundleTitleTapped = PublishSubject<(Feed, Feed)>()
    var itemTitleTapped = PublishSubject<(Feed, Feed)>()
    var thumbnailTapped = PublishSubject<(Feed, Feed)>()
    var commentCountTapped = PublishSubject<(Feed, Feed)>()
    var likeCountTapped = PublishSubject<(Feed, Feed)>()
    var readMoreCarouselItemTapped = PublishSubject<(Feed, Feed)>()
    
    private var bundle: BundleContent!
    private var numberOfItems: Int = 0
    private var maxNumberOfBundleSingleItem = Constants.DefaultValue.maxNumberOfBundleSingleItem
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func bindData(bundle: BundleContent, accentColor: UIColor?) {
        self.bundle = bundle
        
        numberOfItems = bundle.items.count
        numberOfItems = (numberOfItems > maxNumberOfBundleSingleItem) ? maxNumberOfBundleSingleItem : numberOfItems
        bindCollectionView()
        bindCarouselCollectionView()
        bindData()
        setupEvents()
    }
    
    private func bindCollectionView() {
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            var isDisplayingCurrentItem = false
            for cell in self.collectionView.visibleCells {
                if let indexPath = self.collectionView.indexPath(for: cell),
                    self.bundle.selectedItemIndex == indexPath.row {
                    isDisplayingCurrentItem = true
                    break
                }
            }
            if !isDisplayingCurrentItem {
                self.scrollToItemAtIndex(self.bundle.selectedItemIndex, animated: false)
            }
        })
    }
    
    private func bindCarouselCollectionView() {
        carouselCollectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            var isDisplayingCurrentItemOnCarousel = false
            for cell in self.carouselCollectionView.visibleCells {
                if let indexPath = self.carouselCollectionView.indexPath(for: cell),
                    self.bundle.selectedItemIndex == indexPath.row {
                    isDisplayingCurrentItemOnCarousel = true
                    break
                }
            }
            if !isDisplayingCurrentItemOnCarousel {
                self.scrollToCarouselItemAt(self.bundle.selectedItemIndex, animated: false)
            }
        })
    }
    
    private func setupUI() {
        carouselCollectionView.register(R.nib.bundleSingleItemCollectionViewCell(),
                        forCellWithReuseIdentifier: R.reuseIdentifier.bundleSingleItemCollectionViewCell.identifier)
        carouselCollectionView.isPagingEnabled = false
        
        if Constants.Singleton.isiPad {
            collectionView.register(R.nib.iPadBundleSingleItemInforCollectionViewCell(),
                                    forCellWithReuseIdentifier:
                R.reuseIdentifier.iPadBundleSingleItemInforCollectionViewCellId.identifier)
        } else {
            collectionView.register(R.nib.bundleSingleItemInforCollectionViewCell(),
                                    forCellWithReuseIdentifier:
                R.reuseIdentifier.bundleSingleItemInforCollectionViewCell.identifier)
        }
        
        collectionView.isPagingEnabled = true
    }
    
    private func bindData() {
        guard bundle.selectedItemIndex < numberOfItems else {
            numberOfItems = 0
            rightButton.isHidden = true
            leftButton.isHidden = true
            return
        }
        bindNextAndPreviousButton()
        selectCarouselItem()
    }
    
    private func bindNextAndPreviousButton() {
        let nextIndex = bundle.selectedItemIndex + 1
        leftButton.isHidden = (nextIndex < numberOfItems) ? false : true
        let previousIndex = bundle.selectedItemIndex - 1
        rightButton.isHidden = (previousIndex >= 0) ? false : true
    }
    
    func setupEvents() {
        disposeBag.addDisposables([
            leftButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                let nextIndex = self.bundle.selectedItemIndex + 1
                if nextIndex < self.numberOfItems && self.bundle.selectedItemIndex != nextIndex {
                    self.bundle.selectedItemIndex = nextIndex
                    self.bindData()
                    self.scrollToItemAtIndex(self.bundle.selectedItemIndex)
                    self.scrollToCarouselItemAt(self.bundle.selectedItemIndex)
                }
            }),
            
            rightButton.rx.tap.subscribe(onNext: { _ in
                let previousIndex = self.bundle.selectedItemIndex - 1
                if previousIndex >= 0 && self.bundle.selectedItemIndex != previousIndex {
                    self.bundle.selectedItemIndex = previousIndex
                    self.bindData()
                    self.scrollToItemAtIndex(self.bundle.selectedItemIndex)
                    self.scrollToCarouselItemAt(self.bundle.selectedItemIndex)
                }
            })
        ])
    }
    
    private func carouselCellFor(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.bundleSingleItemCollectionViewCell.identifier, for: indexPath)
            as? BundleSingleItemCollectionViewCell else { return UICollectionViewCell() }
        var moreItemNumber: Int = 0
        if indexPath.row < maxNumberOfBundleSingleItem - 1 {
            moreItemNumber = 0
        } else {
            moreItemNumber = bundle.items.count - maxNumberOfBundleSingleItem
        }
        let item = bundle.items[indexPath.row]
        cell.bindData(thumbnail: item.thumbnail, selected: indexPath.row == bundle.selectedItemIndex,
                      accentColor: nil, moreItemNumber: moreItemNumber)
        cell.disposeBag.addDisposables([
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] _ in
                if self.bundle.selectedItemIndex != indexPath.row {
                    self.bundle.selectedItemIndex = indexPath.row
                    self.bindData()
                    self.scrollToItemAtIndex(self.bundle.selectedItemIndex)
                }
                if self.bundle.selectedItemIndex == self.maxNumberOfBundleSingleItem - 1 {
                    self.readMoreCarouselItemTapped.onNext((self.bundle,
                                                            self.bundle.items[self.bundle.selectedItemIndex]))
                }
            })
        ])
        return cell
    }
    
    private func currentItemCellFor(indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = IPad.CellIdentifier.bundleSingleItemInforCell
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            as? BundleSingleItemInforCollectionViewCell else { return UICollectionViewCell() }
        
        cell.bindData(feed: bundle.items[indexPath.row], bundleTitle: bundle.title)
        cell.disposeBag.addDisposables([
            cell.timestampTapped.subscribe(onNext: { [unowned self] _ in
                self.timestampTapped.onNext(self.bundle.items[self.bundle.selectedItemIndex])
            }),
            cell.authorAvatarTapped.subscribe(onNext: { [unowned self] _ in
                self.authorAvatarTapped.onNext(self.bundle.items[self.bundle.selectedItemIndex])
            }),
            cell.authorNameTapped.subscribe(onNext: { [unowned self] _ in
                self.authorNameTapped.onNext(self.bundle.items[self.bundle.selectedItemIndex])
            }),
            cell.bundleTitleTapped.subscribe(onNext: { [unowned self] _ in
                self.bundleTitleTapped.onNext((self.bundle, self.bundle.items[self.bundle.selectedItemIndex]))
            }),
            cell.itemTitleTapped.subscribe(onNext: { [unowned self] _ in
                self.itemTitleTapped.onNext((self.bundle, self.bundle.items[self.bundle.selectedItemIndex]))
            }),
            cell.thumbnailTapped.subscribe(onNext: { [unowned self] _ in
                self.thumbnailTapped.onNext((self.bundle, self.bundle.items[self.bundle.selectedItemIndex]))
            }),
            cell.commentCountTapped.subscribe(onNext: { [unowned self] _ in
                self.commentCountTapped.onNext((self.bundle, self.bundle.items[self.bundle.selectedItemIndex]))
            }),
            cell.likeCountTapped.subscribe(onNext: { [unowned self] _ in
                self.likeCountTapped.onNext((self.bundle, self.bundle.items[self.bundle.selectedItemIndex]))
            })
        ])
        return cell
    }
    
    private func scrollToCarouselItemAt(_ index: Int, animated: Bool = true) {
        if index < numberOfItems {
            carouselCollectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                                at: .centeredHorizontally,
                                                animated: animated)
        }
    }
    
    private func selectCarouselItem() {
        for cell in carouselCollectionView.visibleCells {
            if let indexPath = carouselCollectionView.indexPath(for: cell),
                let carouselCell = cell as? BundleSingleItemCollectionViewCell {
                if indexPath.row == bundle.selectedItemIndex {
                    carouselCell.select(isSelected: true)
                } else {
                    carouselCell.select(isSelected: false)
                }
            }
        }
    }
    
    private func scrollToItemAtIndex(_ index: Int, animated: Bool = true) {
        if index < numberOfItems {
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                        at: .centeredHorizontally,
                                        animated: animated)
        }
    }
}

extension BundleSingleItemCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == carouselCollectionView {
            return CGSize(width: widthOfCarouselItem, height: heightOfCarouselItem)
        }
        return CGSize(width: widthOfCurrentItem, height: heightOfCurrentItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == carouselCollectionView {
            return Constants.DefaultValue.defaultMargin
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == carouselCollectionView {
            return UIEdgeInsets(top: 0, left: Constants.DefaultValue.defaultMargin,
                                bottom: 0, right: Constants.DefaultValue.defaultMargin)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselCollectionView {
            return carouselCellFor(indexPath: indexPath)
        }
        return currentItemCellFor(indexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            var visibleRect = CGRect()
            visibleRect.origin = collectionView.contentOffset
            visibleRect.size = collectionView.bounds.size
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) {
                bundle.selectedItemIndex = visibleIndexPath.row
                bindData()
                scrollToCarouselItemAt(bundle.selectedItemIndex)
            }
        } else if scrollView == carouselCollectionView {
            selectCarouselItem()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == carouselCollectionView {
            selectCarouselItem()
        }
    }
}
