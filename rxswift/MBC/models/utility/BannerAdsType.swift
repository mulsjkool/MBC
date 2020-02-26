//
//  BannerAdsType.swift
//  MBC
//
//  Created by Tri Vo on 3/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import GoogleMobileAds

enum AdsSize {
	// swiftlint:disable variable_name
	case ban_300_250
    case ban_970_250
	case ban_3_3
	case spon_320_113
	case spon_320_183
    case spon_984_73
    case spon_984_134
    case fluid
	// swiftlint:enable variable_name
	
    func size() -> CGSize {
        switch self {
        case .ban_300_250: return CGSize(width: 300, height: 250)
        case .ban_970_250: return CGSize(width: 970, height: 250)
        case .ban_3_3: return CGSize(width: 3, height: 3)
        case .spon_320_113: return CGSize(width: 320, height: 113)
        case .spon_320_183: return CGSize(width: 320, height: 183)
        case .spon_984_73: return CGSize(width: 984, height: 73)
        case .spon_984_134: return CGSize(width: 984, height: 134)
        case .fluid: return kGADAdSizeFluid.size
        }
    }

    static func isTeadAds(adsSize: CGSize) -> Bool {
        return adsSize.equalTo(AdsSize.ban_3_3.size())
    }

}

enum BannerAdsType {
	case banner, sponsored
	
	func adsSizes() -> [NSValue] {
		switch self {
		case .banner:
            if Constants.Singleton.isiPad {
                return [NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.ban_970_250.size())),
                        NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.ban_3_3.size())),
                        NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.fluid.size()))]
            }

			return [NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.ban_300_250.size())),
					NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.ban_3_3.size())),
					NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.fluid.size()))]
		case .sponsored:
            if Constants.Singleton.isiPad {
                return [NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.spon_984_73.size())),
                        NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.spon_984_134.size()))]
            }

			return [NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.spon_320_113.size())),
					NSValueFromGADAdSize(GADAdSizeFromCGSize(AdsSize.spon_320_183.size()))]
		}
	}
}
