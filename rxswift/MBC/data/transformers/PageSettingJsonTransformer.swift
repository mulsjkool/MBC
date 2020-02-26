//
//  PageSettingJsonTransformer.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 11/29/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import SwiftyJSON
import UIKit

class PageSettingJsonTransformer: JsonTransformer {
    private static let fields = (
        showMenuTabs: "showMenuTabs",
        showContentBundles: "showContentBundles",
        hidePageTabs: "hidePageTabs",
        featureOnMainMenu: "featureOnMainMenu",
        selectLandingTab: "selectLandingTab",
        allowUsersFollowPage: "allowUsersFollowPage",
        allowUsersWritePageFanHub: "allowUsersWritePageFanHub",
        allowUsersSearch: "allowUsersSearch",
        hide: "hide",
        enableInstantPublishing: "enableInstantPublishing",
        allowTag: "allowTag",
        enableEditorialApprovalWorkflow: "enableEditorialApprovalWorkflow",
        searchable: "searchable",
        accentColor: "accentColor",
        headerColor: "headerColor"
    )

    func transform(json: JSON) -> PageSettingEntity {
        let fields = PageSettingJsonTransformer.fields

        let showMenuTabs = json[fields.showMenuTabs].bool ?? false
        let showContentBundles = json[fields.showContentBundles].bool ?? false
        var hidePageTabs = [String]()
        if let hidePageTabsJSON = json[fields.hidePageTabs].array {
            hidePageTabs = hidePageTabsJSON.map({ jsonValue in
                return jsonValue.stringValue
            })
        }

        var featureOnMainMenu = [String]()
        if let featureOnMainMenuJSON = json[fields.featureOnMainMenu].array {
            featureOnMainMenu = featureOnMainMenuJSON.map({ jsonValue in
                return jsonValue.stringValue
            })
        }
        let selectLandingTab = json[fields.selectLandingTab].string
        let allowUsersFollowPage = json[fields.allowUsersFollowPage].bool ?? false
        let allowUsersWritePageFanHub = json[fields.allowUsersWritePageFanHub].bool ?? false
        let allowUsersSearch = json[fields.allowUsersSearch].bool ?? false
        let hide = json[fields.hide].bool ?? false
        let enableInstantPublishing = json[fields.enableInstantPublishing].bool ?? false
        let allowTag = json[fields.allowTag].bool ?? false
        let enableEditorialApprovalWorkflow = json[fields.enableEditorialApprovalWorkflow].bool ?? false
        let searchable = json[fields.searchable].bool ?? false
        let accentColor = json[fields.accentColor].string
        let headerColor = json[fields.headerColor].string

        return PageSettingEntity(
            showMenuTabs: showMenuTabs, showContentBundles: showContentBundles, hidePageTabs: hidePageTabs,
            featureOnMainMenu: featureOnMainMenu, selectLandingTab: selectLandingTab,
            allowUsersFollowPage: allowUsersFollowPage, allowUsersWritePageFanHub: allowUsersWritePageFanHub,
            allowUsersSearch: allowUsersSearch, hide: hide, enableInstantPublishing: enableInstantPublishing,
            allowTag: allowTag, enableEditorialApprovalWorkflow: enableEditorialApprovalWorkflow,
            searchable: searchable, accentColor: accentColor, headerColor: headerColor)
    }
}
