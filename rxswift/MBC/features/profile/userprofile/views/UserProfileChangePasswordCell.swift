//
//  UserProfileChangePasswordCell.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/26/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class UserProfileChangePasswordCell: BaseTableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    
    @IBOutlet weak private var oldPasswordTextField: UITextField!
    @IBOutlet weak private var newPasswordTextField: UITextField!
    @IBOutlet weak private var renewPasswordTextField: UITextField!
    
    @IBOutlet weak private var oldPasswordErrorLabel: UILabel!
    @IBOutlet weak private var newPasswordErrorLabel: UILabel!
    @IBOutlet weak private var renewPasswordErrorLabel: UILabel!
    
    @IBOutlet weak private var okButton: UIButton!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var editButton: UIButton!
    
    @IBOutlet weak private var eyeOldPasswordButton: UIButton!
    @IBOutlet weak private var eyeNewPasswordButton: UIButton!
    @IBOutlet weak private var eyeRenewPasswordButton: UIButton!
    
    @IBOutlet private var constraintBottomOldPassErrorLabel: NSLayoutConstraint!
    
    private var strOldPasswordText: String = ""
    private var strNewPasswordText: String = ""
    private var strRenewPasswordText: String = ""
    private var errorOldPasswordText: String = ""
    private var errorNewPasswordText: String = ""
    private var errorRenewPasswordText: String = ""
    
    var profileItem: ProfilePasswordItem!
    
    var onDidSubmitRequest = PublishSubject<(oldPassword: String, newPassword: String)>()
    var onNeedReloadCell = PublishSubject<Void>()
    var onEditButtonClicked = PublishSubject<(UserProfileChangePasswordCell)>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    private func setupUI() {
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        renewPasswordTextField.delegate = self
        
        oldPasswordTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        newPasswordTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        renewPasswordTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        
        oldPasswordTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        newPasswordTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        renewPasswordTextField.font = Fonts.Primary.regular.toFontWith(size: 12)
        
        oldPasswordTextField.setRightPaddingPoints(oldPasswordTextField.frame.size.height)
        newPasswordTextField.setRightPaddingPoints(newPasswordTextField.frame.size.height)
        renewPasswordTextField.setRightPaddingPoints(renewPasswordTextField.frame.size.height)
        
        self.updateErrorLabel(errorText: self.errorOldPasswordText, errorLabel: oldPasswordErrorLabel,
                              textField: oldPasswordTextField)
        self.updateErrorLabel(errorText: self.errorNewPasswordText, errorLabel: newPasswordErrorLabel,
                              textField: newPasswordTextField)
        self.updateErrorLabel(errorText: self.errorRenewPasswordText, errorLabel: renewPasswordErrorLabel,
                              textField: renewPasswordTextField)
    }
    
    func bindData(item: ProfilePasswordItem) {
        self.profileItem = item
        
        self.isEditingView(flag: item.isEditting)
        
        titleLabel.text = item.titleLabel
        oldPasswordTextField.placeholder = item.placeHolderOldPassword
        newPasswordTextField.placeholder = item.placeHolderNewPassword
        renewPasswordTextField.placeholder = item.placeHolderReNewPassword
    }
    
    // MARK: - Private methods
    
    private func isEditingView(flag: Bool) {
        okButton.isHidden = !flag
        cancelButton.isHidden = !flag
        editButton.isHidden = flag
        oldPasswordTextField.isHidden = !flag
        newPasswordTextField.isHidden = !flag
        renewPasswordTextField.isHidden = !flag
        eyeOldPasswordButton.isHidden = !flag
        eyeNewPasswordButton.isHidden = !flag
        eyeRenewPasswordButton.isHidden = !flag
        
        valueLabel.isHidden = flag
        
        constraintBottomOldPassErrorLabel.isActive = !flag
    }
    
    private func updateStatus() {
        self.profileItem.isEditting = !self.profileItem.isEditting
        self.isEditingView(flag: self.profileItem.isEditting)
    }
    
    private func updateErrorLabel(errorText: String, errorLabel: UILabel, textField: UITextField) {
        if textField == oldPasswordTextField {
            errorOldPasswordText = errorText
        } else if textField == newPasswordTextField {
            errorNewPasswordText = errorText
        } else if textField == renewPasswordTextField {
            errorRenewPasswordText = errorText
        }
        self.setErrorTextAndErrorStatus(errorLabel: errorLabel, textField: textField,
                                        text: errorText)
    }
    
    private func hideKeyboard() {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        renewPasswordTextField.resignFirstResponder()
    }
    
    private func removeAllText() {
        strOldPasswordText = ""
        strNewPasswordText = ""
        strRenewPasswordText = ""
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        renewPasswordTextField.text = ""
        oldPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        renewPasswordTextField.isSecureTextEntry = true
        self.updateErrorLabel(errorText: strOldPasswordText, errorLabel: oldPasswordErrorLabel,
                              textField: oldPasswordTextField)
        self.updateErrorLabel(errorText: strNewPasswordText, errorLabel: newPasswordErrorLabel,
                              textField: newPasswordTextField)
        self.updateErrorLabel(errorText: strRenewPasswordText, errorLabel: renewPasswordErrorLabel,
                              textField: renewPasswordTextField)
    }
    
    // MARK: - Check condition
    
    private func checkPassword() -> Bool {
        if !self.checkFieldRequired(strText: strOldPasswordText, errorLabel: oldPasswordErrorLabel,
                                    textField: oldPasswordTextField) { return false }
        
        //////////////////////////////////
        if !self.checkFieldRequired(strText: strNewPasswordText, errorLabel: newPasswordErrorLabel,
                                    textField: newPasswordTextField) { return false }
        if !self.checkPassWordFormat(strText: strNewPasswordText, errorLabel: newPasswordErrorLabel,
                                     textField: newPasswordTextField) { return false }
        
        //////////////////////////////////
        if !self.checkFieldRequired(strText: strRenewPasswordText, errorLabel: renewPasswordErrorLabel,
                                    textField: renewPasswordTextField) { return false }
        if strNewPasswordText != strRenewPasswordText {
            self.updateErrorLabel(errorText: R.string.localizable.errorPasswordsNotMatch(),
                                  errorLabel: renewPasswordErrorLabel, textField: renewPasswordTextField)
            self.onNeedReloadCell.onNext(())
            return false
        }
        
        return true
    }
    
    private func checkPassWordFormat(strText: String, errorLabel: UILabel, textField: UITextField) -> Bool {
        if !strText.isPassword {
            self.updateErrorLabel(errorText: R.string.localizable.errorPasswordFormatIncorrect(),
                                  errorLabel: errorLabel, textField: textField)
            self.onNeedReloadCell.onNext(())
            return false
        }
        return true
    }
    
    private func checkFieldRequired(strText: String, errorLabel: UILabel, textField: UITextField) -> Bool {
        if strText.isEmpty {
            self.updateErrorLabel(errorText: R.string.localizable.errorFieldIsRequired(),
                                  errorLabel: errorLabel, textField: textField)
            self.onNeedReloadCell.onNext(())
            return false
        }
        return true
    }
    
    // MARK: - Action
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.hideKeyboard()
        self.updateStatus()
        self.removeAllText()
        self.onNeedReloadCell.onNext(())
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        self.hideKeyboard()
        
        if self.checkPassword() {
            self.updateStatus()
            onDidSubmitRequest.onNext((self.strOldPasswordText, self.strNewPasswordText))
            self.removeAllText()
        }
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.updateStatus()
        oldPasswordTextField.becomeFirstResponder()
        onEditButtonClicked.onNext(self)
    }
    
    @IBAction func eyeOldPasswordButtonClicked(_ sender: Any) {
        oldPasswordTextField.isSecureTextEntry = !oldPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func eyeNewPasswordButtonClicked(_ sender: Any) {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func eyeRenewPasswordButtonClicked(_ sender: Any) {
        renewPasswordTextField.isSecureTextEntry = !renewPasswordTextField.isSecureTextEntry
    }
}

// MARK: - UITextFieldDelegate

extension UserProfileChangePasswordCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(oldPasswordTextField) {
            newPasswordTextField.becomeFirstResponder()
        } else if textField.isEqual(newPasswordTextField) {
            renewPasswordTextField.becomeFirstResponder()
        } else if textField.isEqual(renewPasswordTextField) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(oldPasswordTextField) && !errorOldPasswordText.isEmpty {
            self.updateErrorLabel(errorText: "", errorLabel: oldPasswordErrorLabel,
                                  textField: oldPasswordTextField)
            self.onNeedReloadCell.onNext(())
        } else if textField.isEqual(newPasswordTextField) && !errorNewPasswordText.isEmpty {
            self.updateErrorLabel(errorText: "", errorLabel: newPasswordErrorLabel,
                                  textField: newPasswordTextField)
            self.onNeedReloadCell.onNext(())
        } else if textField.isEqual(renewPasswordTextField) && !errorRenewPasswordText.isEmpty {
            self.updateErrorLabel(errorText: "", errorLabel: renewPasswordErrorLabel,
                                  textField: renewPasswordTextField)
            self.onNeedReloadCell.onNext(())
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let strText = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.isEqual(oldPasswordTextField) {
            strOldPasswordText = strText
        } else if textField.isEqual(newPasswordTextField) {
            strNewPasswordText = strText
        } else if textField.isEqual(renewPasswordTextField) {
            strRenewPasswordText = strText
        }
        return true
    }
}
