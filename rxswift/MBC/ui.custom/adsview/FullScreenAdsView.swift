//
//  FullScreenAdsView.swift
//  MBC
//
//  Created by Tri Vo on 2/8/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import MisterFusion
import RxSwift

class FullScreenAdsView: UIView {

    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var adsContainerView: UIView!
    @IBOutlet weak private var closeButtonTopConstraint: NSLayoutConstraint!
	
	private let adsContainer = AdsContainer()
    let onOpenSafari = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.fullScreenAdsView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        
        var marginTop = CGFloat(0)
        if #available(iOS 11.0, *) { } else {
            marginTop = Constants.DeviceMetric.statusBarHeight
        }
        closeButtonTopConstraint.constant += marginTop
    }
    
    func showAds(viewController: UIViewController, universalAddress: String = "") {
        guard let view = viewController.view else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        view.mf.addSubview(self, andConstraints:
            view.top |==| self.top,
            view.left |==| self.left,
            view.bottom |==| self.bottom,
            view.right |==| self.right
        )
		requestBannerAds(viewController: viewController, universalAddress: universalAddress)
    }
	
	private func requestBannerAds(viewController: UIViewController, universalAddress: String = "") {
		adsContainer.requestAds(adsType: .banner, viewController: viewController, universalUrl: universalAddress)
		adsContainer.disposeBag.addDisposables([
			adsContainer.loadAdSuccess.subscribe(onNext: { [unowned self] _ in
				self.addSponsoredAds()
            }),

            adsContainer.onOpenSafari.subscribe(onNext: { [weak self] urlString in
                self?.onOpenSafari.onNext(urlString)
            })
		])
	}
	
	private func addSponsoredAds() {
		if let adsView = adsContainer.getBannerAds() {
			adsView.translatesAutoresizingMaskIntoConstraints = false
			adsContainerView.mf.addSubview(adsView, andConstraints: [
				adsView.centerX |==| adsContainerView.centerX,
				adsView.top |==| adsContainerView.top
			])
		}
	}
    
    @IBAction func closeViewTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
}
