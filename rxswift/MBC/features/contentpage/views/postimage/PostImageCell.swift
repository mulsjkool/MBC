//
//  PostImageCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/4/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class PostImageCell: PostCardMultiImagesTableViewCell {
    
    @IBOutlet weak private var taggedPagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var taggedPagesView: TaggedPagesView!
    @IBOutlet weak private var taggedContainerView: UIView!
    @IBOutlet weak private var buttonTaggedPages: UIButton!
    
    private let taggedViewHeightDefault: CGFloat = Constants.DefaultValue.taggedViewHeightDefault
    private let taggedViewHeightWhenShow: CGFloat = Constants.DefaultValue.taggedViewHeightWhenShow
    private let taggedPagesTitleColor = Colors.unselectedTabbarItem.color()
    private let taggedContainerViewColor = Colors.dark.color()
    
    let didTapTaggedPage = PublishSubject<MenuPage>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taggedPagesView.resetPages()
        taggedContainerView.backgroundColor = UIColor.clear
    }

    func bindData(post: Post, accentColor: UIColor?) {
        super.bindData(feed: post, accentColor: accentColor)
        bindDesciptionFullText()
        let descriptionLabel = getDescriptionLabel()
        descriptionLabel.setLineSpacing(lineSpacing: 0,
                                        lineHeightMultiple: Constants.DefaultValue.descriptionLineHeightMultiple)
        if getImageCount() > 1 {
            let titleLabel = getTitleLabel()
            titleLabel.text = post.paragraphTitle ?? ""
            if titleLabel.text == "" {
                titleLabel.text = R.string.localizable.commonLabelImageDefaultTitle(post.author?.name ?? "")
            }
        }
        
        bindTaggedPages()
    }
    
    private func bindTaggedPages() {
        guard feed.hasTag2Page else {
            taggedPagesViewHeightConstraint.constant = 0
            return
        }
        guard let taggedPages = feed.tags else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
            return
        }
        
        buttonTaggedPages.rx.tap.subscribe(onNext: { [unowned self] _ in
            if self.taggedPagesViewHeightConstraint.constant == self.taggedViewHeightWhenShow {
                self.shouldExpandTaggedPage(false)
            } else {
                self.shouldExpandTaggedPage(true)
            }
        }).disposed(by: disposeBag)
        
        taggedPagesView.bindData(tagedPages: taggedPages)
        taggedPagesView.setColorForTitle(color: taggedPagesTitleColor)
        shouldExpandTaggedPage(feed.isTaggedPageExpanded)
    }
    
    private func shouldExpandTaggedPage(_ should: Bool) {
        if should {
            if let taggedPages = feed.tags {
                taggedPagesView.bindData(tagedPages: taggedPages)
            }
            taggedPagesView.didTapTaggedPage.subscribe(onNext: { [unowned self] menuPage in
                self.didTapTaggedPage.onNext(menuPage)
            }).disposed(by: taggedPagesView.disposeBag)
            taggedPagesViewHeightConstraint.constant = taggedViewHeightWhenShow
            taggedContainerView.backgroundColor = taggedContainerViewColor
            buttonTaggedPages.setImage(R.image.iconInfoSolid(), for: .normal)
            taggedPagesView.isHidden = false
            feed.isTaggedPageExpanded = true
        } else {
            taggedPagesViewHeightConstraint.constant = taggedViewHeightDefault
            buttonTaggedPages.setImage(R.image.iconHomestreamTagOutline(), for: .normal)
            taggedContainerView.backgroundColor = UIColor.clear
            taggedPagesView.isHidden = true
            feed.isTaggedPageExpanded = false
        }
    }
}
