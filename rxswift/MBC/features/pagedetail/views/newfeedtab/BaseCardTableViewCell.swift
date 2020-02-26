//
//  BaseCartTableViewCell.swift
//  MBC
//
//  Created by Vu Mai Hoang Hai Hung on 12/11/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import TTTAttributedLabel
import UIKit
import RxSwift

class BaseCardTableViewCell: BaseCampaignTableViewCell, IAnalyticsTrackingCell {
    
    @IBOutlet weak private var lbDescription: TTTAttributedLabel!
    @IBOutlet weak private var viewLikeCommentShare: LikeCommentShareView!
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var authorView: AvatarFullScreenView!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var descriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var interestViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var activityCardView: ActivityCardView!
    @IBOutlet weak private var activityCardViewHeightConstraint: NSLayoutConstraint!
	
	private var highlightedText: String = ""
    
    func getAuthorView() -> AvatarFullScreenView {
        return authorView
    }
    
    func getLikeCommentShareView() -> LikeCommentShareView {
        return viewLikeCommentShare
    }
    
    func getInterestView() -> InterestView {
        return interestView
    }
    
    func getDescriptionLabelTopConstraint() -> NSLayoutConstraint {
        return descriptionLabelTopConstraint
    }
    
    var timestampTapped: PublishSubject<Void> {
        return authorView.timestampTapped
    }
    var authorAvatarTapped: PublishSubject<Void> {
        return authorView.authorAvatarTapped
    }
    var authorNameTapped: PublishSubject<Void> {
        return authorView.authorNameTapped
    }
    let titleTapped = PublishSubject<Void>()
    let authorPageTapped = PublishSubject<Author>()
    let taggedPageTapped = PublishSubject<[Author]>()
    
    // private constants and variables
    private var defaultHeightOfDescription: CGFloat = 31.5
    
    var media: Media! {
        didSet {
            setLikeComment()
            if media is Video, let video = media as? Video { self.video = video }
        }
    }
    var feed: Feed! { didSet { setLikeComment() } }
    var accentColor: UIColor?
    var video: Video?
    
    let expandedText = PublishSubject<UITableViewCell>()
    let openPageStream = PublishSubject<String>()
    var didTapDescription = PublishSubject<Void>()
    let didChangeInterestView = PublishSubject<Void>()
    var commentTapped: Observable<Likable> {
        return self.viewLikeCommentShare.commentTapped.asObservable()
    }
    var shareTapped: Observable<Likable> {
        return self.viewLikeCommentShare.shareTapped.asObservable()
    }
    
    // MARK: Public functions
    
    func bindData(media: Media, accentColor: UIColor?) {
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        self.media = media
        self.video = media as? Video
        bindIntesrestAndLabelForMedia()
    }
    
    func bindData(feed: Feed, accentColor: UIColor?) {
        self.video = nil
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        self.video = nil
        self.feed = feed
        bindAuthor()
        bindInterestAndLabel()
        bindActivityCard()
        guard let post = (feed as? Post), let sType = post.subType, let subType = FeedSubType(rawValue: sType),
            subType == .video else { return }
        self.video = post.medias?.first as? Video
    }
    
	func getDescriptionLabel() -> TTTAttributedLabel {
		return lbDescription
	}
	
    var interests: [Interest]? {
        if let feed = self.feed { return feed.interests }
        if let media = self.media { return media.interests }
        return nil
    }
    
    var isTextExpanded: Bool {
        get {
            if let model = feed as? Post {
                return model.isTextExpanded
            }
            if let model = feed as? Article {
                return model.isTextExpanded
            }
            if let model = feed as? App {
                return model.isTextExpanded
            }
            if let media = self.media { return media.isTextExpanded }
            
            return false
        }
        set {
            if let model = feed as? Post {
                model.isTextExpanded = newValue
            } else if let model = feed as? Article {
                model.isTextExpanded = newValue
            } else if let model = feed as? App {
                model.isTextExpanded = newValue
            } else if let media = self.media {
                media.isTextExpanded = newValue
            }
        }
    }
    
    var imagesList: [Media]? {
        if let post = feed as? Post, var images = post.medias, let defaultImageId = post.defaultImageId {
            let index = images.index(where: { item -> Bool in
                item.id == defaultImageId
            })
            guard let indexOfdefaultImage = index else { return post.medias }
            let media = images.remove(at: indexOfdefaultImage)
            images.insert(media, at: 0)
            return images
        }
        if let article = feed as? Article, let image = article.photo { return [image] }
        if let app = feed as? App, let image = app.photo { return [image] }
        return nil
    }
    
    var label: String? {
        if let feed = self.feed { return feed.label }
        if let media = self.media { return media.label }
        return ""
    }

    func bindAuthor() {
        guard let feed = feed, let author = feed.author, let authorView = authorView else { return }
        authorView.bindData(author, publishedDate: feed.publishedDate, contentType: feed.type, subType: feed.subType)
        authorView.bindContentTypeForAppCard(contentType: feed.type, subType: feed.subType)
    }
    
    func getTrackingObjects() -> [IAnalyticsTrackingObject] {
        if feed != nil {
            if let app = feed as? App {
                return [AnalyticsApp(app: app)] + analyticsCampaigns
            }
            return [AnalyticsContent(feed: feed, index: indexRow)] + analyticsCampaigns
        }
        if media != nil {
            return [AnalyticsContent(media: media, author: "", index: indexRow)] + analyticsCampaigns
        }
        return analyticsCampaigns
    }
    
    func bindIntesrestAndLabelForMedia() {
        if let media = media, let interests = media.interests {
            interestView.bindInterests(interests: interests, isExpanded: media.isInterestExpanded)
            interestView.bindLabel(label: media.label, isExpanded: media.isInterestExpanded)
            interestView.applyAccentColor(accentColor: accentColor)
            interestView.disposeBag.addDisposables([
                interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                    if let interestViewTopConstraint = self.interestViewTopConstraint {
                        interestViewTopConstraint.constant = (viewHeight > 0)
                            ? Constants.DefaultValue.interestViewTopMargin : 0
                    }
                    self.interestViewHeightConstraint.constant = viewHeight
                    self.layoutIfNeeded()
                    self.didChangeInterestView.onNext(())
                }),
                interestView.didExpand.subscribe(onNext: { _ in
                    media.isInterestExpanded = true
                })
            ])
            interestView.reLayoutConstraints()
        }
    }
    
    func bindDescription() {
        guard let text = cardDescription, !text.isEmpty else {
            lbDescription.text = ""
            if let descriptionLabelTopConstraint = descriptionLabelTopConstraint {
                descriptionLabelTopConstraint.constant = 0
            }
            return
        }
        
        lbDescription.from(html: text)
		lbDescription.copyableFullText = lbDescription.text ?? ""
        if let descriptionLabelTopConstraint = descriptionLabelTopConstraint {
            descriptionLabelTopConstraint.constant = Constants.DefaultValue.titleAndDescriptionLabelTopMargin
        }
        Common.setupDescriptionFor(label: lbDescription, whenExpanding: isTextExpanded,
                                   maxLines: descriptionMaxLines,
                                   linkColor: accentColor,
                                   delegate: self)
    }
    
    func bindDesciptionFullText() {
        let text = cardDescription ?? ""
        if let descriptionLabelTopConstraint = descriptionLabelTopConstraint {
            descriptionLabelTopConstraint.constant = text.isEmpty ? 0
                : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
        }
        lbDescription.from(html: text)
        lbDescription.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
    }
    
    func setLikeComment() {
        guard let viewLikeCommentShare = viewLikeCommentShare else { return }
        if let feed = feed { viewLikeCommentShare.feed = feed }
        if let media = media { viewLikeCommentShare.media = media }
    }
    
    func expandCardTextLabel(label: TTTAttributedLabel!) {
        isTextExpanded = true
        bindDescription()
		highlight(keyword: highlightedText)
        layoutIfNeeded()
        expandedText.onNext(self)
    }
    
    func setAppType(subType: String?) -> String {
        guard let subtype = subType, let type = AppSubType(rawValue: subtype) else { return "" }
        return type.localizedContentType()
    }
    
    func bindInterestAndLabel() {
        if let feed = feed, let interestView = interestView {
            interestView.bindInterests(interests: feed.interests, isExpanded: feed.isInterestExpanded)
            interestView.bindLabel(label: feed.label, isExpanded: feed.isInterestExpanded)
            interestView.applyAccentColor(accentColor: accentColor)
            interestView.disposeBag.addDisposables([
                interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                    if let interestViewTopConstraint = self.interestViewTopConstraint {
                        interestViewTopConstraint.constant = (viewHeight > 0)
                            ? Constants.DefaultValue.interestViewTopMargin : 0
                    }
                    self.interestViewHeightConstraint.constant = viewHeight
                    self.layoutIfNeeded()
                    self.didChangeInterestView.onNext(())
                }),
                interestView.didExpand.subscribe(onNext: { _ in
                    feed.isInterestExpanded = true
                })
            ])
            interestView.reLayoutConstraints()
        }
    }
    
    func highlight(keyword: String?) {
        guard let text = keyword, !text.isEmpty, let descText = lbDescription.text, !descText.isEmpty else { return }
        highlightedText = text
        
        // store the readMorelink's color before highlighting
        var readMoreLinkColor: UIColor? = nil
        if let attributedText = lbDescription.attributedText,
            lbDescription.links != nil,
            (lbDescription.links.first(where: { ($0 as? NSTextCheckingResult)?.url?.absoluteString ==
                Constants.DefaultValue.CustomUrlForMoreText.absoluteString }) as? NSTextCheckingResult) != nil {
            
            let attributes = attributedText.attributes(at: attributedText.length - 1, effectiveRange: nil)
            readMoreLinkColor = attributes.first(where: { $0.key ==
                kCTForegroundColorAttributeName as NSAttributedStringKey })?.value as? UIColor
        }
        
        let normalAttrs: [NSAttributedStringKey: Any] = [.backgroundColor: UIColor.clear,
                                                         .foregroundColor: lbDescription.textColor,
                                                         .font: lbDescription.font]
        var highlightAtts = normalAttrs
        highlightAtts[.backgroundColor] = Colors.highlightedColor.color()
        
        lbDescription.highlight(text: text, normal: normalAttrs, highlight: highlightAtts)
        
         // restore readMoreLink color after highlighting
        if readMoreLinkColor != nil, let attributedText = lbDescription.attributedText {
            let readMoreText = R.string.localizable.commonCardLinkReadMore().localized()
            let range = NSRange(location: attributedText.length - readMoreText.length, length: readMoreText.length)
            let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
            mutableAttributedText.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey,
                                               value: readMoreLinkColor as Any, range: range)
            lbDescription.attributedText = mutableAttributedText
        }
    }
    
    private var cardTextLabelHeight: CGFloat {
        if let feed = self.feed, feed is Post { return Constants.DefaultValue.CardTextLabelHeightForImagePost }
        if self.media != nil { return Constants.DefaultValue.CardTextLabelHeightForImagePost }
        return Constants.DefaultValue.CardTextLabelHeight
    }
    
    private func bindActivityCard() {
        if let activityCardView = activityCardView, let activityCard = feed.activityCard,
            let activityCardViewHeightConstraint = activityCardViewHeightConstraint {
            activityCardView.bindData(activityCard: activityCard)
            activityCardViewHeightConstraint.constant = activityCardView.getViewHeight()
            activityCardView.disposeBag.addDisposables([
                activityCardView.authorPageTapped.subscribe(onNext: { [unowned self] author in
                    self.authorPageTapped.onNext(author)
                }),
                activityCardView.taggedPageTapped.subscribe(onNext: { [unowned self] authors in
                    self.taggedPageTapped.onNext(authors)
                })
            ])
        } else {
            if let activityCardViewHeightConstraint = activityCardViewHeightConstraint {
                activityCardViewHeightConstraint.constant = 0.0
            }
        }
        layoutIfNeeded()
    }
    
    // MARK: Private
    private var descriptionMaxLines: Int {
        if feed is Post, let subType = feed!.subType, let sType = FeedSubType(rawValue: subType) {
            return sType == FeedSubType.text ? Constants.DefaultValue.numberOfLinesForTextDescription :
                Constants.DefaultValue.numberOfLinesForImageDescription
        }
        if feed is Article {
            return Constants.DefaultValue.numberOfLinesForImageDescription
        }
        if feed is App {
            return Constants.DefaultValue.numberOfLinesForImageDescription
        }
        
        return Constants.DefaultValue.numberOfLinesForImageDescription
    }
    
    private var cardDescription: String? {
        if feed is Post {
            return (feed as? Post)?.description
        }
        if feed is Article {
            return (feed as? Article)?.description
        }
        if feed is App {
            return (feed as? App)?.description
        }
        
        // fall back
        return media.description
    }
	
	func hideInterestView() {
		interestView.isHidden = true
		lbDescription.isHidden = true
		authorView.isHidden = true
		viewLikeCommentShare.isHidden = true
	}
}

extension BaseCardTableViewCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == Constants.DefaultValue.CustomUrlForMoreText.absoluteString {
            expandCardTextLabel(label: label)
        } else if url.absoluteString == Constants.DefaultValue.CustomUrlForPostText.absoluteString {
            didTapDescription.onNext(())
        }
    }
}
