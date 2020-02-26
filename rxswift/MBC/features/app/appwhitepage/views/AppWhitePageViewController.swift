//
//  AppWhitePageViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import SwiftSoup

private enum AppWhitePageSection: Int {
	case header = 0
	case ads = 1
}

class AppWhitePageViewController: BaseViewController {
    
    @IBOutlet weak private var tableView: UITableView!
	
	private var adsCells = [IndexPath: AdsContainer]() // caching ads
	private var heightAtIndexPathDict = [String: CGFloat]()
    var viewModel: AppWhitePageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getAppDetail()
        bindEvents()
    }
    
    private func setupUI() {
        showHideNavigationBar(shouldHide: false)
        addBackButton()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = Constants.DefaultValue.estimatedTableRowHeight
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.backgroundColor = Colors.defaultBg.color()
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.separatorStyle = .none
		tableView.keyboardDismissMode = .interactive
        tableView.register(R.nib.appWhitePageTableViewCell(),
                           forCellReuseIdentifier: R.reuseIdentifier.appWhitePageTableViewCell.identifier)
		tableView.register(R.nib.bannerAdsViewCell(),
						   forCellReuseIdentifier: R.reuseIdentifier.bannerAdsViewCell.identifier)
    }
    
    private func getAppDetail() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.viewModel.getAppDetail()
        })
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            viewModel.onWillStartGetItem.subscribe(onNext: { [weak self] _ in
                self?.tableView.alpha = 0.0
            }),
            viewModel.onWillStopGetItem.subscribe(onNext: { [weak self] _ in
                self?.tableView.alpha = 1.0
                self?.setupData()
            }),
            viewModel.onDidGetError.subscribe(onNext: { [weak self] _ in
                self?.showMessage(message: R.string.localizable.errorDataNotAvailable())
            })
        ])
    }
    
    private func setupData() {
        if let app = viewModel.app {
            Components.analyticsService.logEvent(trackingObject: AnalyticsApp(app: app))
            self.title = app.title ?? ""
            tableView.reloadData()
        }
    }
    
    private func reloadCell() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func appWhitePageHeaderCell(indexPath: IndexPath) -> UITableViewCell {
        guard let app = viewModel.app, let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.appWhitePageTableViewCell.identifier) as? AppWhitePageTableViewCell else {
                return UITableViewCell()
        }
        
        cell.bindData(app: app)
        cell.disposeBag.addDisposables([
            cell.didChangeWebViewHeight.subscribe(onNext: { [unowned self] _ in
                self.reloadCell()
            }),
            cell.shareTapped.subscribe(onNext: { [unowned self] data in
                self.getURLFromObjAndShare(obj: data)
            }),
			cell.commentTapped.subscribe(onNext: { [unowned self] data in
                if let navigator = self.navigator, let app = data as? App {
                    navigator.navigateToContentPage(feed: app, isShowComment: true, cell: nil)
                }
			})
        ])
        return cell
    }
	
	private func bannerAdsCell(indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:
			R.reuseIdentifier.bannerAdsViewCell.identifier) as? BannerAdsViewCell else { return UITableViewCell() }
		if let ads = adsCells[indexPath] { // requested
			if let bannerAds = ads.getBannerAds() { cell.addAds(bannerAds) }
		} else { // send request
			adsCells[indexPath] = AdsContainer(index: indexPath)
			if let ads = adsCells[indexPath] {
				ads.requestAds(adsType: .banner, viewController: self, universalUrl: viewModel.app?.universalUrl ?? "")
				ads.disposeBag.addDisposables([
					ads.loadAdSuccess.subscribe(onNext: { [unowned self] row in
						if let index = row { self.tableView.reloadRows(at: [index], with: .fade) }
                    }),

                    ads.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                        self?.openInAppBrowser(url: URL(string: urlString)!)
                    })
				])
			}
		}
		return cell
	}
}

extension AppWhitePageViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == AppWhitePageSection.header.rawValue {
			return (viewModel.app != nil) ? 1: 0
		}
		if section == AppWhitePageSection.ads.rawValue {
			return 1
		}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == AppWhitePageSection.header.rawValue {
			return appWhitePageHeaderCell(indexPath: indexPath)
		}
		if indexPath.section == AppWhitePageSection.ads.rawValue {
			return bannerAdsCell(indexPath: indexPath)
		}
		return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPathDict["\(indexPath.section)-\(indexPath.row)"],
			indexPath.section == AppWhitePageSection.header.rawValue {
            return height
        }
        return UITableViewAutomaticDimension
    }
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == AppWhitePageSection.ads.rawValue {
			if let adsCell = adsCells[indexPath], let cellHeight = adsCell.getBannerAds()?.bounds.height {
				return cellHeight + Constants.DefaultValue.paddingBannerAdsCellBottom
								+ Constants.DefaultValue.paddingBannerAdsCellTop
			}
			return 0
		}
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.section == AppWhitePageSection.header.rawValue {
        	heightAtIndexPathDict["\(indexPath.section)-\(indexPath.row)"] = cell.frame.size.height
		}
    }
	
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        showHideNavigationBar(shouldHide: velocity.y > 0, animated: true)
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		view.endEditing(true)
	}
}
