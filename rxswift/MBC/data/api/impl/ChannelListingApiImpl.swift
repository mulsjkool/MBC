//
//  ChannelListingApiImpl.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class ChannelListingApiImpl: BaseApiClient<[PageDetailEntity]>, ChannelListingApi {

    private static let getChannelListingPath
        = "/content-presentations/pages/channel/list?inCampaign=false&sort=publishedDate:desc&fromIndex=%d&size=%d"

    func getListChannel(fromIndex: Int, size: Int) -> Observable<[PageDetailEntity]> {
        let path = String(format: ChannelListingApiImpl.getChannelListingPath, fromIndex, size)
        return apiClient.get(path,
                             parameters: nil,
                             errorHandler: { _, error -> Error in
                                return error
        }, parse: jsonTransformer)
    }
}
