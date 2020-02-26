//
//  PageDataFactory.swift
//  MBCTests
//
//  Created by Dao Le Quang on 12/8/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation
@testable import MBC

class PageDataFactory {
    static func getDefaultPage(pageId: String) -> Page {
        let page = Page(id: "page_id_1")
        return page
    }
    
    static func getListPage(ids: [String]) -> [Page] {
        var pages = [Page]()
        for id in ids {
            pages.append(Page(id: id))
        }
        return pages
    }
    
    static func getPageDetail(id: String) -> PageDetail {
        return PageDetail(id: id)
    }
    
    static func getNewsFeedItems(ids: [String]) -> ItemList {
        var list = [Post]()
        for id in ids {
            list.append(Post(id: id))
        }
        
        return ItemList(items: list)
    }
    
    static func getAlbumsList(ids: [String]) -> ItemList {
        var list = [Media]()
        for id in ids {
            list.append(Media(id: id))
        }
        
        return ItemList(items: list)
    }
}

extension Post {
    convenience init(id: String) {
        let pEntity = FeedEntity(uuid: id, publishedDate: Date(), type: "", subType: "", numberOfLikes: 0,
                                 numberOfComments: 0, paragraphs: [], interests: [], title: "String?", label: "",
                                 universalUrl: "", author: nil)
        self.init(entity: pEntity)
    }
}

extension Media {
    convenience init(id: String) {
        let mEntity = MediaEntity(id: id, uuid: "", description: "", sourceLink: "", sourceLabel: "",
                                  universalUrl: "", label: "", interests: [], hasTag2Page: true, publishedDate: Date(),
                                  tags: "", link: "", originalLink: "")
        self.init(entity: mEntity)
    }
}

extension Page {
    convenience init(id: String) {
        let pageE = PageEntity(id: id, title: "", logo: "", externalUrl: "")
        self.init(entity: pageE)
    }
}

extension PageDetail {
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
                                         accentColor: "#abcdef", headerColor: "#defefe")
        let pMeta = PageMetadataEntity(fullName: "", pageSubType: "", channelName: "",
                                       channelShortName: "", genreName: "", yearDebuted: "",
                                       occupations: [], playerNickName: "", votingNumber: 1,
                                       gender: "", establishedYear: Date(), sequelNumber: "",
                                       seasonNumber: "", liveRecorded: "", pageSubTypeData: nil, venueAddress: nil)
        
        let pd = PageDetailEntity(entityId: id, status: "", publishedDate: Date(), type: "",
                                  createdDate: Date(), universalUrl: "", pageInfo: pInfo,
                                  pageSetting: pSetting, pageMetadata: pMeta)
        self.init(entity: pd)
    }
}
