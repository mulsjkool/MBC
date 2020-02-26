//
//  AppUpgradeServiceImpl.swift
//  MBC
//
//  Created by Dung Nguyen on 3/7/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class AppUpgradeServiceImpl: AppUpgradeService {
    
    private let appVersionApi: AppVersionApi
    let disposeBag = DisposeBag()

    // Subjects Declaration
    private let startToGetAppVersionOnDemand = PublishSubject<Void>()
    private var didGetAppVersionSuccessSubject: Observable<AppVersion>!
    private let didGetAppVersionErrorSubject = PublishSubject<Error>()
    private let onWillStartGetAppVersion = PublishSubject<Void>()
    private let onWillStopGetAppVersion = PublishSubject<Void>()
    // MARK: public variables
    
    init(appVersionApi: AppVersionApi) {
        self.appVersionApi = appVersionApi
        setupRx()
    }

    // MARK: Public functions & Properties

    var onAppVersionUpgradeSuccess: Observable<AppVersion> {
        return didGetAppVersionSuccessSubject
    }
    
    var onAppVersionUpgradeError: Observable<Error> {
        return didGetAppVersionErrorSubject.asObserver()
    }
    
    func startGetAppVersion() {
        startToGetAppVersionOnDemand.onNext(())
    }
    
    private func setupRx() {
        self.didGetAppVersionSuccessSubject = startToGetAppVersionOnDemand
            .do(onNext: { _ in
                self.onWillStartGetAppVersion.onNext(())
            })
            .flatMap { [unowned self] _ -> Observable<AppVersion> in
                return self.appVersionApi.getAppVersionWith(version: Components.config.appVersion,
                                                            region: Components.sessionService.countryCode)
                    .map { appversionEntity in
                        let appVersion = AppVersion(entity: appversionEntity)
                        return appVersion
                    }
                    .catchError { [unowned self] error -> Observable<AppVersion> in
                        self.didGetAppVersionErrorSubject.onNext(error)
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in
                self.onWillStopGetAppVersion.onNext(())
            })
    }
}
