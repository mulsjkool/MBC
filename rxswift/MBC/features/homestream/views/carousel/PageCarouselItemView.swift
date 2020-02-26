//
//  PageCarouselItemView.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import Kingfisher
import UIKit
import MisterFusion

class PageCarouselItemView: BaseCarouselItemView {
	@IBOutlet private weak var metaDataLabel: UILabel!
	@IBOutlet private weak var followerView: FollowView!
	@IBOutlet private weak var follwerCountLabel: UILabel!
    
    override func bindData(_ feed: Feed, isInfoComponent: Bool, willShowMetadata: Bool) {
        super.bindData(feed, isInfoComponent: isInfoComponent, willShowMetadata: willShowMetadata)
        setPageHeaderDetail()
    }
    
    private func setPageHeaderDetail() {
        guard let streamPage = (self.feed as? Page), let typeStr = streamPage.pageType,
            let subtypeStr = streamPage.pageSubType,
            let type = StreamPageType(rawValue: typeStr),
            let subtype = StreamPageSubType(rawValue: subtypeStr) else { return }
        
        metaDataLabel.text = ""
        
        if let infoComponentValue = streamPage.infoComponentValue {
            setMetaDataForInfoComponent(infoComponentValue, willShowMetadata: willShowMetadata)
            return
        }
        
        // other cases
        switch type {
        case StreamPageType.show:
            setPageShowMetaData(page: streamPage, subType: subtype)
        default: // Profile
            setPageProfileMetaData(subType: subtype)
        }
    }
    
    private func setPageShowMetaData(page: Page, subType: StreamPageSubType) {
        switch subType {
        case .movie, .series, .program:
            metaDataLabel.text = page.genreNames
        case .news, .match, .play:
            guard let status = page.liveRecord, let liveRecord = LiveRecordType(rawValue: status) else { return }
            metaDataLabel.text = liveRecord.getArabicText()
        default:
            break
        }
    }
    
    private func setPageProfileMetaData(subType: StreamPageSubType) {
        // not required yet
    }
    
    private func setMetaDataForInfoComponent(_ infoValue: String, willShowMetadata: Bool) {
        metaDataLabel.text = infoValue
        metaDataLabel.isHidden = !willShowMetadata
    }
	
	private func setFollowerCount() {
		let numOfFollower: Int = 88
		follwerCountLabel.text = R.string.localizable.cardFollowerTitle("\(numOfFollower)")
	}
}
