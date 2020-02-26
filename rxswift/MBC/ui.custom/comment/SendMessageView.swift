//
//  SendMessageView.swift
//  MBC
//
//  Created by Tri Vo on 1/29/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import MisterFusion

class SendMessageView: BaseView {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var messageTextView: GrowingTextView!
    @IBOutlet weak private var messageHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak private var sendButton: UIButton!
	@IBOutlet weak private var sendButtonWidthConstraint: NSLayoutConstraint!
	
    private weak var heightConstraint: NSLayoutConstraint!
    private let socialService = Components.userSocialService
    private let sessionRepository = Components.sessionRepository
    private var pageId: String!
    private var contentId: String!
    private var contentType: String!
    
    private let startSendCommentsOnDemand = PublishSubject<CommentData>()
    
    // Rx
    var onSendComments: Observable<Void>! /// finish loading a round
    var onWillStartSendComment = PublishSubject<Void>()
    var onWillStopSendComments = PublishSubject<Void>()
	var onDidErrorSendComments = PublishSubject<Void>()
    var successSendComments = PublishSubject<Comment>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func bindData(authorId pageId: String?, contentId contId: String?, contentType contType: String?) {
        self.pageId = pageId ?? ""
        self.contentId = contId ?? ""
        self.contentType = contType ?? ""
        setUpRxSendComment()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(R.nib.sendMessageView.name, owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        self.mf.addConstraints([
            self.top |==| containerView.top,
            self.left |==| containerView.left,
            self.bottom |==| containerView.bottom,
            self.right |==| containerView.right
        ])
        setupUI()
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if let constraint = self.constraint(of: .height) { heightConstraint = constraint }
    }
    
    private func setupUI() {
        messageTextView.text = ""
        messageTextView.textContainer.lineFragmentPadding = 8
        messageTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        messageTextView.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        messageTextView.delegate = self
		messageTextView.placeHolder = Constants.Singleton.isiPad ?
														R.string.localizable.ipadCommentInputMessagePlaceholder() :
														R.string.localizable.commentInputMessagePlaceholder()
		sendButton.setTitle(Constants.Singleton.isiPad ? R.string.localizable.ipadCommentSendButtonTitle() :
														R.string.localizable.commentSendButtonTitle(), for: .normal)
		sendButtonWidthConstraint.constant = Constants.DefaultValue.sendCommentButtonWidth
    }
    
    public func forceEditing() {
        self.messageTextView.becomeFirstResponder()
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        guard let currentUser = sessionRepository.currentSession?.user, let pageId = self.pageId,
            let contentId = self.contentId, let contentType = self.contentType, !messageTextView.text.trim().isEmpty,
            messageTextView.text.trim().length < Constants.DefaultValue.MaxMessageCharacter else { return }
        
        let message = messageTextView.text.trim()
        if pageId.isEmpty || contentId.isEmpty || contentType.isEmpty { return }
        
        self.messageTextView.text = ""
        startSendCommentsOnDemand
            .onNext(CommentData(userId: currentUser.uid, userName: currentUser.name,
                              thumbnailURL: currentUser.thumbnailURL, contentId: contentId,
                              contentType: contentType, message: message, pageId: pageId))
    }
    
    private func setUpRxSendComment() {
        startSendCommentsOnDemand
            .do(onNext: { [unowned self] _ in
                self.onWillStartSendComment.onNext(())
            })
            .flatMap { [unowned self] commentData -> Observable<Comment> in
                return self.socialService.sendComments(data: commentData)
                        .catchError { _ -> Observable<Comment> in
                            self.onDidErrorSendComments.onNext(())
                            return Observable.empty()
                        }
            }
            .do(onNext: { [unowned self] item in self.successSendComments.onNext(item) })
            .do(onNext: { [unowned self] _ in self.onWillStopSendComments.onNext(()) })
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}

extension SendMessageView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        messageHeightConstraint.constant = height
        heightConstraint.constant = height + Constants.DefaultValue.messagePadding
    }
}
