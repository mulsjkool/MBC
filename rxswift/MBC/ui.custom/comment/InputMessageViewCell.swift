//
//  InputMessageViewCell.swift
//  MBC
//
//  Created by Tri Vo Minh on 4/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class InputMessageViewCell: BaseTableViewCell {
	
	@IBOutlet weak private var messageTextView: GrowingTextView!
	@IBOutlet weak private var coverButton: UIButton!
	@IBOutlet weak private var sendButton: UIButton!
	@IBOutlet weak private var sendButtonWidthConstraint: NSLayoutConstraint!
	let onInputMessage = PublishSubject<Void>()
	
	override func awakeFromNib() {
        super.awakeFromNib()
		setupUI()
    }
	
	private func setupUI() {
		messageTextView.text = ""
		messageTextView.textContainer.lineFragmentPadding = 8
		messageTextView.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
		messageTextView.placeHolder = Constants.Singleton.isiPad ?
												R.string.localizable.ipadCommentInputMessagePlaceholder() :
												R.string.localizable.commentInputMessagePlaceholder()
		sendButton.setTitle(Constants.Singleton.isiPad ? R.string.localizable.ipadCommentSendButtonTitle() :
														R.string.localizable.commentSendButtonTitle(), for: .normal)
		sendButtonWidthConstraint.constant = Constants.DefaultValue.sendCommentButtonWidth
	}
	
	@IBAction func inputMessageTapped(_ sender: Any) {
		onInputMessage.onNext(())
	}
}
