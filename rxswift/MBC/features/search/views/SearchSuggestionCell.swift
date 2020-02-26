//
//  SearchSuggestionCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 2/27/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import MisterFusion
import SwiftyJSON

class SearchSuggestionCell: BaseTableViewCell {
    @IBOutlet weak private var thumbnailImageView: UIImageView!
    @IBOutlet weak private var metaDataLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    
    private var constraintsRatioImage: NSLayoutConstraint!
    
    let didTapCell = PublishSubject<SearchSuggestion>()
    
    private var searchSuggestion: SearchSuggestion!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.handleGifReuse()
    }
    
    func bindData(searchSuggestion: SearchSuggestion) {
        self.searchSuggestion = searchSuggestion
        bindThumbnail(strURL: searchSuggestion.thumbnail, contentType: searchSuggestion.contentType)
        bindAppTitle(value: searchSuggestion.title, isDescriptionTitle: searchSuggestion.descriptionTitle)
        bindMetaData(value: searchSuggestion.metadata)
        setupEvents()
    }
    
    private func bindThumbnail(strURL: String?, contentType: SearchSuggestionContentType?) {
        guard let contentType = contentType, let strURL = strURL else {
            thumbnailImageView.image = Constants.DefaultValue.defaulNoLogoImage
            constraintsRatioImage = thumbnailImageView.mf.addConstraint(
                thumbnailImageView.width |==| thumbnailImageView.height |*| Constants.DefaultValue.ratio27H40W )
            return
        }
        thumbnailImageView.setSquareImage(imageUrl: strURL, gifSupport: false)
        
        if constraintsRatioImage != nil { thumbnailImageView.removeConstraint(constraintsRatioImage) }
        
        switch contentType {
        case .postImageMultipleTitle, .postImageMultiple, .app, .postText, .postEmbed:
            constraintsRatioImage = thumbnailImageView.mf.addConstraint(
                thumbnailImageView.width |==| thumbnailImageView.height |*| Constants.DefaultValue.ratio16H16W )
        case .postVideo, .postImageSingle, .article, .playlist:
            constraintsRatioImage = thumbnailImageView.mf.addConstraint(
                thumbnailImageView.width |==| thumbnailImageView.height |*| (1 / Constants.DefaultValue.ratio9H16W) )
        default:
            constraintsRatioImage = thumbnailImageView.mf.addConstraint(
                thumbnailImageView.width |==| thumbnailImageView.height |*| Constants.DefaultValue.ratio27H40W )
        }
        self.contentView.layoutIfNeeded()
    }
    
    private func bindAppTitle(value: String, isDescriptionTitle: Bool) {
        titleLabel.text = value
    }
	
    private func bindMetaData(value: String) {
        var metadataString = ""
        guard let contentType = searchSuggestion.contentType else { return }
        
        switch contentType {
        case .profileTalent, .profileBand, .profileSportTeam, .profileSportPlayer, .profileGuest, .profileStar:
            metadataString = getMetadataStringWithProfileType(contentType: contentType, value: value)
        case .article:
            metadataString = R.string.localizable.searchSuggestionPostArticle(getAuthorTitle())
        case .postEpisode:
            metadataString = R.string.localizable.searchSuggestionPostEpisodes(getAuthorTitle())
        case .postImageSingle, .postImageMultiple, .postImageMultipleTitle, .postImageMultipleWithOutTitle:
            metadataString = R.string.localizable.searchSuggestionPostImages(getAuthorTitle())
        case .postText:
            metadataString = R.string.localizable.searchSuggestionPostText(getAuthorTitle())
        case .postVideo:
            metadataString = R.string.localizable.searchSuggestionPostVideo(getAuthorTitle())
        case .postEmbed:
            metadataString = R.string.localizable.searchSuggestionPostLink(getAuthorTitle())
        default:
            metadataString = value.lowercased()
        }
        
        metaDataLabel.text = metadataString
    }
    
    private func getMetadataStringWithProfileType(contentType: SearchSuggestionContentType, value: String) -> String {
        var metadataString = ""
        if contentType == .profileTalent {
            /*
             Occupation
             Voting number = No. + "Voted" → Arabic content:
             Voting for male profile → رقم المشترك
             Voting for female profile → رقم المشتركة
             */
            guard let metadata = searchSuggestion.metadataMap["occupation"] as? [String] else {
                return metadataString
            }
            metadataString = ""
            for occupation in metadata {
                if metadataString == "" {
                    metadataString = occupation
                } else {
                    metadataString = R.string.localizable.searchSuggestionFormatMetadata(metadataString, occupation)
                }
            }
            
            guard let gender = searchSuggestion.metadataMap["gender"] as? String,
                let votingNumber = searchSuggestion.metadataMap["votingNumber"] as? String else {
                    return metadataString
            }
            metadataString = R.string.localizable.searchSuggestionFormatTalent(metadataString, votingNumber,
                                                                               getGenderString(value: gender))
            
        } else if contentType == .profileSportTeam {
            /*
             Nick name
             Established year → تأسس عام
             */
            guard let nickname = searchSuggestion.metadataMap["nickName"] as? String else {
                return metadataString
            }
            metadataString = R.string.localizable.searchSuggestionProfileSportTeam(nickname)
        } else if contentType == .profileBand {
            /*
             Established year → تأسست عام
             */
            metadataString = R.string.localizable.pagedetailHeaderEstablishedYearBand()
        } else {
            metadataString = value.replacingOccurrences(of: Constants.DefaultValue.DotSeparatorString,
                                                        with:
                Constants.DefaultValue.MetadataLinkedValueSeparatorString).lowercased()
        }
        
        return metadataString
    }
    
    private func getGenderString(value: String) -> String {
        if value.lowercased() == R.string.localizable.searchSuggestionGenderMale() {
            return R.string.localizable.pagedetailHeaderVotingformale()
        } else {
            return R.string.localizable.pagedetailHeaderVotingforfemale()
        }
    }
    
    private func getAuthorTitle() -> String {
        guard let authorTitle = searchSuggestion.metadataMap["authorTitle"] as? String else {
            return ""
        }
        return authorTitle
    }
    
    private func setupEvents() {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [unowned self] _ in
                self.didTapCell.onNext(self.searchSuggestion)
            })
            .disposed(by: disposeBag)
    }
}
