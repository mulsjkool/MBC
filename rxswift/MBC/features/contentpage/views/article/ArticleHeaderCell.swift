//
//  ArticleHeaderCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/3/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class ArticleHeaderCell: BaseTableViewCell {
    
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var viewCountLabel: PaddingLabel!
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var photoButton: UIButton!
    @IBOutlet weak private var authorView: AvatarFullScreenView!
    @IBOutlet weak private var taggedPagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var taggedPagesView: TaggedPagesView!
    @IBOutlet weak private var taggedContainerView: UIView!
    @IBOutlet weak private var buttonTaggedPages: UIButton!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    
    private let taggedViewHeightDefault: CGFloat = Constants.DefaultValue.taggedViewHeightDefault
    private let taggedViewHeightWhenShow: CGFloat = Constants.DefaultValue.taggedViewHeightWhenShow
    private let taggedPagesTitleColor = Colors.unselectedTabbarItem.color()
    private let taggedContainerViewColor = Colors.dark.color()
    
    private var article: Article!
    private var accentColor: UIColor?
    let didChangeInterestView = PublishSubject<ArticleHeaderCell>()
    let didTapToOpenPhotoFullScreen = PublishSubject<Void>()
    let didTapButtonTaggedPages = PublishSubject<Media>()
    var shareTapped: Observable<Likable> {
        return self.likeCommentShareView.shareTapped.asObservable()
    }
    
    var commentTapped: Observable<Likable> {
        return self.likeCommentShareView.commentTapped.asObservable()
    }
    let didTapTaggedPage = PublishSubject<MenuPage>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taggedPagesView.resetPages()
        taggedContainerView.backgroundColor = UIColor.clear
    }
    
    func bindData(article: Article, accentColor: UIColor?) {
        self.article = article
        self.accentColor = accentColor
        likeCommentShareView.feed = article
        photoImageView.setImage(from: article.photo, resolution: .ar16x9)
        showTaggedPage()
        interestView.bindInterests(interests: article.interests, isExpanded: self.article.isInterestExpanded)
        interestView.bindLabel(label: article.label, isExpanded: self.article.isInterestExpanded)
        interestView.applyAccentColor(accentColor: accentColor)
        interestView.disposeBag.addDisposables([
            interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                self.interestViewHeightConstraint.constant = viewHeight
                self.layoutIfNeeded()
                self.didChangeInterestView.onNext(self)
            }),
            interestView.didExpand.subscribe(onNext: { [unowned self] _ in
                self.article.isInterestExpanded = true
            })
        ])
        interestView.reLayoutConstraints()
        
        titleLabel.text = article.title ?? ""
        titleLabelTopConstraint.constant = (titleLabel.text?.isEmpty)! ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
        
        bindAuthor()
    }
    
    private func bindAuthor() {
        guard let author = article.author else { return }
        authorView.bindData(author, publishedDate: article.publishedDate, contentType: article.type,
                            subType: article.subType)
        authorView.bindContentTypeForAppCard(contentType: article.type, subType: article.subType)
    }
    
    private func shouldShowButtonTaggedPages() {
        guard article.photo.hasTag2Page else {
            taggedPagesViewHeightConstraint.constant = 0
            return
        }
        buttonTaggedPages.setImage(R.image.iconHomestreamTagOutline(), for: .normal)
        taggedContainerView.backgroundColor = UIColor.clear
        buttonTaggedPages.isUserInteractionEnabled = true
        article.photo.isTaggedPageExpanded = false
        taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
    }
    
    private func showTaggedPage() {
        guard article.photo.hasTag2Page else {
            taggedPagesViewHeightConstraint.constant = 0
            return
        }
        guard let taggedPages = article.photo.taggedPages else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
            return
        }
        taggedPagesView.bindData(tagedPages: taggedPages)
        taggedPagesView.setColorForTitle(color: taggedPagesTitleColor)
        taggedPagesView.disposeBag.addDisposables([
            taggedPagesView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.didTapTaggedPage.onNext(menuPage)
            })
        ])
        shouldExpandTaggedPage(article.photo.isTaggedPageExpanded)
    }
    
    private func shouldExpandTaggedPage(_ should: Bool) {
        if should {
            if let taggedPages = article.photo.taggedPages {
                taggedPagesView.bindData(tagedPages: taggedPages)
                taggedPagesView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                    self.didTapTaggedPage.onNext(menuPage)
                }).disposed(by: taggedPagesView.disposeBag)
            }
            taggedPagesViewHeightConstraint.constant = taggedViewHeightWhenShow
            taggedContainerView.backgroundColor = taggedContainerViewColor
            buttonTaggedPages.setImage(R.image.iconInfoSolid(), for: .normal)
            taggedPagesView.isHidden = false
            article.photo.isTaggedPageExpanded = true
        } else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
            buttonTaggedPages.setImage(R.image.iconHomestreamTagOutline(), for: .normal)
            taggedContainerView.backgroundColor = UIColor.clear
            taggedPagesView.isHidden = true
            article.photo.isTaggedPageExpanded = false
        }
    }
    
    @IBAction func buttonTaggedTouch() {
        if article.photo.isGettingTaggedPages {
            if taggedPagesViewHeightConstraint.constant == taggedViewHeightWhenShow {
                shouldExpandTaggedPage(false)
            } else {
                shouldExpandTaggedPage(true)
            }
        } else {
            article.photo.isTaggedPageExpanded = true
            article.photo.isGettingTaggedPages = true
            didTapButtonTaggedPages.onNext(article.photo)
        }
    }
    
    @IBAction func didTapPhoto() {
        didTapToOpenPhotoFullScreen.onNext(())
    }
    
    override func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                              viewPortHeight: CGFloat,
                                              isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        guard article.photo.isAGif else { return (isVideo: false, shouldResume: false) }
        let gifHeight = photoImageView.frame.size.height
        let yOrdinateToGif = yOrdinate + photoImageView.convert(photoImageView.bounds, to: self).origin.y
        
        let shouldResume = Common.shouldResumeAnimation(mediaHeight: gifHeight,
                                                        yOrdinateToMedia: yOrdinateToGif,
                                                        viewPortHeight: viewPortHeight)
        shouldResume ? photoImageView.resumeGifAnimation() : photoImageView.pauseGifAnimation()
        
        return (isVideo: false, shouldResume: false) // TODO: To be updated
    }
}
