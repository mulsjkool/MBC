//
//  ArticleParagraphImageCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/25/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import TTTAttributedLabel
import UIKit

class ArticleParagraphImageCell: ArticleParagraphBaseCell {
    
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var mediaDescription: TTTAttributedLabel!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var taggedPagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var mediaDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var taggedPagesView: TaggedPagesView!
    @IBOutlet weak private var taggedContainerView: UIView!
    @IBOutlet weak private var buttonTaggedPages: UIButton!

    private let taggedViewHeightDefault: CGFloat = Constants.DefaultValue.taggedViewHeightDefault
    private let taggedViewHeightWhenShow: CGFloat = Constants.DefaultValue.taggedViewHeightWhenShow
    private let taggedPagesTitleColor = Colors.unselectedTabbarItem.color()
    private let taggedContainerViewColor = Colors.dark.color()

    private let mediaDescriptionLabelRightMargin: CGFloat = Constants.DefaultValue.defaultMargin
    private let mediaDescriptionTopMargin: CGFloat = 12.0
    
    let expandedText = PublishSubject<UITableViewCell>()
    let didChangeInterestView = PublishSubject<ArticleParagraphImageCell>()
    let didTapButtonTaggedPages = PublishSubject<Media>()
    let didTapTaggedPage = PublishSubject<MenuPage>()
    let photoTapped = PublishSubject<String?>() // photo id
    var accentColor: UIColor?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taggedPagesView.resetPages()
        taggedContainerView.backgroundColor = UIColor.clear
        if let photoImageView = photoImageView {
            photoImageView.handleGifReuse()
        }
    }
    
    func bindData(paragraph: Paragraph, accentColor: UIColor?, numberOfItem: Int,
                  paragraphViewOption: ParagraphViewOptionEnum) {
        super.bindData(paragraph: paragraph, numberOfItem: numberOfItem, paragraphViewOption: paragraphViewOption)
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        bindImage()
        bindTaggedPage()
        bindInterest()
        bindContentDescription(paragraph: paragraph, accentColor: accentColor)
    }
    
    private func bindImage() {
        if let image = paragraph.media {
            photoImageView.setImage(from: image, resolution: .ar16x9)
        }
        
        photoImageView.isUserInteractionEnabled = true
        let photoTapGesture = UITapGestureRecognizer()
        photoImageView.addGestureRecognizer(photoTapGesture)
        photoTapGesture.rx.event
            .asDriver()
            .throttle(Constants.DefaultValue.tapEventThrottleIntevalTime)
            .drive(onNext: { [weak self] _ in
                self?.photoTapped.onNext(self?.paragraph.media?.id)
            })
            .disposed(by: disposeBag)
    }
    
    func bindInterest() {
        interestView.bindInterests(interests: paragraph.media?.interests,
                                   isExpanded: self.paragraph.media?.isInterestExpanded ?? false)
        interestView.bindLabel(label: paragraph.label,
                               isExpanded: self.paragraph.media?.isInterestExpanded ?? false)
        interestView.applyAccentColor(accentColor: accentColor)
        interestView.disposeBag.addDisposables([
            interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                self.interestViewHeightConstraint.constant = viewHeight
                self.layoutIfNeeded()
                self.didChangeInterestView.onNext(self)
            }),
            interestView.didExpand.subscribe(onNext: { [unowned self] _ in
                self.paragraph.media?.isInterestExpanded = true
            })
        ])
        interestView.reLayoutConstraints()
    }
    
    func bindTaggedPage() {
        showTaggedPage()
    }
    
    private func showTaggedPage() {
        guard let image = paragraph.media, image.hasTag2Page else {
            taggedContainerView.isHidden = true
            taggedPagesViewHeightConstraint.constant = 0
            return
        }
        taggedContainerView.isHidden = false
        guard let taggedPages = image.taggedPages, image.isTaggedPageExpanded else {
            shouldExpandTaggedPage(false)
            return
        }
        taggedPagesView.bindData(tagedPages: taggedPages)
        taggedPagesView.setColorForTitle(color: taggedPagesTitleColor)
        
        taggedPagesView.disposeBag.addDisposables([
            taggedPagesView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.didTapTaggedPage.onNext(menuPage)
            })
        ])
        shouldExpandTaggedPage(image.isTaggedPageExpanded)
    }
    
    private func shouldExpandTaggedPage(_ should: Bool) {
        if should {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightWhenShow
            if let taggedPages = paragraph.media?.taggedPages {
                taggedPagesView.bindData(tagedPages: taggedPages)
                taggedPagesView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                    self.didTapTaggedPage.onNext(menuPage)
                }).disposed(by: taggedPagesView.disposeBag)
            }
            taggedContainerView.backgroundColor = taggedContainerViewColor
            buttonTaggedPages.setImage(R.image.iconInfoSolid(), for: .normal)
            taggedPagesView.isHidden = false
            paragraph.media?.isTaggedPageExpanded = true
        } else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
            buttonTaggedPages.setImage(R.image.iconHomestreamTagOutline(), for: .normal)
            taggedContainerView.backgroundColor = UIColor.clear
            taggedPagesView.isHidden = true
            paragraph.media?.isTaggedPageExpanded = false
        }
    }
    
    @IBAction func buttonTaggedTouch() {
        guard let image = paragraph.media else { return }
        if image.isGettingTaggedPages {
            if taggedPagesViewHeightConstraint.constant == taggedViewHeightWhenShow {
                shouldExpandTaggedPage(false)
            } else {
                shouldExpandTaggedPage(true)
            }
        } else {
            image.isGettingTaggedPages = true
            image.isTaggedPageExpanded = true
            didTapButtonTaggedPages.onNext(image)
        }
    }

    func bindContentDescription(paragraph: Paragraph, accentColor: UIColor?) {
        if let text = paragraph.media?.description {
            mediaDescription.from(html: text)
            Common.setupDescriptionFor(label: mediaDescription, whenExpanding: paragraph.media!.isTextExpanded,
                                maxLines: Constants.DefaultValue.numberOfLinesForImageDescription,
                                linkColor: accentColor,
                                delegate: self)
        }
        mediaDescriptionTopConstraint.constant = (mediaDescription.text!.isEmpty) ? 0 : mediaDescriptionTopMargin
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                              viewPortHeight: CGFloat,
                                              isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        guard let image = paragraph.media, image.isAGif else { return (isVideo: false, shouldResume: false) }
        let gifHeight = photoImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + photoImageView.convert(photoImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? photoImageView.resumeGifAnimation() : photoImageView.pauseGifAnimation()
        return (isVideo: false, shouldResume: false) // TODO: TO BE UPDATED
    }

    func expandPostTextLabel() {
        if let text = paragraph.media?.description {
            mediaDescription.from(html: text)
            paragraph.media?.isTextExpanded = true
            layoutIfNeeded()
            expandedText.onNext(self)
        }
    }
}

extension ArticleParagraphImageCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == Constants.DefaultValue.CustomUrlForMoreText.absoluteString {
            expandPostTextLabel()
        }
    }
}
