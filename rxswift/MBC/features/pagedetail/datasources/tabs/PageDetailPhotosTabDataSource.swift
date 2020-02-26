//
//  PageDetailPhotosTabDataSource.swift
//  MBC
//
//  Created by Tram Nguyen on 2/24/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

protocol PageDetailPhotosTabDelegate: PageDetailTabDelegate {
    func getAuthor() -> Author
    func getAlbumList() -> ItemList
    func getDataReadyForPhotos() -> (displayingPhotos: Bool, titledAlbum: Bool)
    func showFullscreenImageDefaultAlbum(defaultAlbum: PhotoDefaultAlbum)
    func showPopupComment(pageId: String?, contentId: String?, contentType: String)
    func showFullScreenImageFromCustomAlbum(customAlbum: PhotoCustomAlbum)
}

class PageDetailPhotosTabDataSource: PageDetailTabDataSource {
    
    weak var delegate: PageDetailPhotosTabDelegate?
    
    var dummyCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: Media - Invalid")
    }
    
    private var dummyCarouselCell: UITableViewCell {
        return Common.createDummyCellWith(title: "Cell for a of type: Carousel - Invalid")
    }
    
    func cellForIndexPath(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let itemList = delegate?.getItemList(),
            let dataReadyForPhotos = delegate?.getDataReadyForPhotos() else {
            return dummyCell
        }
        
        if indexPath.section == 0 {
            // show photo albums carousel
            if dataReadyForPhotos.titledAlbum || !itemList.list.isEmpty {
                if Constants.Singleton.isiPad {
                    return createPhotoAlbumsCarouselTableviewCellForIpad(tableView: tableView)
                }
                return createPhotoAlbumsCarouselTableviewCell(tableView: tableView)
            }
            return Common.createLoadingPlaceHolderCell()
        }
        
        if itemList.list.count > indexPath.row,
            let media = itemList.list[indexPath.row] as? Media {
            if Constants.Singleton.isiPad {
                return createCollectionPhotoCellForIPad(itemList: itemList, tableView: tableView)
            }
            return createCollectionPhotoCellForIphone(media: media, tableView: tableView, indexPath: indexPath)
        }
        return dummyCell
    }
    
    private func createCollectionPhotoCellForIPad(itemList: ItemList, tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.iPadPhotoCollectionViewId.identifier) as? IPadPhotoCollectionView {
            cell.bindData(itemList: itemList)
            return cell
        }
        return UITableViewCell()
    }
    
    private func createCollectionPhotoCellForIphone(media: Media, tableView: UITableView,
                                                    indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            R.reuseIdentifier.photoPostTableViewCellid.identifier) as? PhotoPostTableViewCell {
            cell.tag = indexPath.row
            cell.bindData(media: media, accentColor: delegate?.getAccentColor())
            cell.disposeBag.addDisposables([
                cell.expandedText.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.reloadCell()
                }),
                cell.didTapImageOfDefaultAlbum.subscribe(onNext: { [unowned self] index in
                    self.showFullscreenImageDefaultAlbum(index: index)
                }),
                cell.didChangeInterestView.subscribe(onNext: { [unowned self] _ in
                    self.delegate?.reloadCell()
                }),
                cell.didTapDescription.subscribe(onNext: { [unowned self] _ in
                    self.showFullscreenImageDefaultAlbum(index: 0)
                }),
                cell.shareTapped.subscribe(onNext: { [unowned self] data in
                    self.delegate?.getURLFromObjAndShare(obj: data)
                }),
                cell.commentTapped.subscribe(onNext: { [unowned self] data in
                    guard let data = data as? Media,
                        let pageId = self.delegate?.getPageId() else { return }
                    
                    self.delegate?.showPopupComment(pageId: pageId,
                                                    contentId: data.uuid,
                                                    contentType: data.contentType)
                }),
                cell.titleTapped.subscribe(onNext: { [unowned self] _ in
                    self.showFullscreenImageDefaultAlbum(index: 0)
                })
            ])
            return cell
        }
        return dummyCell
        
    }
    
    private func showFullscreenImageDefaultAlbum(index: Int) {
        guard let albumList = self.delegate?.getAlbumList(),
            let pageId = self.delegate?.getPageId(),
            let author = self.delegate?.getAuthor() else { return }
        
        let defaultAlbum = PhotoDefaultAlbum(pageId: pageId,
                                             pageSize: albumList.grandTotal!,
                                             imageIndex: index,
                                             author: author,
                                             accentColor: self.delegate?.getAccentColor())
        self.delegate?.showFullscreenImageDefaultAlbum(defaultAlbum: defaultAlbum)
    }
    
    private func createPhotoAlbumsCarouselTableviewCellForIpad(tableView: UITableView) -> UITableViewCell {
        guard let albumList = delegate?.getAlbumList() else {
            return dummyCarouselCell
        }
        if !albumList.list.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.iPadPhotoAlbumsCarouselTableViewCellid.identifier) as?
                IPadPhotoAlbumsCarouselTableViewCell {
                cell.bindData(albums: albumList, selectingMenu: .photos, accentColor: delegate?.getAccentColor())
                cell.disposeBag.addDisposables([
                    cell.didTapAlbum.subscribe(onNext: { [unowned self] album in
                        guard let pageId = self.delegate?.getPageId(),
                            let author = self.delegate?.getAuthor() else { return }

                        let customAlbum = PhotoCustomAlbum(pageId: pageId,
                                                           album: album,
                                                           author: author,
                                                           accentColor: self.delegate?.getAccentColor())
                        self.delegate?.showFullScreenImageFromCustomAlbum(customAlbum: customAlbum)
                    })
                ])
                return cell
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier:
                    R.reuseIdentifier.photoNoCustomAlbumTableViewCellid.identifier) as?
                    PhotoNoCustomAlbumTableViewCell {
                    cell.bindAlbumData(albums: albumList)
                    return cell
                }
            }
        }
        
        return dummyCarouselCell
    }
    private func createPhotoAlbumsCarouselTableviewCell(tableView: UITableView) -> UITableViewCell {
        guard let albumList = delegate?.getAlbumList() else {
            return dummyCarouselCell
        }
        print("GET ALBUM LIST = \(albumList.list.count)")
        if !albumList.list.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.photoAlbumsCarouselTableViewCellid.identifier) as? PhotoAlbumsCarouselTableViewCell {
                cell.bindData(albums: albumList, selectingMenu: .photos, accentColor: delegate?.getAccentColor())
                cell.disposeBag.addDisposables([
                    cell.didTapAlbum.subscribe(onNext: { [unowned self] album in
                        guard let pageId = self.delegate?.getPageId(),
                            let author = self.delegate?.getAuthor() else { return }
                        
                        let customAlbum = PhotoCustomAlbum(pageId: pageId,
                                                           album: album,
                                                           author: author,
                                                           accentColor: self.delegate?.getAccentColor())
                        self.delegate?.showFullScreenImageFromCustomAlbum(customAlbum: customAlbum)
                    })
                ])
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier:
                R.reuseIdentifier.photoNoCustomAlbumTableViewCellid.identifier) as? PhotoNoCustomAlbumTableViewCell {
                cell.bindAlbumData(albums: albumList)
                return cell
            }
        }
        
        return dummyCarouselCell
    }
    
}
