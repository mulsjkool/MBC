//
//  BundleContentViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class BundleContentViewModel: BaseViewModel {
    private var interactor: ContentPageInteractor
    private let contentPageType: ContentPageType = .postText
    
    var bundle: BundleContent?
    var pageUrl: String?
    var contentId: String!
    
    private let startLoadContentByUrlOnDemand = PublishSubject<Void>()
    private let startLoadContentByIdOnDemand = PublishSubject<Void>()
    var onWillStartGetItem = PublishSubject<Void>()
    var onWillStopGetItem = PublishSubject<Void>()
    var onDidGetError = PublishSubject<Error>()
    
    init(interactor: ContentPageInteractor) {
        self.interactor = interactor
        super.init()
        setUpRx()
    }
    
    // MARK: Private functions
    
    func getContent() {
        guard let bundle = self.bundle else {
            getContentByUrl()
            return
        }
        contentId = bundle.uuid ?? ""
        if !bundle.items.isEmpty {
            onWillStopGetItem.onNext(())
        } else {
            if contentId.isEmpty {
                getContentByUrl()
            } else {
                getContentByContentId()
            }
        }
    }
    
    private func getContentByUrl() {
        if let pageUrl = pageUrl, !pageUrl.isEmpty {
            startLoadContentByUrlOnDemand.onNext(())
        }
    }
    
    private func getContentByContentId() {
        startLoadContentByIdOnDemand.onNext(())
    }
    
    private func setUpRx() {
        setUpRxForGetItem()
    }
    
    private func setUpRxForGetItem() {
        startLoadContentByUrlOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartGetItem.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<(Feed?, PageDetail?, String?)> in
                return self.interactor.getContentPage(pageUrl: self.pageUrl!, contentPageType: self.contentPageType)
                    .catchError { error in
                        self.onDidGetError.onNext(error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] feed, _, redirectUrl in
                if let bundle = feed as? BundleContent {
                    self.bundle = bundle
                    self.onWillStopGetItem.onNext(())
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
                guard let bundle = feed as? BundleContent else {
                    self.startLoadContentByUrlOnDemand.onNext(())
                    return
                }
                self.bundle = bundle
                self.onWillStopGetItem.onNext(())
            })
            .map { _ in Void() }
            .subscribe().disposed(by: disposeBag)
    }
}
