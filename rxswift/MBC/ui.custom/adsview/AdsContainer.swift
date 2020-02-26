//
//  AdsContainer.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/12/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMobileAds
import SafariServices

class AdsContainer: NSObject {
	let loadAdSuccess = PublishSubject<IndexPath?>()
	let loadAdFail = PublishSubject<Void>()
    let onOpenSafari = PublishSubject<String>()
	let disposeBag = DisposeBag()
	
	var adsView: DFPBannerView?
	var teadsAd: TeadsAd?
	
	var indexPath: IndexPath?
	var resultBannerAds: GADBannerView?

    private var tracker: DMSMoatNativeDisplayTracker?
	
	init(index: IndexPath? = nil) {
		self.indexPath = index
	}

    private func createTracker() {
        guard let adView = teadsAd?.videoView() ?? adsView else { return }
        tracker = DMSMoatNativeDisplayTracker(adView: adView, withAdIds: Constants.Singleton.lotemaParams)
        tracker?.trackerDelegate = self
        tracker?.startTracking()
    }
	
	func requestAds(adsType: BannerAdsType, viewController: UIViewController, universalUrl: String = "") {
        if tracker != nil {
            tracker?.stopTracking()
            tracker = nil
        }

		adsView = DFPBannerView()
		adsView!.adUnitID = Constants.DefaultValue.AdsDomain
		adsView!.rootViewController = viewController
		adsView!.validAdSizes = adsType.adsSizes()
		adsView!.delegate = self
        adsView!.appEventDelegate = self

		let request = DFPRequest()
		request.customTargeting = buildCustomTarget()
		request.testDevices = [kGADSimulatorID, kDFPSimulatorID, "259dc9c5cc113ef275e6ad9ee3b2bb01"]
		adsView!.load(request)
	}
	
	func getBannerAds() -> GADBannerView? {
		return resultBannerAds
	}
	
	private func requestAdsTeads() {
		self.teadsAd = TeadsAd(placementId: Constants.DefaultValue.TeadsAdsPID, delegate: self)
//		self.teadsAd!.videoView().frame = self.bounds
//		self.addSubview(self.teadsAd!.videoView())
		self.teadsAd!.videoViewWasAdded()
		self.teadsAd!.load()
	}
	
	private func buildCustomTarget() -> [AnyHashable: Any] {
		var lotemaParams = Constants.Singleton.lotemaParams
		Components.analyticsService.customTargeting.forEach { if !$1.isEmpty { lotemaParams[$0] = $1 } }
		lotemaParams.forEach { if let text = $1 as? String, text.isEmpty { lotemaParams.removeValue(forKey: $0) } }
		if let screenAdress = lotemaParams["ScreenAddress"] as? String, !screenAdress.isEmpty {
			let pathlevels = screenAdress.components(separatedBy: "/")
			var index = 0
			pathlevels.forEach {
				if !$0.isEmpty {
					lotemaParams[String(format: "pathlv\(index)")] = $0
					index += 1
				}
			}
		}
		return lotemaParams
	}
}

extension AdsContainer: DMSMoatTrackerDelegate {

    func trackerStartedTracking(_ tracker: DMSMoatBaseTracker!) {
        print("MOAT - Started tracking")
    }

    func trackerStoppedTracking(_ tracker: DMSMoatBaseTracker!) {
        print("MOAT - Stopped tracking")
    }

    func tracker(_ tracker: DMSMoatBaseTracker!, failedToStartTracking type: DMSMoatStartFailureType, reason: String!) {
        print("MOAT - failedToStartTracking with reason: " + reason)
    }

}

extension AdsContainer: TeadsAdDelegate {
	func teadsAdDidLoad(_ ads: TeadsAd!) {
		print("TEADS AD LOAD SUCCESS")
//		adsSize = ads.videoView().frame.size
//		loadAdSuccess.onNext(adsSize)
        createTracker()
	}
	
	func teadsAd(_ ads: TeadsAd!, didFailLoading error: TeadsError!) {
		print("TEADS AD FAIL TO LOAD")
//		loadAdFail.onNext(())
	}
}

extension AdsContainer: GADAppEventDelegate {

    func adView(_ banner: GADBannerView, didReceiveAppEvent name: String, withInfo info: String?) {
        print("adViewDidReceiveAd: AppEvent is " + name)

        if name == "mv-ad-load" {
            print("adViewDidReceiveAd: mv-ad-load is " + (info ?? ""))
        } else if name == "mv-ad-click" {
            guard let data = info?.data(using: .utf8) else { return }

            let dictionary = try? JSONSerialization.jsonObject(with: data,
                                                               options: JSONSerialization.ReadingOptions.allowFragments)

            guard let dict = dictionary as? [String: Any] else { return }

            let url = dict["url"] as? String

            guard let lala = url else { return }

            var urlString: String = lala

            if lala.contains("mvi=") {
                let urlParts = lala.components(separatedBy: "mvi=")

                if urlParts.count > 1 {

                    let identifier = urlParts[1]

                    urlString = "http://www.mbc.net/sponsored?mvi=\(identifier)"
                }
            }

            onOpenSafari.onNext(urlString)
        }
    }

}

extension AdsContainer: GADBannerViewDelegate {
	func adViewDidReceiveAd(_ bannerView: GADBannerView) {
		let adsSize = bannerView.bounds.size

        if AdsSize.isTeadAds(adsSize: adsSize) {
            requestAdsTeads()
        } else {
			resultBannerAds = bannerView
            createTracker()
			loadAdSuccess.onNext(indexPath)

            print("adViewDidReceiveAd: SUCCESS - NOTHING")
        }
	}
	
	func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
		print("adViewDidReceiveAd: FAIL - \(error.localizedDescription)")
		loadAdFail.onNext(())
	}
}
