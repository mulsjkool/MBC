//
//  IPadPhotoCollectionView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 4/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class IPadPhotoCollectionView: BaseTableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var itemList: ItemList!
    private var itemWidth: CGFloat = Common.getPhotoAlbumItemWith()
    private var itemHeight: CGFloat = Common.getPhotoAlbumItemHeight()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: Public
    func bindData(itemList: ItemList) {
        self.itemList = itemList
        configCollectionView()
    }
    
    // MARK: Private
    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(R.nib.iPadPhotoAlbumCollectionCell(),
                                  forCellWithReuseIdentifier:
            R.reuseIdentifier.iPadPhotoAlbumCollectionCellId.identifier)
        collectionView.reloadData()
    }

}

extension IPadPhotoCollectionView: UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("hung count incell \(itemList.list.count)")
        return itemList.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight )
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            R.reuseIdentifier.iPadPhotoAlbumCollectionCellId.identifier,
                                                         for: indexPath) as? IPadPhotoAlbumCollectionCell {
            if let media = itemList.list[indexPath.row] as? Media {
                cell.bindData(media: media)
                if indexPath.row == 0 {
                    cell.marginSeperatorLeft()
                } else if indexPath.row % Constants.DefaultValue.numberOfItemPhotoDefaullAlbumInLine ==
                    (Constants.DefaultValue.numberOfItemPhotoDefaullAlbumInLine - 1) {
                    cell.marginSeperatorRight()
                } else {
                    cell.resetMarginSeperator()
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
