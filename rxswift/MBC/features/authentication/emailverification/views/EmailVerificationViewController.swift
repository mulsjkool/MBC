//
//  EmailVerificationViewController.swift
//  MBC
//
//  Created by Cuong Nguyen Manh on 1/10/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import RxSwift
import UIKit

class EmailVerificationViewController: BaseViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!
    
    @IBOutlet weak private var emailErrorLabel: UILabel!
    
    @IBOutlet weak private var emailTextField: UITextField!
    
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var resendEmailButton: UIButton!
    
    var viewModel: EmailVerificationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        setupUI()
        bindEvents()
    }
    
    private func bindEvents() {
        disposeBag.addDisposables([
            loginButton.rx.tap.subscribe(onNext: { _ in
                self.dismiss(animated: false, completion: nil)
            }),
            
            resendEmailButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.viewModel.resendEmail()
            }),
            
            viewModel.onWillStartResendingEmail.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),
            
            viewModel.onWillStopResendingEmail.subscribe(onNext: {
                self.hideLoading(showInView: nil)
            }),
            
            viewModel.onEmailRequired.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                                textField: self.emailTextField,
                                                text: R.string.localizable.errorFieldIsRequired())
            }),
            
            viewModel.onInvalidEmail.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                                textField: self.emailTextField,
                                                text: R.string.localizable.errorEmailFormatIncorrect())
            }),
            
            viewModel.onEmailValidated.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                                textField: self.emailTextField,
                                                text: "")
            }),
            
            viewModel.onShowError.subscribe(onNext: { [unowned self] error in
                if let text = error.errorString(), !text.isEmpty {
                    self.showMessage(message: text)
                }
            })
        ])
    }
    
    private func setupUI() {
        titleLabel.text = R.string.localizable.emailVerificationTitle()
        subTitleLabel.text = R.string.localizable.emailVerificationSubTitle()
    
        loginButton.setTitle(R.string.localizable.emailVerificationLogin(), for: .normal)
        resendEmailButton.setTitle(R.string.localizable.emailVerificationSendEmailAgain(), for: .normal)
        
        emailTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        emailTextField.placeholder = R.string.localizable.commonEmailPlaceHolder()
        emailTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        
        self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField, text: "")
        
        emailTextField.text = viewModel.emailString.value
        emailTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension EmailVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel,
                                        textField: self.emailTextField, text: "")
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        viewModel.emailString.value = txtAfterUpdate
        return true
    }
}
