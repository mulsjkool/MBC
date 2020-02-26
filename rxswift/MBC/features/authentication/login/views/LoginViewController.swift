//
//  LoginViewController.swift
//  MBC
//
//  Created by Voong Tan Quoc Cuong on 1/9/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!
    
    @IBOutlet weak private var emailErrorLabel: UILabel!
    @IBOutlet weak private var passErrorLabel: UILabel!
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    @IBOutlet weak private var loginViaEmailButton: UIButton!
    @IBOutlet weak private var forgetPassButton: UIButton!
    @IBOutlet weak private var loginViaFBButton: UIButton!
    @IBOutlet weak private var registerViaEmailButton: UIButton!
    @IBOutlet weak private var eyeButton: UIButton!
    
    var onOpenEmailVerifyVC = PublishSubject<EmailVerificationViewModel>()
    private var viewModel = LoginViewModel(interactor: Components.signinInteractor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIDevice.current.isSimulator {
            viewModel.emailString.value = "duong.huynh3@mailinator.com"
            viewModel.passwordString.value = "12345678"
        } else {
            viewModel.emailString.value = ""
            viewModel.passwordString.value = ""
        }
        setErrorTextAndErrorStatus(errorLabel: emailErrorLabel, textField: emailTextField, text: "")
        setErrorTextAndErrorStatus(errorLabel: passErrorLabel, textField: passwordTextField, text: "")
    }
    
    override func subscribeOnAppear() {
        let disposableStartHomeAfterSignin =
            viewModel.onStartHomeAfterSignin.subscribe(onNext: { _ in
            Constants.Singleton.appDelegate.openHomeScreen()
        })
        insertToClearOnDisappear(disposable: disposableStartHomeAfterSignin)
    }
    
    // MARK: - Private functions
    
    private func setupUI() {
        titleLabel.text = R.string.localizable.loginTitle()
        subTitleLabel.text = R.string.localizable.loginSubTitle()
        
        passwordTextField.setRightPaddingPoints(passwordTextField.frame.size.height)
        
        emailTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        emailTextField.placeholder = R.string.localizable.commonEmailPlaceHolder()
        emailTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        
        passwordTextField.textAlignment = Constants.DefaultValue.shouldRightToLeft ? .right : .left
        passwordTextField.placeholder = R.string.localizable.commonPasswordPlaceHolder()
        passwordTextField.font = Fonts.Primary.regular.toFontWith(size: 14)
        
        forgetPassButton.setTitle(R.string.localizable.loginForgotPassword(), for: .normal)
        loginViaEmailButton.setTitle(R.string.localizable.loginLoginByEmail(), for: .normal)
        loginViaFBButton.setTitle(R.string.localizable.loginLoginByFacebook(), for: .normal)
        registerViaEmailButton.setTitle(R.string.localizable.loginEmailRegistration(), for: .normal)
        
        let radius = 5.0 as CGFloat
        
        emailTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        passwordTextField.format(cornerRadius: radius, color: Colors.unselectedTabbarItem.color())
        
        loginViaEmailButton.format(cornerRadius: radius, color: Colors.disabledButtonGrayColor.color())
        loginViaFBButton.format(cornerRadius: radius, color: Colors.facebookButton.color())
        registerViaEmailButton.format(cornerRadius: radius, color: Colors.enabledButtonGrayColor.color())
        
        loginViaEmailButton.isEnabled = false
        
        setErrorTextAndErrorStatus(errorLabel: emailErrorLabel, textField: emailTextField, text: "")
        setErrorTextAndErrorStatus(errorLabel: passErrorLabel, textField: passwordTextField, text: "")
    }
    
    private func openForgotPasswordVC() {
        let vc = ForgotPasswordViewController(nibName: R.nib.forgotPasswordViewController.name, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func openEmailVerificationVC() {
        let vc = EmailVerificationViewController(nibName: R.nib.emailVerificationViewController.name, bundle: nil)
        let model = EmailVerificationViewModel(interactor: Components.emailVerificationInteractor(),
                                               email: self.viewModel.emailString.value ?? "")
        vc.viewModel = model
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showAlertAccountPendingVerification() {
        let leftAction = AlertAction(title: R.string.localizable.commonButtonTextResendEmail(), handler: {
            self.openEmailVerificationVC()
        })

        let rightAction = AlertAction(title: R.string.localizable.commonButtonTextCancel(), handler: {  })

        self.showConfirm(message: R.string.localizable.errorAccountPendingVerification(),
                         leftAction: leftAction, rightAction: rightAction)
    }

    // MARK: - Events
    
    private func bindEvents() {
        let viewTapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(viewTapGesture)
        
        disposeBag.addDisposables([
            emailTextField.rx.textInput.text <~> viewModel.emailString,
            passwordTextField.rx.textInput.text <~> viewModel.passwordString,

            viewModel.signinEnabled ~> loginViaEmailButton.rx.isEnabled.asObserver(),

            viewModel.signinEnabled.filter { $0 }.subscribe(onNext: { [unowned self] _ in
                self.loginViaEmailButton.backgroundColor = Colors.enabledButtonGrayColor.color()
            }),

            viewModel.signinEnabled.filter { !$0 }.subscribe(onNext: { [unowned self] _ in
                self.loginViaEmailButton.backgroundColor = Colors.disabledButtonGrayColor.color()
            }),

            loginViaEmailButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
                self.viewModel.signinByEmail()
            }),
            
            loginViaFBButton.rx.tap.subscribe(onNext: { _ in
                self.view.endEditing(true)
                self.viewModel.signinByFacebook(viewController: self)
            }),
            
            forgetPassButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.openForgotPasswordVC()
            }),

            registerViaEmailButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                let vc = SignupViewController(nibName: R.nib.signupViewController.name, bundle: nil)
                self.onOpenEmailVerifyVC = vc.onOpenEmailVerifyVC
                self.present(vc, animated: true, completion: nil)
                
                self.onOpenEmailVerifyVC.subscribe(onNext: { [unowned self] model in
                    let vc = EmailVerificationViewController(nibName: R.nib.emailVerificationViewController.name,
                                                             bundle: nil)
                    vc.viewModel = model
                    self.present(vc, animated: false, completion: nil)
                }).disposed(by: self.disposeBag)
            }),
            
            eyeButton.rx.tap.subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
            }),
            
            viewTapGesture.rx.event.bind(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            }),
            
            viewModel.onWillStartSignin.subscribe(onNext: { [unowned self] _ in
                self.showLoading(status: "", showInView: nil)
            }),
            
            viewModel.onWillStopSignin.subscribe(onNext: { [unowned self] _ in
                self.hideLoading(showInView: nil)
            }),
            
            viewModel.onEmailRequired.subscribe(onNext: { [unowned self] _ in
                self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField,
                                           text: R.string.localizable.errorFieldIsRequired())
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
                if error == GigyaCodeEnum.accountPendingVerification {
                    self.showAlertAccountPendingVerification()
                } else if error == GigyaCodeEnum.loginFailedCaptchaRequired {
                    let okAction = AlertAction(title: R.string.localizable.loginRetrieve_password(), handler: {
                        self.openForgotPasswordVC()
                    })
                    self.alert(title: nil,
                               message: R.string.localizable.loginClick_link_retrieve_password(),
                               action: okAction)
                } else {
                    if let text = error.errorString(), !text.isEmpty {
                        self.showMessage(message: text)
                    }
                }
            })
        ])
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(emailTextField) {
            passwordTextField.becomeFirstResponder()
            return false
        }
        if textField.isEqual(passwordTextField) {
            self.view.endEditing(true)
            self.viewModel.signinByEmail()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(emailTextField) {
            self.setErrorTextAndErrorStatus(errorLabel: self.emailErrorLabel, textField: self.emailTextField,
                                            text: "")
        } else if textField.isEqual(passwordTextField) {
            self.setErrorTextAndErrorStatus(errorLabel: self.passErrorLabel, textField: self.passwordTextField,
                                            text: "")
        }
        return true
    }
}
