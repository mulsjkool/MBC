//
//  VideoLiveStreamingCell.swift
//  MBC
//
//  Created by Tri Vo on 3/20/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class VideoLiveStreamingCell: VideoPlaylistTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	// swiftlint:disable overridden_super_call
	override func prepareForReuse() {
	}
	
    func bindData(videoItem: Video, accentColor: UIColor?) {
		bindVideoLiveStreaming(video: videoItem)
		setUpVideoPlay()
		updatePlayButton()
		setupUI()
        updateVolumeButton(toMute: false)
		updatePlayButton(toPause: false)
	}
}
