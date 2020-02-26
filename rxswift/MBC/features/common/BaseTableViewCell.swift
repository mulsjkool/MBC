//
//  BaseTableViewCell.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 12/19/17.
//  Copyright © 2017 MBC. All rights reserved.
//

import RxSwift
import UIKit

class BaseTableViewCell: UITableViewCell {

    var indexRow = 0
    var disposeBag = DisposeBag()
    
    // restore last playback position
    var lastPlaybackPosition: (currentTime: Double, hasEnded: Bool) = (0, false)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func resumeOrPauseAnimation(yOrdinate: CGFloat,
                                         viewPortHeight: CGFloat,
                                         isAVideoPlaying: Bool = false) -> (isVideo: Bool, shouldResume: Bool) {
        // swiftlint:disable fatal_error
        fatalError("Please override me")
    }
    
    // Use in user profile
    func setErrorTextAndErrorStatus(errorLabel: UILabel, textField: UITextField, text: String) {
        errorLabel.text = text
        let color = text.isEmpty ? Colors.unselectedTabbarItem.color().cgColor
            : Colors.defaultAccentColor.color().cgColor
        textField.layer.borderColor = color
    }
	
	func showConfirm(viewController: UIViewController, message: String,
					 leftAction: AlertAction, rightAction: AlertAction) {
		let alert = UIAlertController(title: R.string.localizable.commonAlertTitleMessage(),
									  message: message, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: leftAction.title,
									  style: .default, handler: { _ in leftAction.handler() }))
		
		alert.addAction(UIAlertAction(title: rightAction.title,
									  style: .default, handler: { _ in rightAction.handler() }))
		
		viewController.present(alert, animated: true, completion: nil)
	}
}
