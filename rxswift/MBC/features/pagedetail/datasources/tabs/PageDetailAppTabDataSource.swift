//
//  PageDetailAppTabDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailAppTabDelegate: PageDetailTabDelegate {
    func pushAppWhitePage(app: App)
    func pushAppToContentPage(feed: Feed, isShowComment: Bool, cell: UITableViewCell?)
}

class PageDetailAppTabDataSource: PageDetailTabDataSource {
    
    weak var delegate: PageDetailAppTabDelegate?
    
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
                cell.bindData(title: R.string.localizable.pagemenuAppsTitle(), total: itemList.grandTotal)
                return cell
            }
        }
        
        if itemList.list.count > indexPath.row, let app = itemList.list[indexPath.row] as? App {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.pageAppTableViewCellid.identifier) as? PageAppTableViewCell {
                cell.bindData(app: app, accentColor: delegate?.getAccentColor())
                cell.disposeBag.addDisposables([
                    cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                        self.delegate?.reloadCell()
                    }),
                    cell.didTapAppPhoto.subscribe(onNext: { [unowned self] app in
                        self.pushAppWhitePage(app: app)
                    }),
                    cell.didTapAppTitle.subscribe(onNext: { [unowned self] app in
                        self.pushAppWhitePage(app: app)
                    }),
                    cell.shareTapped.subscribe(onNext: { [unowned self] data in
                        self.delegate?.getURLFromObjAndShare(obj: data)
                    }),
                    cell.commentTapped.subscribe(onNext: { [unowned self] data in
                        if let app = data as? App {
                            self.pushAppToContentPage(feed: app, isShowComment: true)
                        }
                    }),
                    cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                        self.pushAppWhitePage(app: app)
                    })
                ])
                return cell
            }
        }
        return dummyCell
    }
    
    private func pushAppWhitePage(app: App) {
        delegate?.pushAppWhitePage(app: app)
    }

    private func pushAppToContentPage(feed: Feed, isShowComment: Bool = false, cell: UITableViewCell? = nil) {
        delegate?.pushAppToContentPage(feed: feed, isShowComment: isShowComment, cell: cell)
    }
}
