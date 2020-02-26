//
//  PageDetailEntityDataFactory.swift
//  MBCTests
//
//  Created by Khang Nguyen Nhat on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

@testable import MBC

class PageDetailEntityDataFactory {
    
}

extension PageDetailEntity {
    convenience init(id: String) {
        let pInfo = PageInforEntity(type: "", language: LanguageEnum.arabic.rawValue,
                                    customURL: "", posterThumbnail: "", website: "",
                                    coverThumbnail: "", internalUniquePageName: "", title: "",
                                    logoThumbnail: "")
        let pSetting = PageSettingEntity(showMenuTabs: true, showContentBundles: true,
                                         hidePageTabs: [], featureOnMainMenu: [],
                                         selectLandingTab: "", allowUsersFollowPage: true,
                                         allowUsersWritePageFanHub: true, allowUsersSearch: true,
                                         hide: true, enableInstantPublishing: true, allowTag: true,
                                         enableEditorialApprovalWorkflow: true, searchable: true,
                                         accentColor: "#abcdef", headerColor: "String?")
        let pMeta = PageMetadataEntity(fullName: "", pageSubType: "", channelName: "",
                                       channelShortName: "", genreName: "", yearDebuted: Date(),
                                       occupations: [], playerNickName: "", votingNumber: 1,
                                       gender: "", establishedYear: Date(), sequelNumber: "",
                                       seasonNumber: "", liveRecorded: "", pageSubTypeData: nil, venueAddress: nil)
        
        self.init(entityId: id, status: "", publishedDate: Date(), type: "",
                  createdDate: Date(), universalUrl: "", pageInfo: pInfo,
                  pageSetting: pSetting, pageMetadata: pMeta)
    }
}

extension AlbumEntity {
    convenience init(id: String) {
        self.init(id: id, mediaList: [], title: "", description: "", cover: nil, publishedDate: Date(),
                  contentId: "", total: 0, currentPosition: 0)
        
    }
}

extension FeedEntity {
    convenience init(id: String) {
        self.init(uuid: id, publishedDate: Date(), type: "post", subType: "", numberOfLikes: 0, numberOfComments: 0,
                  paragraphs: [], interests: [], title: "", label: "", universalUrl: "", author: nil)
    }
}
