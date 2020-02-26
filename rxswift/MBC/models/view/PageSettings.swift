//
//  PageSettings.swift
//  MBC
//
//  Created by Khang Nguyen Nhat on 12/6/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageSettings: Codable {
    var showMenuTabs: Bool = false
    var showContentBundles: Bool = false
    var hidePageTabs = [String]()
    var featureOnMainMenu = [String]()
    var selectLandingTab: String?
    var allowUsersFollowPage: Bool = false
    var allowUsersWritePageFanHub: Bool = false
    var allowUsersSearch: Bool = false
    var hide: Bool = false
    var enableInstantPublishing: Bool = false
    var allowTag: Bool = false
    var enableEditorialApprovalWorkflow: Bool = false
    var searchable: Bool = false
    var accentColor: String?
    var headerColor: String?
    
    init(entity: PageSettingEntity?) {
        guard let entity = entity else { return }
        
        self.showMenuTabs = entity.showMenuTabs
        self.showContentBundles = entity.showContentBundles
        self.hidePageTabs = entity.hidePageTabs
        self.featureOnMainMenu = entity.featureOnMainMenu
        self.selectLandingTab = entity.selectLandingTab
        self.allowUsersFollowPage = entity.allowUsersFollowPage
        self.allowUsersWritePageFanHub = entity.allowUsersWritePageFanHub
        self.allowUsersSearch = entity.allowUsersSearch
        self.hide = entity.hide
        self.enableInstantPublishing = entity.enableInstantPublishing
        self.allowTag = entity.allowTag
        self.enableEditorialApprovalWorkflow = entity.enableEditorialApprovalWorkflow
        self.searchable = entity.searchable
        self.accentColor = entity.accentColor
        self.headerColor = entity.headerColor
    }
}
