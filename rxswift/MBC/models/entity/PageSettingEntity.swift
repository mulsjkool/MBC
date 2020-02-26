//
//  PageSettingEntity.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Foundation

class PageSettingEntity {
    var showMenuTabs: Bool = false
    var showContentBundles: Bool = false
    var hidePageTabs: [String]
    var featureOnMainMenu: [String]
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

    init(
        showMenuTabs: Bool, showContentBundles: Bool, hidePageTabs: [String], featureOnMainMenu: [String],
        selectLandingTab: String?, allowUsersFollowPage: Bool, allowUsersWritePageFanHub: Bool,
        allowUsersSearch: Bool, hide: Bool, enableInstantPublishing: Bool, allowTag: Bool,
        enableEditorialApprovalWorkflow: Bool, searchable: Bool, accentColor: String?, headerColor: String?) {
        self.showMenuTabs = showMenuTabs
        self.showContentBundles = showContentBundles
        self.hidePageTabs = hidePageTabs
        self.featureOnMainMenu = featureOnMainMenu
        self.selectLandingTab = selectLandingTab
        self.allowUsersFollowPage = allowUsersFollowPage
        self.allowUsersWritePageFanHub = allowUsersWritePageFanHub
        self.allowUsersSearch = allowUsersSearch
        self.hide = hide
        self.enableInstantPublishing = enableInstantPublishing
        self.allowTag = allowTag
        self.enableEditorialApprovalWorkflow = enableEditorialApprovalWorkflow
        self.searchable = searchable
        self.accentColor = accentColor
        self.headerColor = headerColor
    }
}
