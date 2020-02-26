//
//  DashboardViewModel.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift

class DashboardViewModel: BaseViewModel {
    
    // MARK: public variables
    
    private let autheticationService: AuthenticationService
    private let appUpgradeVersionService: AppUpgradeService
    
    // Subjects Declaration
    private let startToGetAppVersionOnDemand = PublishSubject<Void>()
    var onDidGetAppVersion: Observable<AppVersion>!
    var onAppVersionUpgradeError: Observable<Error>!
    var onWillStartToGetAppVersion = PublishSubject<Void>()
    var onWillStopToGetAppVersion = PublishSubject<Void>()
    
    // MARK: public variables
    var region: String!
    
    private let startLoadOnDemand = PublishSubject<Void>()
    
    var onWillStartGetItem = PublishSubject<Void>()
    var onWillStopGetItem = PublishSubject<(PageDetail?)>()
    var onDidGetError = PublishSubject<Error>()
    
    private var pageUrl: String!
    
    var onForceToSignout: Observable<Void> {
        return autheticationService.onForceToSignout
    }
    
    init(autheticationService: AuthenticationService,
         appUpgradeVersionService: AppUpgradeService) {
        self.autheticationService = autheticationService
        self.appUpgradeVersionService = appUpgradeVersionService
        super.init()
        
        setupRxForUpgradeAppVersion()
    }
    
    // MARK: Public functions & Properties
    
    func startGetAppVersion() {
        appUpgradeVersionService.startGetAppVersion()
    }
    
    // MARK: Private functions & Properties

    func setupRxForUpgradeAppVersion() {
        
        onDidGetAppVersion = appUpgradeVersionService.onAppVersionUpgradeSuccess
        onAppVersionUpgradeError = appUpgradeVersionService.onAppVersionUpgradeError
            .do(onNext: { [unowned self] error in
                self.showError(error: error)
            })
    }
}
