//
//  SearchItemEnum.swift
//  MBC
//
//  Created by Tri Vo on 3/1/18.
//  Copyright © 2018 MBC. All rights reserved.
//

enum SearchItemEnum: String {
	case all
    case allExcludePage = "all_exclude_page" // use load more with all search type 
	case pages
	case videos
	case photos
	case articles = "news"
	case apps
	case playlist
	case bundle
	
	static let allItems = [
		SearchMenuItem(title: R.string.localizable.searchResultAll(), type: .all),
		SearchMenuItem(title: R.string.localizable.searchResultPages(), type: .pages),
		SearchMenuItem(title: R.string.localizable.searchResultVideos(), type: .videos),
		SearchMenuItem(title: R.string.localizable.searchResultPhotos(), type: .photos),
		SearchMenuItem(title: R.string.localizable.searchResultArticles(), type: .articles),
		SearchMenuItem(title: R.string.localizable.searchResultApps(), type: .apps),
		SearchMenuItem(title: R.string.localizable.searchResultPlaylists(), type: .playlist),
		SearchMenuItem(title: R.string.localizable.searchResultBundles(), type: .bundle)
	]
}
