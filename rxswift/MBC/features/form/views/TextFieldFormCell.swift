//
//  TextFieldFormCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 3/28/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class TextFieldFormCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    var onDidSubmitRequest = PublishSubject<String>()
    
    var item: FormItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func bindData(item: FormItem) {
        self.item = item
        
        titleLabel.text = item.titleLabel
        textField.placeholder = item.placeHolder
        textField.text = item.valueText
        self.updateErrorLabel(errorText: item.error)
        
        textField.keyboardType = .default
        
        if item.type == .email {
            textField.keyboardType = .emailAddress
        } else if item.type == .phone {
            textField.keyboardType = .phonePad
        }
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        textField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        textField.font = Fonts.Primary.regular.toFontWith(size: 12)
        textField.delegate = self
        
        self.updateErrorLabel(errorText: "")
    }
    
    private func updateErrorLabel(errorText: String) {
        self.errorLabel.text = errorText
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldFormCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let strText = textFieldText.replacingCharacters(in: range, with: string)
        
        // Others: Maximum 100 chars
        if strText.length > 100 {
            return false
        }
        
        self.item?.valueText = strText
        onDidSubmitRequest.onNext(strText)
        return true
    }
}
