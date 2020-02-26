//
//  IPadListVideoPlaylistDataSource.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

enum ListVideoPlaylistSection: Int {
	case menuContentTitle = 0
	case ads = 1
	case listVideoDefault = 2
	case relatedTitle = 3
	case listVideoRelated = 4
}

class IPadListVideoPlaylistDataSource: NSObject {
	
	private let viewModel: VideoPlaylistViewModel
	
	init(viewModel: VideoPlaylistViewModel) {
		self.viewModel = viewModel
		super.init()
	}
	
	private var adsCells = [IndexPath: AdsContainer]() // caching ads
	
	let reloadCell = PublishSubject<IndexPath>()
	
	func registerCell(of tableView: UITableView) {
		tableView.register(R.nib.iPadTextCell(), forCellReuseIdentifier: R.reuseIdentifier.iPadTextCell.identifier)
		tableView.register(R.nib.radioAdsViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.radioAdsViewCell.identifier)
		tableView.register(R.nib.iPadVideoPlaylistNextItemCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.iPadVideoPlaylistNextItemCell.identifier)
	}
	
	func numberOfSections() -> Int {
		return 5
	}
	
	func tableView(numberOfRowsInSection section: Int) -> Int {
		if section == ListVideoPlaylistSection.menuContentTitle.rawValue { return 1 }
		if section == ListVideoPlaylistSection.ads.rawValue { return 1 }
		if section == ListVideoPlaylistSection.listVideoDefault.rawValue { return 0 }
		if section == ListVideoPlaylistSection.relatedTitle.rawValue { return 1 }
		if section == ListVideoPlaylistSection.listVideoRelated.rawValue { return 0 }
		return 0
	}
	
	func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == ListVideoPlaylistSection.menuContentTitle.rawValue { return headerText(tableView) }
		
		if indexPath.section == ListVideoPlaylistSection.ads.rawValue { return bannerAdsCell(tableView, at: indexPath) }
		
		if indexPath.section == ListVideoPlaylistSection.listVideoDefault.rawValue {
			
		}
		
		if indexPath.section == ListVideoPlaylistSection.relatedTitle.rawValue {
			return headerText(tableView, isRelated: true)
		}
		
		if indexPath.section == ListVideoPlaylistSection.listVideoRelated.rawValue {
			
		}
		
		return UITableViewCell()
	}
	
}

// MARK: - Make Cell
extension IPadListVideoPlaylistDataSource {
	
	private func bannerAdsCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.radioAdsViewCell.identifier) as? RadioAdsViewCell else { return UITableViewCell() }
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath], let parentVC = tableView.viewController {
				ads.requestAds(adsType: .banner, viewController: parentVC)
				ads.disposeBag.addDisposables([
					ads.loadAdSuccess.subscribe(onNext: { [unowned self] row in
						if let index = row { self.reloadCell.onNext(index) }
					})
				])
			}
		}
		return cell
	}
	
	private func headerText(_ tableView: UITableView, isRelated: Bool = false) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.iPadTextCell.identifier) as? IPadTextCell else { return UITableViewCell() }
		cell.bindData(title: isRelated ? R.string.localizable.commonVideoRelated()
										: R.string.localizable.commonVideoNextItem(),
					  textColor: isRelated ? Colors.userProfileTabButton.color() : .white,
					  bgColor: isRelated ? Colors.playlistRelated.color() : Colors.playlistMenuContent.color())
		
		return cell
	}
}
