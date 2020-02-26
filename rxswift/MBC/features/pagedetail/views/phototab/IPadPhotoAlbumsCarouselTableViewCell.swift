//
//  IPadPhotoAlbumsCarouselTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 4/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class IPadPhotoAlbumsCarouselTableViewCell: PhotoAlbumsCarouselTableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewConstraintHeight: NSLayoutConstraint!
    private let reuseCellIndentify: String = "albumItem"
    private let itemViewTag: Int = 100
    
   override func bindData(albums: ItemList, selectingMenu: PageMenuEnum, accentColor: UIColor?) {
        super.bindData(albums: albums, selectingMenu: selectingMenu, accentColor: accentColor)
        configColletionView()
    }
    
    private func configColletionView() {
        widthOfAlbumItem = Common.getCustomAlbumItemWith()
        heightOfAlbumItem = Common.getCustomAlbumItemHeight()
        collectionViewConstraintHeight.constant = heightOfAlbumItem
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIndentify)
        if Constants.DefaultValue.shouldRightToLeft {
            collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        collectionView.reloadData()
    }
}

extension IPadPhotoAlbumsCarouselTableViewCell: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthOfAlbumItem, height: heightOfAlbumItem )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIndentify, for: indexPath)
        let itemData = self.albums.list[indexPath.row]
        var itemView = cell.contentView.viewWithTag(itemViewTag)
        if itemView == nil {
            itemView = createItemViewAt(index: indexPath.row, data: itemData)
            if let itemViewUnWrap = itemView {
                itemViewUnWrap.tag = itemViewTag
                cell.contentView.addSubview(itemViewUnWrap)
            }
            
        }
        if let itemView = itemView as? PhotoAlbumICarouselItemView, let album = itemData as? Album {
            itemView.bindData(album: album, accentColor: accentColor)
        } else if let itemView = itemView as? VideoPlaylistCarouselItemView,
            let videoPlaylist = itemData as? VideoPlaylist {
            itemView.bindData(videoPlaylist: videoPlaylist, accentColor: accentColor)
        }
        return cell
    }
}
