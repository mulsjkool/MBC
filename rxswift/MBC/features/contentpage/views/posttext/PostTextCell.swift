//
//  PostTextCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/26/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

class PostTextCell: BaseTableViewCell {
    
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var authorView: AvatarFullScreenView!
    @IBOutlet weak private var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var interestViewTopConstraint: NSLayoutConstraint!
    
    var post: Post!
    private var accentColor: UIColor?
    let didChangeInterestView = PublishSubject<PostTextCell>()
    var commentTapped: Observable<Likable> {
        return self.likeCommentShareView.commentTapped.asObservable()
    }
    
    var shareTapped: Observable<Likable> {
        return self.likeCommentShareView.shareTapped.asObservable()
    }
    
    func bindData(post: Post, accentColor: UIColor) {
        self.post = post
        self.accentColor = accentColor
        descriptionLabel.from(html: post.description ?? "")
        descriptionLabel.setLineSpacing(lineSpacing: 0,
                                        lineHeightMultiple: Constants.DefaultValue.descriptionLineHeightMultiple)
        descriptionTopConstraint.constant = (descriptionLabel.text?.isEmpty)! ? 0
            : Constants.DefaultValue.titleAndDescriptionLabelTopMargin
        bindAuthor()
        bindInterest()
        likeCommentShareView.feed = post
    }
    
    private func bindAuthor() {
        guard let author = post.author else { return }
        authorView.bindData(author, publishedDate: post.publishedDate, contentType: post.type, subType: post.subType)
        authorView.bindContentTypeForAppCard(contentType: post.type, subType: post.subType)
    }
    
    func getInterestView() -> InterestView {
        return interestView
    }
    
    private func bindInterest() {
        interestView.bindInterests(interests: post.interests, isExpanded: self.post.isInterestExpanded)
        interestView.bindLabel(label: post.label, isExpanded: self.post.isInterestExpanded)
        interestView.applyAccentColor(accentColor: accentColor)
        interestView.disposeBag.addDisposables([
            interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                self.interestViewHeightConstraint.constant = viewHeight
                self.interestViewTopConstraint.constant = (viewHeight == 0) ? 0
                    : Constants.DefaultValue.interestViewTopMargin
                self.layoutIfNeeded()
                self.didChangeInterestView.onNext(self)
            }),
            interestView.didExpand.subscribe(onNext: { [unowned self] _ in
                self.post.isInterestExpanded = true
            })
        ])
        interestView.reLayoutConstraints()
    }
}
