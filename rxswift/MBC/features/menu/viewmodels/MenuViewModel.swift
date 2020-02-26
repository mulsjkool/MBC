//
//  MenuViewModel.swift
//  F8
//
//  Created by Dao Le Quang on 11/9/16.
//  Copyright © 2016 Tuyen Nguyen Thanh. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class MenuViewModel: BaseViewModel {
	// MARK: private variables
	private let interactor: MenuInteractor
	private var featurePages = [MenuPage]()

	// Subjects Declaration
	private let startToGetFeaturePageOnDemand = PublishSubject<Void>()
	private var signoutOnDemand = PublishSubject<Void>()
	
	// MARK: public variables
	var siteName: String!

	// Subjects Declaration
	var onDidGetFeaturePages: Observable<Void>!
	var onWillStartToGetFeaturePages = PublishSubject<Void>()
	var onWillStopToGetFeaturePages = PublishSubject<Void>()
	
	var onWillStartSignout = PublishSubject<Void>()
	var onWillStopSignout = PublishSubject<Void>()
	
	var onDidSignoutSuccess: Observable<Void>!
	
	var onShowError = PublishSubject<GigyaCodeEnum>()
	
	init(interactor: MenuInteractor) {
		self.interactor = interactor
		super.init()

		siteName = Constants.DefaultValue.SiteName
		setupRx()
	}

	// MARK: Public functions & Properties
	func startToGetFeaturePages() {
		startToGetFeaturePageOnDemand.onNext(())
	}

	var totalFeaturePageItems: Int {
		return featurePages.count
	}

	var totalStaticItems: Int {
		return StaticItemEnum.allItems.count
	}

	var totalStaticPageItems: Int {
		return StaticPageEnum.allItems.count
	}

	func featurePageItemAt(index: Int) -> MenuPage? {
		guard index < totalFeaturePageItems else { return nil }
		return featurePages[index]
	}

	func staticPageItemAt(index: Int) -> StaticMenuItem? {
		guard index < totalStaticItems else { return nil }
		return StaticItemEnum.allItems[index]
	}

	func aboutItemAt(index: Int) -> StaticPageItem? {
		guard index < totalStaticPageItems else { return nil }
		return StaticPageEnum.allItems[index]
	}

	// MARK: Private functions & Properties
	private func setupRx() {
		onDidGetFeaturePages = startToGetFeaturePageOnDemand
			.do(onNext: { [unowned self] in
				self.onWillStartToGetFeaturePages.onNext(())
			})
			.flatMap { [unowned self] _ -> Observable<[MenuPage]> in
				self.interactor.getFeaturePagesBy(siteName: self.siteName)
					.catchError { [unowned self] error -> Observable<[MenuPage]> in
						self.onWillStopToGetFeaturePages.onNext(())
						self.showError(error: error)
						return Observable.empty()
					}
			}
			.do(onNext: { [unowned self] _ in
				self.onWillStopToGetFeaturePages.onNext(())
			})
			.do(onNext: { [unowned self] fPages in
				self.featurePages = fPages
			})
			.map { _ in Void() }
		
		onDidSignoutSuccess = interactor.onDidSignoutSuccess
			.do(onNext: { [unowned self] _ in
				self.onWillStopSignout.onNext(())
			})
		
		disposeBag.addDisposables([
			signoutOnDemand
				.do(onNext: { _ in
					self.onWillStartSignout.onNext(())
					self.interactor.signout()
				})
				.subscribe(),
			interactor.onDidSignoutError
				.do(onNext: { [unowned self] error in
					self.onWillStopSignout.onNext(())
					let nsError = error as NSError
					self.onShowError.onNext(GigyaCodeEnum(rawValue: nsError.code) ??
						GigyaCodeEnum.unknownError)
				})
				.subscribe()
		])
	}
	
	func signout() {
		signoutOnDemand.onNext(())
	}
}
