//
//  AnalyticsShow.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsShowPage: BaseAnalyticsTracking {

    private let pageAddress: String
    private let showID: String
    private let showName: String
    private let showType: String
    private let showSeason: String
    private let showDialect: String
    private let showGenre: String
    private let showProductionYear: String
    private let showOnAirStatus: PageShowOnAirStatus
    private let showTVChannel: String

    init(pageDetail: PageDetail, pageAddress: String) {
        self.pageAddress = pageAddress
        self.showID = pageDetail.entityId
        self.showName = pageDetail.metadata?["arabicTitle"] as? String ?? ""
        self.showType = pageDetail.subType ?? ""
        self.showSeason = pageDetail.metadata?["seasonNumber"] as? String ?? ""
        self.showDialect = pageDetail.dialect ?? ""
        self.showGenre = pageDetail.genres?.joined(separator: ",") ?? ""
        self.showProductionYear = pageDetail.metadata?["yearDebuted"] as? String ?? ""

        if let airTimeInformation = pageDetail.metadata?["airTimeInformation"] as? NSArray,
            let info = airTimeInformation.firstObject as? [String: Any] {

            if let startDate = info["startDate"] as? Double {
                let broadcastDate = Date(timeIntervalSince1970: TimeInterval(startDate / 1000))
                let clientDate = Date()

                if broadcastDate.equalToDate(dateToCompare: clientDate) {
                    self.showOnAirStatus = .onAir
                } else if broadcastDate.isLessThanDate(dateToCompare: clientDate) {
                    self.showOnAirStatus = .archived
                } else {
                    self.showOnAirStatus = .coming
                }
            } else {
                self.showOnAirStatus = .unknown
            }

            self.showTVChannel = info["showLabel"] as? String ?? ""
        } else {
            self.showOnAirStatus = .unknown
            self.showTVChannel = ""
        }
    }

}

extension AnalyticsShowPage: IAnalyticsTrackingObject {

    var contendID: String? {
        return showID
    }

    var eventName: String {
        return AnalyticsEventName.pageView.rawValue
    }

    var eventCategory: String {
        return AnalyticsEventCategory.showMetadata.rawValue
    }

    var parameters: [String: Any] {
        var parameters = getBaseParameters(trackingObject: self)

        parameters += [AnalyticsOtherVariable.pageAddress.rawValue: pageAddress,
                       AnalyticsShowVariable.showID.rawValue: showID,
                       AnalyticsShowVariable.showName.rawValue: showName,
                       AnalyticsShowVariable.showType.rawValue: showType,
                       AnalyticsShowVariable.showSeason.rawValue: showSeason,
                       AnalyticsShowVariable.showDialect.rawValue: showDialect,
                       AnalyticsShowVariable.showGenre.rawValue: showGenre,
                       AnalyticsShowVariable.showProductionYear.rawValue: showProductionYear,
                       AnalyticsShowVariable.showTVChannel.rawValue: showTVChannel,
                       AnalyticsShowVariable.showOnAirStatus.rawValue: showOnAirStatus.rawValue
        ]

        return parameters
    }

    var customTargeting: [String: String] {
        return [AnalyticsOtherVariable.screenPath.rawValue: pageAddress,
                AnalyticsOtherVariable.screenAddress.rawValue: pageAddress,
                "pge_showName": showName,
                "pge_showSeason": showSeason,
                "pge_showType": showType,
                "pge_tvChannel": showTVChannel,
                "pge_genre": showGenre,
                "pge_showDialect": showDialect,
                "pge_onAirStatus": showOnAirStatus.rawValue
        ]
    }

}
