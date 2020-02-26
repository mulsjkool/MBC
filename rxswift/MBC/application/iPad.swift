//
//  iPad.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 4/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import Foundation

struct IPad {
    struct CellIdentifier {
        static var postCardMultiImagesCell: String {
            return Constants.Singleton.isiPad ? R.reuseIdentifier.iPadPostCardMultiImagesTableViewCellid.identifier :
                R.reuseIdentifier.postCardMultiImagesTableViewCellid.identifier
        }
        
        static var homeStreamSingleItemCell: String {
            return Constants.Singleton.isiPad ? R.reuseIdentifier.iPadHomeStreamSingleItemCellId.identifier :
                R.reuseIdentifier.homeStreamSingleItemCell.identifier
        }
        
        static var episodeCell: String {
            return Constants.Singleton.isiPad ?  R.reuseIdentifier.iPadEpisodeCell.identifier :
                R.reuseIdentifier.episodeCell.identifier
        }

        static var pageCardCell: String {
            return Constants.Singleton.isiPad ? R.reuseIdentifier.iPadPageCardCellId.identifier :
                R.reuseIdentifier.pageCardCellId.identifier
        }
        
        static var appCardTableViewCell: String {
            return Constants.Singleton.isiPad ? R.reuseIdentifier.iPadAppCardTableViewCellid.identifier :
                R.reuseIdentifier.appCardTableViewCellid.identifier
        }
        
        static var embeddedCardCell: String {
            return Constants.Singleton.isiPad ? R.reuseIdentifier.iPadEmbeddedCardCellid.identifier :
                R.reuseIdentifier.embeddedCardCell.identifier
        }
        
        static var bundleSingleItemCell: String {
            return Constants.Singleton.isiPad ? R.reuseIdentifier.iPadBundleSingleItemCellId.identifier :
                R.reuseIdentifier.bundleSingleItemCell.identifier
        }
        
        static var bundleSingleItemInforCell: String {
            return Constants.Singleton.isiPad ?
                R.reuseIdentifier.iPadBundleSingleItemInforCollectionViewCellId.identifier :
                R.reuseIdentifier.bundleSingleItemInforCollectionViewCell.identifier
        }
    }
    
    struct NibName {
        static var mbcLoadingPlaceHolder: String {
            return Constants.Singleton.isiPad ? R.nib.iPadMBCLoadingPlaceHolderView.name :
                R.nib.mbcLoadingPlaceHolderView.name
        }
    }
}
