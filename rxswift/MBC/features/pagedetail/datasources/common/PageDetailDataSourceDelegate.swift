//
//  PageDetailDataSourceDelegate.swift
//  MBC
//
//  Created by Tram Nguyen on 2/25/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailDataSourceDelegate: class {
    func reloadCell()
	func reloadCell(at indexPath: IndexPath)
    func reloadCellIn(section: Int)
    func getURLFromObjAndShare(obj: Likable)
    func showFullscreenImageDefaultAlbum(defaultAlbum: PhotoDefaultAlbum)
    func showPopupComment(pageId: String?, contentId: String?, contentType: String)
    func showFullScreenImageFromCustomAlbum(customAlbum: PhotoCustomAlbum)
    func pushAppWhitePage(app: App)
    func navigateToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?)
    func showFullscreenImage(_ feed: Feed, accentColor: UIColor?, pageId: String, imageIndex: Int, imageId: String)
    func pushVideoPlaylistFrom(customPlaylist: VideoPlaylist)
    func pushVideoPlaylistFromDefault(defaultPlaylist: VideoDefaultPlaylist, videoId: String?)
    func pushVideoPlaylistFrom(feed: Feed)
    func openInAppBrowser(url: URL)
    func navigateToPageDetail(feed: Feed)
    func openShahidEmbedded(url: URL, appStore: String?)
    func navigateToPageDetail(author: Author)
    func navigateToPageDetail(pageUrl: String, pageId: String)
    func navigateToTaggedPageListing(authors: [Author])
    func navigateToContentPage(video: Video, isShowComment: Bool, cell: UITableViewCell?)
}
