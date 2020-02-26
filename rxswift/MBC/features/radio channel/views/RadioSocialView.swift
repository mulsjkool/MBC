//
//  RadioSocialView.swift
//  MBC
//
//  Created by Tri Vo on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import MisterFusion
import RxSwift

class RadioSocialView: UIView {
	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var collectionView: UICollectionView!
	private var items: [SocialNetwork] = []
	
	var accentColor: UIColor = .white
	var onSelectedItem = PublishSubject<SocialNetwork>()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		setupUI()
	}
	
	private func setupUI() {
		Bundle.main.loadNibNamed(R.nib.radioSocialView.name, owner: self, options: nil)
		addSubview(containerView)
		containerView.frame = self.bounds
		self.mf.addConstraints([
			self.top |==| containerView.top,
			self.left |==| containerView.left,
			self.bottom |==| containerView.bottom,
			self.right |==| containerView.right
		])
		setupCollectionView()
	}
	
	private func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1
		layout.scrollDirection = .horizontal
		collectionView.backgroundColor = .clear
		collectionView.collectionViewLayout = layout
		collectionView.allowsMultipleSelection = false
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(R.nib.radioSocialCell(),
								forCellWithReuseIdentifier: R.reuseIdentifier.radioSocialCell.identifier)
	}
	
	func bindData(data: [SocialNetwork]) {
		items = data
		collectionView.reloadData()
	}
}

extension RadioSocialView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (Constants.DeviceMetric.screenWidth - CGFloat(items.count - 1)) / CGFloat(items.count),
					  height: collectionView.bounds.height)
	}
}

extension RadioSocialView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
				R.reuseIdentifier.radioSocialCell.identifier, for: indexPath) as? RadioSocialCell,
			indexPath.row < items.count else { return UICollectionViewCell() }
		
		cell.bindData(data: items[indexPath.row],
					  bgColor: (indexPath.row == items.count - 1 && items[indexPath.row].socialNetworkName == .apple) ?
						UIColor.black : accentColor)
		return cell
	}
}

extension RadioSocialView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		onSelectedItem.onNext(items[indexPath.row])
	}
}
