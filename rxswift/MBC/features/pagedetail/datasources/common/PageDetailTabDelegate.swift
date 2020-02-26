//
//  PageDetailTabDelegate.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailTabDelegate: class {
    func getPageId() -> String
    func getItemList() -> ItemList
    func getAccentColor() -> UIColor?
    func reloadCell()
    func getURLFromObjAndShare(obj: Likable)
    func getBundles() -> [BundleContent]?
    func getSeasonMetadata() -> String?
    func getGenreMetadata() -> String?
    func streamInfoComponent() -> InfoComponent?
    func getLanguageConfigList() -> [LanguageConfigListEntity]?
}
