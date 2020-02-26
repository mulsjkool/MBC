//
//  SearchStatistic.swift
//  MBC
//
//  Created by Tri Vo on 3/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class SearchStatistic: Codable {
	var numberOfGeneralContents: Int
	var numberOfPages: Int
	var numberOfVideos: Int
	var numberOfNews: Int
	var numberOfPhotos: Int
	var numberOfApps: Int
	var numberOfPlaylist: Int
	var numberOfBundles: Int

	init(entity: SearchStatisticEntity) {
		self.numberOfGeneralContents = entity.numberOfGeneralContents
		self.numberOfPages = entity.numberOfPages
		self.numberOfVideos = entity.numberOfVideos
		self.numberOfPhotos = entity.numberOfPhotos
		self.numberOfNews = entity.numberOfNews
		self.numberOfApps = entity.numberOfApps
		self.numberOfPlaylist = entity.numberOfPlaylist
		self.numberOfBundles = entity.numberOfBundles
	}
	
	func getNumber(type: SearchItemEnum) -> Int {
		switch type {
		case .all, .allExcludePage: return numberOfGeneralContents
		case .pages: return numberOfPages
		case .videos: return numberOfVideos
		case .photos: return numberOfPhotos
		case .articles: return numberOfNews
		case .apps: return numberOfApps
		case .playlist: return numberOfPlaylist
		case .bundle: return numberOfBundles
		}
	}

	func convertToSearchMenuItem() -> [SearchMenuItem] {
		var searchMenuItems: [SearchMenuItem] = []
		if numberOfGeneralContents > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfGeneralContents,
			                                                         title: R.string.localizable.searchResultAll()),
													type: .all))
		}
		if numberOfPages > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfPages,
																	 title: R.string.localizable.searchResultPages()),
													type: .pages))
		}
		if numberOfVideos > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfVideos,
																	 title: R.string.localizable.searchResultVideos()),
													type: .videos))
		}
		if numberOfPhotos > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfPhotos,
																	 title: R.string.localizable.searchResultPhotos()),
													type: .photos))
		}
		if numberOfNews > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfNews,
																	 title: R.string.localizable.searchResultArticles()),
													type: .articles))
		}
		if numberOfApps > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfApps,
																	 title: R.string.localizable.searchResultApps()),
													type: .apps))
		}
		if numberOfPlaylist > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfPlaylist,
																	 title: R.string.localizable.searchResultPlaylists()),
													type: .playlist))
		}
		if numberOfBundles > 0 {
			searchMenuItems.append(SearchMenuItem(title: formatTitle(number: numberOfBundles,
																	 title: R.string.localizable.searchResultBundles()),
													type: .bundle))
		}
		return searchMenuItems
	}

	private func formatTitle(number: Int, title: String) -> String {
		return  R.string.localizable.searchResultMenuItem(number.description, title)
	}
}
