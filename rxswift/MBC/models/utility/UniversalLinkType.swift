//
//  UniversalLinkType.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/6/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

enum UniversalLinkType: String {
    case pages
    case apps
    case profile
    case searchResult = "search-result"
    case grid
    case staticPages = "static-pages"
    
    case sectionName
    case homeStream
    
    case none
}

enum SectionNameType: String {
    case stars
    case appsAndGames = "apps-and-games"
    case videoStream = "video-stream"
    case channels
    
    case none
}

enum UniversalPageType: String {
    case radioplayer
    case bundles
    case playlists
    
    case pageDetail
    case pageContent
    case fullScreenImage
    case bundlesPostMultiImageWithTitle
    case bundlesContent
    
    case none
}
