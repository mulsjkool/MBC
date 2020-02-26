//
//  MenuViewController.swift
//  F8
//
//  Created by Dao Le Quang on 11/7/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import MisterFusion
import RxSwift
import UIKit

class MenuViewController: BaseViewController {

	private let viewModel: MenuViewModel = {
		return MenuViewModel(interactor: Components.menuInteractor())
	}()

	private var menuTableView: UITableView!
	private var selectedItem: (index: IndexPath, featured: MenuPage?)?
	
	private var menuLogos = [Int: RemoteImage]()
	private var imageDownloadsInProgress = [IndexPath: IconDownloader]()
	var dashboardController: DashboardViewController?
	fileprivate var menuNavigator: Navigator? {
		guard Constants.Singleton.isiPad,
			let dashboardCtrl = dashboardController else {
				return Navigator(navigationController: self.navigationController)
		}
		
		if let selectedCtrl = dashboardCtrl.tabbarController.selectedViewController as? BaseViewController {
			return selectedCtrl.navigator
		}
		
		if let selectedCtrl = dashboardCtrl.tabbarController.selectedViewController as? MainNavigationController {
			return (selectedCtrl.viewControllers.first as? BaseViewController)?.navigator
		}
		
		return nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		viewModel.errorDecorator = self
		bindEvents()
	}

	override func subscribeOnAppear() {
		startToGetFeaturePages()
		
		let disposableStartHome = viewModel.onDidSignoutSuccess.subscribe(onNext: { _ in
			Constants.Singleton.appDelegate.openLoginScreen()
		})
		insertToClearOnDisappear(disposable: disposableStartHome)
	}
	
	private func startToGetFeaturePages() {
		DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
			self.viewModel.startToGetFeaturePages()
		})
	}

	private func setupUI() {
		self.navigationItem.title = R.string.localizable.sidemenuNavigationTitle().localized()
		addMenuBackButtonForiPhone()
		addTableView()
	}

	private func addTableView() {
		let displayWidth = Constants.DeviceMetric.screenWidth
		let displayHeight = Constants.DeviceMetric.displayViewHeightWithNavAndTabbar
		let tableFrame = CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight)
		menuTableView = UITableView(frame: tableFrame, style: .grouped)
		menuTableView.register(R.nib.menuCell(), forCellReuseIdentifier: R.reuseIdentifier.menuCellId.identifier)
		menuTableView.register(R.nib.menuProfileCell(),
							   forCellReuseIdentifier: R.reuseIdentifier.menuProfileCellId.identifier)
		menuTableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
		menuTableView.showsVerticalScrollIndicator = false
		menuTableView.dataSource = self
		menuTableView.delegate = self
		self.view.addSubview(menuTableView)
		
		menuTableView.translatesAutoresizingMaskIntoConstraints = false
		self.view.mf.addConstraints(
			menuTableView.top |==| self.view.top,
			menuTableView.left |==| self.view.left,
			menuTableView.width |==| self.view.width,
			menuTableView.height |==| self.view.height
		)
	}

	private func bindEvents() {
		disposeBag.addDisposables([
			// Getting Pages
			viewModel.onWillStartToGetFeaturePages.subscribe(onNext: {}),
			viewModel.onWillStopToGetFeaturePages.subscribe(onNext: {}),
			viewModel.onDidGetFeaturePages.subscribe(onNext: { [weak self] _ in
				let sections = IndexSet(integer: TableSection.featured.rawValue)
				self?.menuTableView.reloadSections(sections, with: .automatic)
			}),
			
			viewModel.onWillStartSignout.subscribe(onNext: { [unowned self] _ in
				self.showLoading(status: "", showInView: nil)
			}),
			
			viewModel.onWillStopSignout.subscribe(onNext: { [unowned self] _ in
				self.hideLoading(showInView: nil)
			}),
			
			viewModel.onShowError.subscribe(onNext: { [unowned self] error in
				if let text = error.errorString() {
					self.showMessage(message: text)
				}
			})
		])
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == R.segue.menuViewController.segueMenuSelectFeaturedPage.identifier {
			guard let pageDetailVC = segue.destination as? PageDetailViewController,
				let page = sender as? MenuPage else { return }
			pageDetailVC.pageUrl = page.externalUrl
			pageDetailVC.pageId = page.id
		}
	}
}

private enum TableSection: Int {
	case profile = 0
	case staticMenu = 1
	case featured = 2
	case about = 3
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == TableSection.profile.rawValue { return nil } // profile header: no need
		let header = UIView()

		if section == TableSection.staticMenu.rawValue || section == TableSection.featured.rawValue {

			let titleLabel = UILabel()
			titleLabel.backgroundColor = UIColor.clear
			titleLabel.textColor = Colors.defaultText.color()
			titleLabel.font = Fonts.Primary.semiBold.toFontWith(size: 14)
			titleLabel.text = section == TableSection.staticMenu.rawValue
				? R.string.localizable.sidemenuGroupTitleStatic().localized()
				: R.string.localizable.sidemenuGroupTitleFeaturePage().localized()

			titleLabel.translatesAutoresizingMaskIntoConstraints = false
			header.addSubview(titleLabel)

			header.mf.addConstraints(
				titleLabel.top |==| header.top,
				titleLabel.right |==| header.safeArea.right |-| 16,
				titleLabel.left |==| header.safeArea.left |+| 16,
				titleLabel.height |==| header.safeArea.height)
		}

		header.backgroundColor = Colors.defaultBg.color()
		return header

	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == TableSection.profile.rawValue ||
			section == TableSection.about.rawValue { return CGFloat.leastNormalMagnitude }
		return 54
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == TableSection.profile.rawValue { return 79 }
		return 49
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == TableSection.profile.rawValue { return 1 } // profile header: no need
		if section == TableSection.staticMenu.rawValue { return viewModel.totalStaticItems }
		if section == TableSection.featured.rawValue { return viewModel.totalFeaturePageItems }
		return viewModel.totalStaticPageItems
	}

	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = cell as? MenuProfileCell {
			cell.cancelDownloadTask()
		} else if let cell = cell as? MenuCell {
			cell.cancelDownloadTask()
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == TableSection.profile.rawValue {
			if let profileCell = tableView.dequeueReusableCell(withIdentifier:
				R.reuseIdentifier.menuProfileCellId.identifier, for: indexPath) as? MenuProfileCell {
				profileCell.updateView(user: Components.sessionRepository.currentSession?.user)
				return profileCell
			}
		}
		
		if indexPath.section == TableSection.staticMenu.rawValue
			|| indexPath.section == TableSection.featured.rawValue {
			if let cell = tableView.dequeueReusableCell(withIdentifier:
				R.reuseIdentifier.menuCellId.identifier, for: indexPath) as? MenuCell {
				if indexPath.section == TableSection.staticMenu.rawValue {
					if let staticPage = viewModel.staticPageItemAt(index: indexPath.row) {
						cell.updateWithStaticItem(menuItem: staticPage)
					}
				} else {
					if let featurePage = viewModel.featurePageItemAt(index: indexPath.row) {
						updateLogo(forCell: cell, atIndexPath: indexPath, withPage: featurePage)
						cell.updateView(menuItem: featurePage)
					}
				}
				return cell
			}
		}

		let bottomCell = UITableViewCell()
		if let aboutMenuItem = viewModel.aboutItemAt(index: indexPath.row) {
			bottomCell.textLabel?.text = aboutMenuItem.name
			bottomCell.textLabel?.font = Fonts.Primary.regular.toFontWith(size: 12)
			bottomCell.textLabel?.highlightedTextColor = Colors.defaultAccentColor.color()
			bottomCell.backgroundColor = Colors.defaultBg.color()
			bottomCell.tintColor = Colors.defaultText.color()
			bottomCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
			
			if indexPath.row == viewModel.totalStaticPageItems - 1 {
				bottomCell.textLabel?.textAlignment = .center
				bottomCell.textLabel?.font = Fonts.Primary.semiBold.toFontWith(size: 10)
				bottomCell.isUserInteractionEnabled = false
			}
		}
		return bottomCell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		setSelectedItemWith(indexPath: indexPath)
		
		// Go to User profile
		if indexPath.section == TableSection.profile.rawValue {
			dismissSideMenu(true)
			menuNavigator?.pushUserProfile()
			return
		}
		
		// Go to Static Menu
		if indexPath.section == TableSection.staticMenu.rawValue,
			let staticPage = viewModel.staticPageItemAt(index: indexPath.row) {
			if staticPage.type == .appsAndGames {
				dismissSideMenu(true)
				menuNavigator?.pushAppsAndGames()
				return
			}
			if staticPage.type == .favorites {
				dismissSideMenu(true)
				menuNavigator?.pushStarPageListing()
				return
			}
			if staticPage.type == .channels {
				dismissSideMenu(true)
				menuNavigator?.pushChannelListing()
				return
			}
		}
		
		// Go to Featured
		if indexPath.section == TableSection.featured.rawValue,
			let page = viewModel.featurePageItemAt(index: indexPath.row) {
			// Go to page detail
			dismissSideMenu(true)
			menuNavigator?.pushPageDetail(pageUrl: page.externalUrl, pageId: page.id)
			return
		}
		
		// Go to StaticPage
		if indexPath.section == TableSection.about.rawValue {
			self.selectedStaticPageAt(indexPath: indexPath)
			return
		}
		
		showAlert()
	}
	
	private func selectedStaticPageAt(indexPath: IndexPath) {
		
		if let pageEnum = StaticPageEnum(rawValue: indexPath.row),
			let staticPageItem = viewModel.aboutItemAt(index: pageEnum.rawValue) {
			
			switch pageEnum {
			case .shahid, .goboz, .gobx, .mbc3, .mbccsr, .phd, .irec, .corporate, .freequency:
				if let urlString = staticPageItem.url {
					guard let url = URL(string: urlString) else { showAlert(); return }
					self.openInAppBrowser(url: url)
				}
			case .aboutsite, .tos, .privacy:
				if let url = URL(string: staticPageItem.url!) {
					dismissSideMenu(true)
					menuNavigator?.pushStaticPageInApp(url: url, title: staticPageItem.name)
				} else { showAlert() }
			case .contactus, .advertise:
				dismissSideMenu(true)
				menuNavigator?.pushFormViewController(type: pageEnum)
			case .signout:
				self.viewModel.signout()
			case .copyRight, .none: break
			}
		}
	}
	
	private func setSelectedItemWith(indexPath: IndexPath) {
		selectedItem = (indexPath, nil)
		
		if indexPath.section == TableSection.featured.rawValue {
			selectedItem?.featured = viewModel.featurePageItemAt(index: indexPath.row)
		}
	}
	
	private func showAlert() {
		self.alert(title: R.string.localizable.commonAlertTitleWarning().localized(),
				   message: R.string.localizable.commonAlertMessageNotSupported().localized()) {
					
		}
	}
	
	private func updateLogo(forCell: MenuCell, atIndexPath: IndexPath, withPage: MenuPage) {
		if let record = menuLogos[atIndexPath.row] {
			if record.imageURLString != withPage.logo {
				record.icon = nil
				record.imageURLString = withPage.logo
			}
		} else {
			let record = RemoteImage()
			record.imageURLString = withPage.logo
			if record.imageURLString.isEmpty {
				record.icon = R.image.iconNoLogo()
			} else { record.icon = nil }
			menuLogos[atIndexPath.row] = record
		}
		if let record = menuLogos[atIndexPath.row] {
			if record.icon == nil {
				if !menuTableView.isDragging && !menuTableView.isDecelerating {
					startIconDownload(remoteImage: record, forIndexPath: atIndexPath, andCell: forCell)
				}
				forCell.setLogo(R.image.iconNoLogo())
			} else {
				forCell.setLogo(record.icon)
			}
		}
	}
	
	private func startIconDownload(remoteImage: RemoteImage, forIndexPath: IndexPath, andCell: MenuCell) {
		var iconDownloader = imageDownloadsInProgress[forIndexPath]
		if iconDownloader == nil {
			iconDownloader = IconDownloader()
			iconDownloader?.remoteImage = remoteImage
			iconDownloader?.completionHandler = { [weak self] in
				// Display the newly loaded image
				if let visiblePaths = self?.menuTableView.indexPathsForVisibleRows,
					!visiblePaths.filter({ $0 == forIndexPath }).isEmpty {
					if remoteImage.icon == nil {
						andCell.setLogo(R.image.iconNoLogo())
						remoteImage.icon = R.image.iconNoLogo()
					} else { andCell.setLogo(remoteImage.icon) }
				}
				
				// Remove the IconDownloader from the in progress list.
				// This will result in it being deallocated.
				self?.imageDownloadsInProgress.removeValue(forKey: forIndexPath)
			}
			imageDownloadsInProgress[forIndexPath] = iconDownloader
			iconDownloader?.startDownload()
		}
	}
	
	// -------------------------------------------------------------------------------
	//	loadImagesForOnscreenRows
	//  This method is used in case the user scrolled into a set of cells that don't
	//  have their app icons yet.
	// -------------------------------------------------------------------------------
	private func loadImagesForOnscreenRows() {
		guard viewModel.totalFeaturePageItems > 0,
			let visiblePaths = menuTableView.indexPathsForVisibleRows else { return }
		for indexPath in visiblePaths {
			guard let remoteImage = menuLogos[indexPath.row] else { continue }
			
			if remoteImage.icon == nil { // Avoid the app icon download if the app already has an icon
				guard let featurePageCell = menuTableView.cellForRow(at: indexPath) as? MenuCell else { continue }
				startIconDownload(remoteImage: remoteImage, forIndexPath: indexPath, andCell: featurePageCell)
			}
		}
	}
}

extension MenuViewController: UIScrollViewDelegate {
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate { loadImagesForOnscreenRows() }
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		loadImagesForOnscreenRows()
	}
}
