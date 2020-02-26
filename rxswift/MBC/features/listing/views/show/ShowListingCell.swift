//
//  ShowListingCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 3/16/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit

class ShowListingCell: BaseTableViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var pageNameLabel: UILabel!
    @IBOutlet weak private var pageGenreLabel: UILabel!
    
    private var show: Show!
    
    func bindData(show: Show) {
        self.show = show
        bindThumbnail(imageUrl: show.posterUrl)
        bindPageName(name: show.title)
        bindGenre(show: show)
    }
    
    private func bindThumbnail(imageUrl: String?) {
        if let imageUrl = imageUrl {
            thumbnailImageView.setSquareImage(imageUrl: imageUrl, gifSupport: true)
        } else {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
        }
    }
    
    private func bindPageName(name: String?) {
        pageNameLabel.text = name ?? ""
    }
    
    private func bindGenre(show: Show) {
        var genresText = ""
        if let genres = show.genres, !genres.isEmpty {
            genresText = genres.joined(separator: Constants.DefaultValue.InforTabMetadataGenreSeparatorString)
        }
        var otherMetadataText = ""
        if let pageSubTypeStr = show.subType, let pageSubType = PageShowSubType(rawValue: pageSubTypeStr) {
            switch pageSubType {
            case .movie:
                otherMetadataText = show.sequelNumber ?? ""
            case .series, .program:
                otherMetadataText = show.seasonNumber ?? ""
            default:
                otherMetadataText = ""
            }
        }
        var tempArray = [String]()
        if !genresText.isEmpty {
            tempArray.append(genresText)
        }
        if !otherMetadataText.isEmpty {
            tempArray.append(otherMetadataText)
        }
        pageGenreLabel.text = tempArray.joined(separator: Constants.DefaultValue.MetadataSeparatorString)
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        
        guard let imageUrl = show.posterUrl else { return (isVideo: false, shouldResume: false) }
        let photo = Media(withImageUrl: imageUrl)
        guard photo.isAGif else { return (isVideo: false, shouldResume: false) }
        let gifHeight = thumbnailImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + thumbnailImageView.convert(thumbnailImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? thumbnailImageView.resumeGifAnimation() : thumbnailImageView.pauseGifAnimation()
        return (isVideo: false, shouldResume: false) /// TODO: To be updated
    }
}
