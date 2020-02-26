//
//  PageDetailVideoTabDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailVideoTabDelegate: PageDetailTabDelegate {
    func getAuthor() -> Author
    func getAlbumList() -> ItemList
    func getPageIndex() -> Int
    func getDataReadyForVideo() -> (displayingVideo: Bool, titledPlaylist: Bool)
    func pushVideoPlaylistFrom(customPlaylist: VideoPlaylist)
    func pushVideoPlaylistFromDefault(defaultPlaylist: VideoDefaultPlaylist, videoId: String?)
    func navigateToContentPage(video: Video, isShowComment: Bool, cell: UITableViewCell?)
}

class PageDetailVideoTabDataSource: PageDetailTabDataSource {
    
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: Video - Invalid")
    }
    
    private var dummyCarouselCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: Carousel - Invalid")
    }
    
    weak var delegate: PageDetailVideoTabDelegate?

    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let itemList = delegate?.getItemList(),
            let dataReadyForVideo = delegate?.getDataReadyForVideo() else {
                return dummyCell
        }
        
        if indexPath.section == 0 {
            if dataReadyForVideo.titledPlaylist || !itemList.list.isEmpty {
                return createCustomVideoPlaylistCarouselCell(tableView: tableView)
            }
            return Common.createLoadingPlaceHolderCell()
        }
        if itemList.list.count > indexPath.row,
            let video = itemList.list[indexPath.row] as? Video {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.photoPostTableViewCellid.identifier) as? PhotoPostTableViewCell {
                cell.bindData(media: video, accentColor: delegate?.getAccentColor())
                cell.disposeBag.addDisposables([
                    cell.expandedText.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.reloadCell()
                    }),
                    cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.reloadCell()
                    }),
                    cell.shareTapped.subscribe(onNext: { [unowned self] data in
                        self.delegate?.getURLFromObjAndShare(obj: data)
                    }),
                    cell.didTapVideo.subscribe(onNext: { [unowned self] video in
                        self.pushVideoPlaylistFromDefault(video: video)
                    }),
                    cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                        self.pushVideoPlaylistFromDefault(video: video)
                    }),
                    cell.inlinePlayer.videoPlayerTapped.subscribe(onNext: { [unowned self] video in
                        self.pushVideoPlaylistFromDefault(video: video)
                    }),
                    cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.navigateToContentPage(video: video, isShowComment: true, cell: cell)
                    })
                ])
                return cell
            }
        }
        return dummyCell
    }
    
    private func pushVideoPlaylistFromDefault(video: Video) {
        guard let pageId = self.delegate?.getPageId(),
            let author = self.delegate?.getAuthor(),
            let pageIndex = self.delegate?.getPageIndex() else { return }
        
        let defaultPlaylist = VideoDefaultPlaylist(video: video,
                                                   pageId: pageId,
                                                   author: author,
                                                   accentColor: self.delegate?.getAccentColor(),
                                                   pageIndex: pageIndex)
        self.delegate?.pushVideoPlaylistFromDefault(defaultPlaylist: defaultPlaylist, videoId: video.id)
    }
    
    private func createCustomVideoPlaylistCarouselCell(tableView: UITableView) -> UITableViewCell {
        guard let albumList = delegate?.getAlbumList() else {
            return dummyCarouselCell
        }
        
        if !albumList.list.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.photoAlbumsCarouselTableViewCellid.identifier) as? PhotoAlbumsCarouselTableViewCell {
                cell.bindData(albums: albumList, selectingMenu: .videos, accentColor: delegate?.getAccentColor())
                cell.disposeBag.addDisposables([
                    cell.didTapPlaylist.subscribe(onNext: { [unowned self] videoPlaylist in
                            self.delegate?.pushVideoPlaylistFrom(customPlaylist: videoPlaylist)
                    })
                ])
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.photoNoCustomAlbumTableViewCellid.identifier) as? PhotoNoCustomAlbumTableViewCell {
                cell.bindPlaylistData(playList: albumList)
                return cell
            }
        }
        return dummyCarouselCell
    }

}
