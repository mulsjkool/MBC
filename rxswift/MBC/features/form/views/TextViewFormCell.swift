//
//  TextViewFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class TextViewFormCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet weak private var errorLabel: UILabel!
    @IBOutlet weak private var placeHolderLabel: UILabel!
    
    var onDidSubmitRequest = PublishSubject<String>()

    var item: FormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func bindData(item: FormItem) {
        self.item = item
        
        titleLabel.text = item.titleLabel
        placeHolderLabel.text = item.placeHolder
        textView.text = item.valueText
        self.updateErrorLabel(errorText: item.error)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        textView.delegate = self
        textView.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        textView.font = Fonts.Primary.regular.toFontWith(size: 12)
        textView.text = ""
        
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = Colors.lightGray1.color().cgColor
        
        placeHolderLabel.textColor = Colors.lightGray1.color()
        placeHolderLabel.font = Fonts.Primary.regular.toFontWith(size: 12)
        
        self.updateErrorLabel(errorText: "")
    }
    
    private func updateErrorLabel(errorText: String) {
        self.errorLabel.text = errorText
    }
}

// MARK: - UITextViewDelegate

extension TextViewFormCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeHolderLabel.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.item?.valueText = textView.text
        self.onDidSubmitRequest.onNext(textView.text)
    }
}
