//
//  ForgotPasswordViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/15/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel1: UILabel!
    @IBOutlet weak private var subTitleLabel2: UILabel!
    
    @IBOutlet weak private var emailErrorLabel: UILabel!
    
    @IBOutlet weak private var emailTextField: UITextField!
    
    @IBOutlet weak private var inputEmailView: UIView!
    @IBOutlet weak private var resendEmailView: UIView!
    
    @IBOutlet weak private var resetPasswordButton: UIButton!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var resendEmailButton: UIButton!
    @IBOutlet weak private var openLoginVCButton: UIButton!
    
    private var viewModel = ForgotPasswordViewModel(interactor: Components.forgotPasswordInteractor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindEvents()
    }

    override func subscribeOnAppear() {
        let disposableStartHome = viewModel.onDidResetPasswordSuccess.subscribe(onNext: { [unowned self] _ in
            self.didResetPasswordSuccess()
        })
        insertToClearOnDisappear(disposable: disposableStartHome)
    }
    
    // MARK: - Private functions
    
    private func setupUI() {
        titleLabel.text = R.string.localizable.forgotpassTitle1()
        subTitleLabel1.text = R.string.localizable.forgotpassSubTitle1()
        subTitleLabel2.text = R.string.localizable.forgotpassSubTitle2()
        
        emailTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        emailTextField.placeholder = R.string.localizable.commonEmailPlaceHolder()
        emailTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        
        resetPasswordButton.setTitle(R.string.localizable.forgotpassResetPassword(), for: .normal)
        resendEmailButton.setTitle(R.string.localizable.forgotpassResendEmail(), for: .normal)
        openLoginVCButton.setTitle(R.string.localizable.forgotpassOpenLoginVC(), for: .normal)
        
        let radius = 5.0 as CGFloat
        
        emailTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        resetPasswordButton.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        openLoginVCButton.format(cornerRadius: radius, color: Colors.defaultAccentColor.color())
        
        resetPasswordButton.isEnabled = false
        self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField, text: "")
        resendEmailView.isHidden = true
    }
    
    private func checkEnableForResetPasswordButton() {
        resetPasswordButton.isEnabled = false
        resetPasswordButton.backgroundColor = Colors.unselectedTabbarItem.color()
        if !viewModel.emailString.value.isEmpty {
            resetPasswordButton.isEnabled = true
            resetPasswordButton.backgroundColor = Colors.defaultText.color()
        }
    }
    
    private func didResetPasswordSuccess() {
        if resendEmailView.isHidden {
            inputEmailView.isHidden = true
            closeButton.isHidden = true
            resendEmailView.isHidden = false
            titleLabel.text = R.string.localizable.forgotpassTitle2()
        }
    }
    
    // MARK: - Events
    
    private func bindEvents() {
        let viewTapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(viewTapGesture)
        
        disposeBag.addDisposables([
            resetPasswordButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
                self.viewModel.resetPassword()
            }),
            
            closeButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            }),
            
            openLoginVCButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            }),
            
            resendEmailButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.viewModel.resetPassword()
            }),
            
            viewTapGesture.rx.event.bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            }),
            
            viewModel.onWillStartResetPassword.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),

            viewModel.onWillStopResetPassword.subscribe(onNext: { [unowned self] _ in
                self.hideLoading(showInView: nil)
            }),

            viewModel.onInvalidEmail.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField,
                                                text: R.string.localizable.errorEmailFormatIncorrect())
            }),

            viewModel.onEmailValidated.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField,
                                                text: "")
            }),

            viewModel.onShowError.subscribe(onNext: { [unowned self] error in
                if let text = error.errorString(), !text.isEmpty {
                    self.showMessage(message: text)
                }
            })
        ])
    }
}

// MARK: - UITextFieldDelegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        checkEnableForResetPasswordButton()
        self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField,
                                        text: "")
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        viewModel.emailString.value = txtAfterUpdate
        checkEnableForResetPasswordButton()
        return true
    }
}
