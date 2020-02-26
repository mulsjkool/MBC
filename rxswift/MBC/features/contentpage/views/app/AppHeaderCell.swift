//
//  AppHeaderCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import TTTAttributedLabel

class AppHeaderCell: BaseTableViewCell {
    @IBOutlet weak private var appImageView: UIImageView!
    @IBOutlet weak private var appTitleLabel: UILabel!
    @IBOutlet weak private var interestView: InterestView!
    @IBOutlet weak private var interestViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak private var authorView: AvatarFullScreenView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var ctaButton: UIButton!
    @IBOutlet weak private var interestViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var titleLabelTopConstraint: NSLayoutConstraint!
    
    var shareTapped: Observable<Likable> {
        return self.likeCommentShareView.shareTapped.asObservable()
    }
    
    var commentTapped: Observable<Likable> {
        return self.likeCommentShareView.commentTapped.asObservable()
    }
    
    var whitePageButtonTapped = PublishSubject<Void>()
    
    private var accentColor: UIColor!
    var app: App!
    private var tagPageDefaulHeight: CGFloat = 86
    private let titleLabelTopMargin: CGFloat = 16.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        ctaButton.titleLabel?.font = Fonts.Primary.semiBold.toFontWith(size: 12)
        ctaButton.contentHorizontalAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
    }

    func bindData(app: App, accentColor: UIColor?) {
        self.app = app
        self.accentColor = accentColor ?? Colors.defaultAccentColor.color()
        bindAppPhoto()
        bindTitle()
        bindAuthor()
        bindDescription()
        bindInterest()
        bindCTAButton()
        bindSocialActivities(feed: app)
        setupEvents()
    }
    
    private func setupEvents() {
        ctaButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.whitePageButtonTapped.onNext(())
        }).disposed(by: self.disposeBag)
    }
    
    private func bindSocialActivities(feed: Feed) {
        likeCommentShareView.feed = feed
    }
    
    private func bindAppPhoto() {
        guard let photo = app.photo else {
            appImageView.image = Constants.DefaultValue.defaulNoLogoImage
            return
        }
        appImageView.setImage(from: photo, resolution: .ar16x16)
    }
    
    private func bindTitle() {
        appTitleLabel.text = app.title ?? ""
        titleLabelTopConstraint.constant = (appTitleLabel.text?.isEmpty)! ? 0 : titleLabelTopMargin
    }
    
    private func bindCTAButton() {
        guard let subTypeStr = app.subType, let subType = AppSubType(rawValue: subTypeStr) else {
            ctaButton.setTitle("", for: .normal)
            return
        }
        ctaButton.setTitle(subType.localizedContentType(), for: .normal)
        ctaButton.backgroundColor = self.accentColor
    }
    
    private func bindAuthor() {
        guard let author = app.author else { return }
        authorView.bindData(author, publishedDate: app.publishedDate, contentType: app.type, subType: app.subType)
        authorView.bindContentTypeForAppCard(contentType: app.type, subType: app.subType)
    }
    
    private func bindDescription() {
        guard let text = app.description else { return }
        descriptionLabel.from(html: text)
        descriptionLabel.setLineSpacing(lineSpacing: 0,
                                        lineHeightMultiple: Constants.DefaultValue.descriptionLineHeightMultiple)
    }
    
    private func bindInterest() {
        guard let interests = app.interests, !interests.isEmpty else {
            interestView.isHidden = true
            interestViewTopConstraint.constant = 0
            interestViewHeightConstraint.constant = 0
            layoutIfNeeded()
            return
        }
        interestView.bindInterests(interests: interests, isExpanded: false)
        interestViewTopConstraint.constant = Constants.DefaultValue.interestViewTopMargin
        layoutIfNeeded()
        interestView.applyAccentColor(accentColor: accentColor)
        self.disposeBag.addDisposables([
            interestView.needToUpdateHeight.subscribe(onNext: { [unowned self] viewHeight in
                self.interestViewHeightConstraint.constant = viewHeight
            })
        ])
        interestView.reLayoutConstraints()
    }
}
