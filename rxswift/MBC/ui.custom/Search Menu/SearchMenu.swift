//
//  SearchMenu.swift
//  MBC
//
//  Created by Tri Vo on 2/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import MisterFusion
import RxSwift

class SearchMenu: UIView {
	@IBOutlet weak private var containerView: UIView!
	@IBOutlet weak private var collectionView: UICollectionView!
	
	var currentMenuItem: SearchItemEnum = .all
	var titlesMenu: [SearchMenuItem] = {
		if Components.languageRepository.currentLanguageEnum() == LanguageEnum.arabic {
			return SearchItemEnum.allItems.reversed()
		}
		return SearchItemEnum.allItems
	}()
	
	public var onSelectedSearchMenuItem = PublishSubject<SearchItemEnum>()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		Bundle.main.loadNibNamed(R.nib.searchMenu.name, owner: self, options: nil)
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
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .horizontal
		collectionView.collectionViewLayout = layout
		collectionView.allowsMultipleSelection = false
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(R.nib.searchMenuItemCell(),
								forCellWithReuseIdentifier: R.reuseIdentifier.searchMenuItemCell.identifier)
		collectionView.selectItem(at: IndexPath(item: (titlesMenu.count - 1), section: 0),
								  animated: false, scrollPosition: .centeredHorizontally)
	}
	
	public func updateStatisticSearch(data: [SearchMenuItem]) {
		if currentMenuItem == .all {
			self.titlesMenu = data
			if Constants.DefaultValue.shouldRightToLeft { self.titlesMenu.reverse() }
			collectionView.reloadData()
			collectionView.selectItem(at: IndexPath(item: (titlesMenu.count - 1), section: 0),
									  animated: false, scrollPosition: .centeredHorizontally)
		}
	}
}

extension SearchMenu: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let title = titlesMenu[indexPath.row].title
		let searchMenuWidth = title.width(withConstrainedHeight: Constants.DefaultValue.searchMenuHeight,
														font: Fonts.Primary.semiBold.toFontWith(size: 10)!)
		return CGSize(width: (searchMenuWidth + 2 * Constants.DefaultValue.searchMenuPadding),
					  height: Constants.DefaultValue.searchMenuHeight)
	}
}

extension SearchMenu: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return titlesMenu.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
			R.reuseIdentifier.searchMenuItemCell.identifier, for: indexPath) as? SearchMenuItemCell {
			cell.bindData(data: titlesMenu[indexPath.row].title)
			return cell
		}
		return UICollectionViewCell()
	}
}

extension SearchMenu: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.contentSize.width > UIScreen.main.bounds.width {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
		currentMenuItem = titlesMenu[indexPath.row].type
		onSelectedSearchMenuItem.onNext(currentMenuItem)
	}
}
