//
//  AnalyticsShow.swift
//  MBC
//
//  Created by Tram Nguyen on 2/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

class AnalyticsShow {

    let pageAddress: String
    let showID: String
    let showName: String
    let showType: String
    let showSeason: String
    let showDialect: String
    let showGenre: String
    let showProductionYear: String

    init(pageDetail: PageDetail, pageAddress: String) {
        self.pageAddress = pageAddress
        self.showID = pageDetail.entityId
        self.showName = pageDetail.metadata?["arabicTitle"] as? String ?? ""
        self.showType = pageDetail.subType ?? ""
        self.showSeason = pageDetail.metadata?["seasonNumber"] as? String ?? ""
        self.showDialect = pageDetail.dialect ?? ""
        self.showGenre = pageDetail.genres?.joined(separator: ",") ?? ""
        self.showProductionYear = pageDetail.metadata?["yearDebuted"] as? String ?? ""
    }

}

extension AnalyticsShow: IAnalyticsTrackingObject {

    func getContentID() -> String {
        return showID
    }

    func getEventName() -> String {
        return AnalyticsEventName.pageView.rawValue
    }

    func getEventCategory() -> String {
        return AnalyticsEventCategory.showMetadata.rawValue
    }

    func getParameters() -> [String: Any] {
        var parameters = AnalyticsTrackingHelper.getBaseParameters(trackingObject: self)

        parameters += [AnalyticsOtherVariable.pageAddress.rawValue: pageAddress,
                       AnalyticsShowVariable.showID.rawValue: showID,
                       AnalyticsShowVariable.showName.rawValue: showName,
                       AnalyticsShowVariable.showType.rawValue: showType,
                       AnalyticsShowVariable.showSeason.rawValue: showSeason,
                       AnalyticsShowVariable.showDialect.rawValue: showDialect,
                       AnalyticsShowVariable.showGenre.rawValue: showGenre,
                       AnalyticsShowVariable.showProductionYear.rawValue: showProductionYear
        ]

        return parameters
    }

}
