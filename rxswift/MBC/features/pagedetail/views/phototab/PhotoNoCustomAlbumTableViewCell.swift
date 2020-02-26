//
//  PhotoNoCustomAlbumTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/27/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import UIKit

class PhotoNoCustomAlbumTableViewCell: UITableViewCell {

	@IBOutlet private weak var totalLabel: UILabel!
	@IBOutlet private weak var imageLabel: UILabel!
    @IBOutlet private weak var bgView: UIView!
    private var itemList: ItemList!
	
    override func prepareForReuse() {
        super.prepareForReuse()
//        totalLabel.text = ""
//        imageLabel.text = ""
    }
    
	func bindAlbumData(albums: ItemList) {
		self.itemList = albums
        guard itemList.grandTotal > 0 else { hideCell(); return }
		formatLanguageForPhoto()
		setTotalLabel(albums.grandTotal)
	}
    
    func bindPlaylistData(playList: ItemList) {
        itemList = playList
        guard playList.grandTotal > 0 else { hideCell(); return }
        formatLanguageForPlaylist()
        setTotalLabel(playList.grandTotal)
    }
	
    func bindData(title: String?, total: Int) {
        guard total > 0 else { hideCell(); return }
        setTotalLabel(total)
        setTitle(title)
    }
    
    private func hideCell() {
        totalLabel.text = ""
        imageLabel.text = ""
        bgView.backgroundColor = Colors.defaultBg.color()
    }

	private func setTotalLabel(_ value: Int) {
		self.totalLabel.text = "(\(value))"
	}
	
	private func setTitle(_ value: String?) {
		imageLabel.text = value ?? ""
	}
	
	private func formatLanguageForPhoto() {
        self.imageLabel.text = R.string.localizable.commonLabelImage().localized()
        if !Constants.DefaultValue.shouldRightToLeft {
            self.imageLabel.textAlignment = .left
            self.totalLabel.textAlignment = .right
        }
	}
    
    private func formatLanguageForPlaylist() {
        self.imageLabel.text = R.string.localizable.cardTypeVideo().localized()
        if !Constants.DefaultValue.shouldRightToLeft {
            self.imageLabel.textAlignment = .left
            self.totalLabel.textAlignment = .right
        }
    }
    
}
