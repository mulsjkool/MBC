//
//  AppWhitePageViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class AppWhitePageViewModel: BaseViewModel {
    
    private var interactor: AppWhitePageInteractor!
    private let startLoadContentByIdOnDemand = PublishSubject<Void>()
    private let startLoadContentByUrlOnDemand = PublishSubject<Void>()
	
    var onDidGetError = PublishSubject<Error>()
    var onWillStartGetItem = PublishSubject<Void>()
    var onWillStopGetItem = PublishSubject<Void>()
    
    var pageUrl: String!
    var app: App?
	var contentId: String!
    
    init(interactor: AppWhitePageInteractor) {
        self.interactor = interactor
        super.init()
        setUpRx()
    }
    
    func getAppDetail() {
        if let pageId = contentId, !pageId.isEmpty {
            startLoadContentByIdOnDemand.onNext(())
        } else {
            startLoadContentByUrlOnDemand.onNext(())
        }
    }
    
    // MARK: Private functions
	
	private func setUpRx() {
		setUpRxForGetItem()
	}
    
    private func setupData() {
        contentId = app?.contentId
        pageUrl = app?.universalUrl
        onWillStopGetItem.onNext(())
    }
    
    private func setUpRxForGetItem() {
        startLoadContentByIdOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetItem.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<Feed?> in
                guard let contentId = self.contentId else { return Observable.empty() }
                return self.interactor.getContentPage(pageId: contentId)
                    .catchError { _ in
                        self.startLoadContentByUrlOnDemand.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] feed in
                if let app = feed as? App {
                    self.app = app
                    self.setupData()
                } else {
                    self.startLoadContentByUrlOnDemand.onNext(())
                }
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
        
        startLoadContentByUrlOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetItem.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<(Feed?, PageDetail?, String?)> in
                return self.interactor.getContentPage(pageUrl: self.pageUrl!)
                    .catchError { error -> Observable<(Feed?, PageDetail?, String?)> in
                        self.onDidGetError.onNext(error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] feed, _, redirectUrl in
                if let app = feed as? App {
                    self.app = app
                    self.setupData()
                } else if let redirectUrl = redirectUrl {
                    self.pageUrl = redirectUrl
                    self.startLoadContentByUrlOnDemand.onNext(())
                } else {
                    self.onDidGetError.onNext(ApiError.dataNotAvailable(description:
                        R.string.localizable.errorDataNotAvailable()))
                }
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
}
