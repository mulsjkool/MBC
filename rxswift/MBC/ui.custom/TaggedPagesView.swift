//
//  TagedPagesView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import iCarousel
import Kingfisher
import MisterFusion
import RxSwift

class TaggedPagesView: BaseView {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var infiniteCollectionView: UICollectionView!
    @IBOutlet weak private var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var infiniteCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLabelBottomConstraint: NSLayoutConstraint!
    private var tagedPages: [MenuPage]!
    private var itemType: TaggedPageItemType!
    private var widthOfItem: CGFloat = Constants.DefaultValue.taggedViewItemSmallWidth
    private var heightOfItem: CGFloat = Constants.DefaultValue.taggedViewItemSmallHeight
    private var tagOfImageView: Int = 1
    var numberOfItemsPerSection: Int = 0
    private var infinityNumber: Int = Constants.DefaultValue.infinityNumber
    private var maximumInfinityNumber: Int = Constants.DefaultValue.maximumInfinityNumber
    
    let didTapTaggedPage = PublishSubject<MenuPage>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.taggedPagesView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }
    
    func resetPages() {
        if tagedPages != nil {
            numberOfItemsPerSection = 0
            tagedPages.removeAll()
            infiniteCollectionView.reloadData()
        }
    }
    
    func setLoading() {
        resetPages()
        loadingIndicatorView.startAnimating()
    }
    
    func bindData(tagedPages: [MenuPage], type: TaggedPageItemType? = .typeSmall) {
        disposeBag = DisposeBag()
        loadingIndicatorView.stopAnimating()
        self.tagedPages = tagedPages
        self.itemType = type
        numberOfItemsPerSection = self.tagedPages.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.setUpCollectionView()
        })
    }
    
    func reloadData() {
        infiniteCollectionView.reloadData()
    }
    
    func setColorForTitle(color: UIColor) {
        titleLabel.textColor = color
    }
    
    private func setUpCollectionView() {
        if itemType == .typeSmall {
            titleLabelBottomConstraint.constant = 8.0
            widthOfItem = Constants.DefaultValue.taggedViewItemSmallWidth
            heightOfItem = Constants.DefaultValue.taggedViewItemSmallHeight
            infiniteCollectionView.register(R.nib.taggedPageItemCollectionViewCell(),
                                            forCellWithReuseIdentifier:
                R.reuseIdentifier.taggedPageItemCollectionViewCellid.identifier)
        } else {
            titleLabelBottomConstraint.constant = 16.0
            widthOfItem = Constants.DefaultValue.taggedViewItemFullWidth
            heightOfItem = Constants.DefaultValue.taggedViewItemFullHeight
            infiniteCollectionView.register(R.nib.taggedPageItemTypeFullCollectionViewCell(),
                                            forCellWithReuseIdentifier:
                R.reuseIdentifier.taggedPageItemTypeFullCollectionViewCellid.identifier)
        }
        infiniteCollectionHeightConstraint.constant = heightOfItem
        if Constants.DefaultValue.shouldRightToLeft {
            infiniteCollectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        infiniteCollectionView.backgroundColor = UIColor.clear
        infiniteCollectionView.dataSource = self
        infiniteCollectionView.delegate = self
        infiniteCollectionView.reloadData()
        if shoulEnableInfinityScrolling() {
            numberOfItemsPerSection = infinityNumber
            infiniteCollectionView.scrollToItem(at: IndexPath(item: numberOfItemsPerSection / 2, section: 0),
                                        at: UICollectionViewScrollPosition.right, animated: false)
        }
    }
    
    private func shoulEnableInfinityScrolling() -> Bool {
        let totalW = CGFloat(tagedPages.count) * widthOfItem
        return totalW > Constants.DeviceMetric.screenWidth
    }
    
    private func getIndexFrom(indexPath: IndexPath) -> Int {
        return indexPath.row >= self.tagedPages.count ? indexPath.row % self.tagedPages.count : indexPath.row
    }
    
    private func createTaggedCellSmall(indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = infiniteCollectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.taggedPageItemCollectionViewCellid.identifier,
                                                         for: indexPath) as? TaggedPageItemCollectionViewCell {
            let page = tagedPages[getIndexFrom(indexPath: indexPath)]
            cell.bindData(logo: page.posterUrl)
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func createTaggedCellFull(indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = infiniteCollectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.taggedPageItemTypeFullCollectionViewCellid.identifier, for: indexPath) as?
            TaggedPageItemTypeFullCollectionViewCell {
            let page = tagedPages[getIndexFrom(indexPath: indexPath)]
            cell.bindData(page: page)
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension TaggedPagesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOfItem, height: heightOfItem )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.DefaultValue.taggedViewCellInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.DefaultValue.defaultMargin, bottom: 0,
                            right: Constants.DefaultValue.defaultMargin)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if itemType == .typeSmall { return createTaggedCellSmall(indexPath: indexPath) } else {
            return createTaggedCellFull(indexPath: indexPath) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapTaggedPage.onNext(tagedPages[getIndexFrom(indexPath: indexPath)])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentW = scrollView.contentSize.width
        if offsetX > contentW - scrollView.frame.size.width && numberOfItemsPerSection < maximumInfinityNumber {
            numberOfItemsPerSection += infinityNumber
            self.infiniteCollectionView.reloadData()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = widthOfItem
        let itemIndex = (targetContentOffset.pointee.x) / pageWidth
        targetContentOffset.pointee.x = round(itemIndex) * pageWidth
    }
}
