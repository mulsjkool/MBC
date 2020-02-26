//
//  VideoBitRateView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 2/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxSwift

class VideoBitRateView: BaseView {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewWidthContraint: NSLayoutConstraint!
    private var resolutions: [String]!
    private let colorSelected = Colors.defaultAccentColor.color()
    private let itemWidth: CGFloat = 38
    private let itemHeight: CGFloat = 14
    private let reuseCell = "cell"
    private var lastSelectedButton: UIButton?
    private let buttonTag: Int = 1
    let biteRateItemSelected = PublishSubject<String>()
    
    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Public
    func bindData(resolutions: [String]) {
        disposeBag = DisposeBag()
        self.resolutions = resolutions
        setUpCollectionView()
    }
    
    // MARK: Private
    
    private func setUpCollectionView() {
        collectionViewWidthContraint.constant = itemWidth * CGFloat(resolutions.count) +
            CGFloat(resolutions.count) * Constants.DefaultValue.defaultMargin + Constants.DefaultValue.defaultMargin
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.64)
        collectionView.layer.cornerRadius = itemHeight / 2
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier:
            reuseCell)
        collectionView.reloadData()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.videoBitRateView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
    }
    
    private func createButtonItem() -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.titleLabel?.font = R.font.ltKaffRegular(size: 10)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = itemHeight / 2
        button.addTarget(self, action: #selector(buttonItemTouch), for: .touchUpInside)
        return button
    }
    
    @objc
    private func buttonItemTouch(sender: UIButton) {
        if let lastSelectedButton = self.lastSelectedButton { lastSelectedButton.backgroundColor = UIColor.clear }
        sender.backgroundColor = colorSelected
        lastSelectedButton = sender
        biteRateItemSelected.onNext(sender.title(for: .normal) ?? "")
    }
}

extension VideoBitRateView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resolutions != nil ? resolutions.count : 0
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            reuseCell, for: indexPath)
        var button = cell.contentView.viewWithTag(buttonTag) as? UIButton
        if button == nil {
            button = createButtonItem()
            cell.contentView.addSubview(button!)
        }
        button!.tag = buttonTag
        button!.setTitle(resolutions[indexPath.row], for: .normal)
        return cell
    }
    
}
