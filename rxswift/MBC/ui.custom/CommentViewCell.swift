//
//  CommentViewCell.swift
//  MBC
//
//  Created by Tri Vo on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import TTTAttributedLabel

enum CommentStatusEnum: String {
	case nonSupported, pending, approved, rejected, deleted
}

class CommentViewCell: BaseTableViewCell {
    @IBOutlet weak private var authorImageView: UIImageView!
    @IBOutlet weak private var authorNameLabel: UILabel!
    @IBOutlet weak private var messageLabel: TTTAttributedLabel!
    @IBOutlet weak private var removeButtonWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak private var timestampLabel: UILabel!
	
    private let socialService = Components.userSocialService
    private let sessionRepository = Components.sessionRepository
    private let startRemoveCommentOnDemand = PublishSubject<Comment>()
    
    var comment: Comment!
    
    // Rx
    let expandedText = PublishSubject<CommentViewCell>()
    let authorAvatarTapped = PublishSubject<Comment>()
    let authorNameTapped = PublishSubject<Comment>()
    let didTapDescription = PublishSubject<Comment>()
    
    let onWillStartRemoveComment = PublishSubject<Void>()
    let onWillStopRemoveComment = PublishSubject<Void>()
    let successRemoveComment = PublishSubject<Comment>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func expandMessageTextLabel() {
        if let message = comment.message {
            self.messageLabel.text = message
            self.comment.isTextExpanded = true
            self.layoutIfNeeded()
            self.expandedText.onNext(self)
        }
    }
    
    func bindData(comment: Comment, accentColor: UIColor? = nil) {
        self.comment = comment
        
        if let thumbnailUrl = comment.author?.avatarUrl {
            self.authorImageView.setSquareImage(imageUrl: thumbnailUrl)
        }
        
        if let authorName = comment.author?.name {
            self.authorNameLabel.text = authorName
        }
        
        if let message = comment.message {
            self.messageLabel.text = message
            Common.setupDescriptionFor(label: self.messageLabel, whenExpanding: comment.isTextExpanded,
                                       maxLines: Constants.DefaultValue.numberOfLinesForImageDescription,
                                       linkColor: accentColor,
                                       delegate: self)
        }
		
		self.timestampLabel.text = (comment.publishedDate != nil) ? comment.publishedDate?.getCardTimestamp() : ""
        
        if let user = sessionRepository.currentSession?.user, let authorComment = comment.author {
            self.removeButtonWidthConstraint.constant = user.uid == authorComment.authorId ? 36 : 0
        }
		
		setUpRxRemoveComment()
    }
    
    private func setUpRxRemoveComment() {
        startRemoveCommentOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartRemoveComment.onNext(())
            })
            .flatMap { [unowned self] commentData -> Observable<Void> in
                return self.socialService.removeComment(data: commentData)
                    .catchError { _ -> Observable<Void> in
                        self.onWillStopRemoveComment.onNext(())
                        return Observable.empty()
                    }
            }
            .do(onNext: { [unowned self] _ in self.successRemoveComment.onNext(self.comment) })
            .do(onNext: { [unowned self] _ in self.onWillStopRemoveComment.onNext(()) })
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action method
    @IBAction func removeTapped(_ sender: Any) {
		guard let parentViewController = self.viewController else { return }
		
		let leftAction = AlertAction(title: R.string.localizable.commonButtonTextYes(), handler: {
			self.startRemoveCommentOnDemand.onNext(self.comment)
		})
		let rightAction = AlertAction(title: R.string.localizable.commonButtonTextCancel(), handler: {  })
		var commentStatus = CommentStatusEnum.nonSupported.rawValue
		if let statusType = CommentStatusEnum(rawValue: comment.status!) {
			if statusType == .pending { commentStatus = R.string.localizable.commentPending() }
			if statusType == .approved { commentStatus = R.string.localizable.commentApproved() }
		}
		showConfirm(viewController: parentViewController,
					message: R.string.localizable.commentConfirmDelete(commentStatus),
					leftAction: leftAction, rightAction: rightAction)
    }
}

extension CommentViewCell: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == Constants.DefaultValue.CustomUrlForMoreText.absoluteString {
            expandMessageTextLabel()
        } else if url.absoluteString == Constants.DefaultValue.CustomUrlForPostText.absoluteString {
            print("+>[CommentViewCell]: Open link URL...")
        }
    }
}
