//
//  PlaylistSingleItemCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/2/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class PlaylistSingleItemCell: BundleSingleItemCell {
    private var playlist: Playlist!

    func bindData(playlist: Playlist, accentColor: UIColor?) {
        self.playlist = playlist
        super.bindData(bundle: playlist, accentColor: accentColor)
    }
}
