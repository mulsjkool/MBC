//
//  SearchStatisticEntity.swift
//  MBC
//
//  Created by Tri Vo on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

class SearchStatisticEntity {
	var numberOfGeneralContents: Int
	var numberOfPages: Int
	var numberOfVideos: Int
	var numberOfNews: Int
	var numberOfPhotos: Int
	var numberOfApps: Int
	var numberOfPlaylist: Int
	var numberOfBundles: Int
	
	init(numberOfGeneralContents: Int, numberOfPages: Int, numberOfVideos: Int, numberOfNews: Int, numberOfPhotos: Int,
		 numberOfApps: Int, numberOfPlaylist: Int, numberOfBundles: Int) {
		self.numberOfGeneralContents = numberOfGeneralContents
		self.numberOfPages = numberOfPages
		self.numberOfVideos = numberOfVideos
		self.numberOfNews = numberOfNews
		self.numberOfPhotos = numberOfPhotos
		self.numberOfApps = numberOfApps
		self.numberOfPlaylist = numberOfPlaylist
		self.numberOfBundles = numberOfBundles
	}
}
