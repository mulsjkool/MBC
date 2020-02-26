//
//  PageHeaderViewModel.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/30/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class PageHeaderViewModel: BaseViewModel {
    
    var scheduledChannelList: [Schedule]?
    var pageDetail: PageDetail?
    var metadataString = ""
    
    init(pageDetail: PageDetail?) {
        self.pageDetail = pageDetail
        super.init()
    }
    
    func setScheduledChannelList(_ scheduledChannelList: [Schedule]?) {
        self.scheduledChannelList = scheduledChannelList
        
        guard let pageDetail = pageDetail, let arrayAirTime = pageDetail.airTimeInformation, !arrayAirTime.isEmpty,
        let objAirTime = arrayAirTime.first(where: { $0.isDefaultRelationship == true }) else { return }
        
        guard let item = scheduledChannelList?.first(where: { $0.channel?.id == objAirTime.channel.id }) else { return }
        objAirTime.channel.logo = item.channel?.logo
    }
}
