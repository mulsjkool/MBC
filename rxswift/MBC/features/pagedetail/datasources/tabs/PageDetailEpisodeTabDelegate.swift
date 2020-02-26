//
//  PageDetailEpisodeTabDelegate.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

protocol PageDetailEpisodeTabDelegate: PageDetailTabDelegate {
    func openShahidEmbedded(url: URL, appStore: String?)
    func navigateToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?)
}

class PageDetailEpisodeTabDataSource: PageDetailTabDataSource {
    
    weak var delegate: PageDetailEpisodeTabDelegate?
    
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "")
    }
    
    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let itemList = delegate?.getItemList() else {
            return dummyCell
        }
        
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.photoNoCustomAlbumTableViewCellid.identifier) as? PhotoNoCustomAlbumTableViewCell {
                cell.bindData(title: R.string.localizable.pagemenuEpisodesTitle().localized(),
                              total: itemList.grandTotal)
                return cell
            }
        }
        
        if itemList.list.count > indexPath.row, let post = itemList.list[indexPath.row] as? Post {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.episodePageTabCell.identifier) as? EpisodePageTabCell {
                cell.bindData(post: post, accentColor: delegate?.getAccentColor(),
                              season: delegate?.getSeasonMetadata(), genre: delegate?.getGenreMetadata())
                cell.disposeBag.addDisposables([
                    cell.onStartInAppBrowserWithShahidEmbedded.subscribe(onNext: { [unowned self] url, appStore in
                        self.delegate?.openShahidEmbedded(url: url, appStore: appStore)
                    }),
                    cell.thumbnailTapped.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.navigateToContentPage(feed: post, isShowComment: false, cell: cell)
                    }),
                    cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.navigateToContentPage(feed: post, isShowComment: false, cell: cell)
                    }),
                    cell.commentTapped.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.navigateToContentPage(feed: post, isShowComment: true, cell: cell)
                    }),
                    cell.shareTapped.subscribe(onNext: { [unowned self] data in
                        self.delegate?.getURLFromObjAndShare(obj: data)
                    })
                ])
                return cell
            }
        }
        return dummyCell
    }
}
